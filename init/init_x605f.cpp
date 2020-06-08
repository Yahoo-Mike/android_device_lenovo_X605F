/*
   Copyright (c) 2015, The Linux Foundation. All rights reserved.
   Copyright (C) 2016 The CyanogenMod Project.
   Copyright (C) 2017-2018 The LineageOS Project.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <android-base/properties.h>
#include <android-base/logging.h>
#include <android-base/file.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "vendor_init.h"
#include "property_service.h"

#define PROP_BOOT_BASEBAND "ro.boot.baseband"

using android::base::GetProperty;
using android::init::property_set;
using android::base::ReadFileToString;


void property_override(const char prop[],const char value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi,value,strlen(value));
    else
        __system_property_add(prop,strlen(prop),value,strlen(value));
}

void property_override_dual(const char system_prop[], const char vendor_prop[], const char value[])
{
	property_override(system_prop,value);
	property_override(vendor_prop,value);
}

static void set_fingerprint()
{
    const char* fingerprint = "Lenovo/LenovoTB-X605F/X605F:9/PKQ1.190319.001/S210126_191029_ROW:user/release-keys";
    std::string baseband = GetProperty(PROP_BOOT_BASEBAND, "");
    if (baseband == "apq") {
        property_override("ro.build.description","tab5_m10_row_wifi-user 9 PKQ1.190319.001 TB-X605F_U release-keys");
        property_override("ro.build.product","tab5_m10_row_wifi");
        property_override("ro.product.device","X605F");
        property_override("ro.bootimage.build.fingerprint",fingerprint);
        property_override("ro.build.fingerprint",          fingerprint);
        property_override("ro.vendor.build.fingerprint",   fingerprint);
        property_override("ro.product.model","Lenovo TB-X605F");
	property_override("ro.product.ota.model","Lenovo TB-X605F_ROW");

        property_override_dual("ro.product.name","ro.vendor.product.name","LenovoTB-X605F");

    } else if (baseband == "msm") {
        // PLACEHOLDER - X605L
    }
}

static void setprop_from_persist_key(const char* filename, const char* prop) {
    std::string data;

    if (!ReadFileToString(filename, &data)) {
        LOG(ERROR) << "Failed to load property file [" << filename << "]" ;
        property_set(prop, "0");
        return;
    }

    if (data.empty()) {
        LOG(ERROR) << "setprop_from_persist_key() prop [" << prop << "] is empty";
        property_set(prop, "0");
        return;
    }

    property_set(prop, "1");
    return;
}

static void setprop_from_persist_countrycode(const char* filename, const char* prop) 
{
    std::string data;
    const char *countrycode;
    int len;

    if (!ReadFileToString(filename, &data)) {
        LOG(ERROR) << "Failed to load property file [" << filename << "]" ;
        return;
    }

    if (data.empty() ||  data.length() < 2) {
        LOG(ERROR) << "setprop_from_persist_countrycode() prop [" << prop << "] is empty";
        return;
    }

    countrycode = data.c_str();
    len = data.length();

    //
    // note: Lenovo's original code checked for & set the following.  They are used in constructing the build fingerprint.
    //       Code for 'D' was commented out & never set.
    //
    //       countrycode[2] = 'D' commented out, but would have set [ro.lenovo_def_pro_dock] : [1]
    //                        seems to signify 'Dock' (HA-200 docking station with Alexa?)
    //
    //       countrycode[2] = 'R' sets [ro.lenovo_def_pro_rsa]: [1]
    //                      ==> for all countrycodes,       set [ro.com.google.clientidbase]:    [android-lenovo]
    //                          for countrycode=="JP",      set [ro.com.google.clientidbase.ms]: [android-lenovo-rev1]
    //                          for countrycode=="RU",      set [ro.com.google.clientidbase.ms]: [android-lenovo-rev2]
    //                          for all other countrycodes, set [ro.com.google.clientidbase.ms] & [ro.com.google.clientidbase.am]: [android-lenovo]
    //
    //       countrycode[last_char] = 'E' sets [ro.lenovo_def_pro_eea]: [1]
    //                                presumably this is European Economic Area
    //                              ==> appends "-EEA" to [ro.product.name] & [ro.vendor.product.name] & in ro.build & ro.vendor.build fingerprints
    //                         
    if (data.length() >= 3 && countrycode[data.length()-1] == 'E')
        len -= 1;

    if (data.length() >= 3 && countrycode[2] == 'R')
        len = 2;

    // set countrycode property
    property_set(prop, data.substr(0,len));

    return;
}

static void setprop_from_persist( const char* filename, const char* prop ) 
{
    std::string data;
    std::string err;
    std::string prop_val = android::base::GetProperty(prop, "");

    if (prop_val.empty()) {

        if (!ReadFileToString(filename, &data)) {
            LOG(ERROR) << "Failed to load property file [" << filename << "]" ;
            return;
        }
        property_set(prop, &data[0]);
        prop_val = android::base::GetProperty(prop, "");
    }

    if (prop_val.empty() || !prop_val.compare("00:00:00:00:00:00") || prop_val.length() < 2) {
        LOG(ERROR) << "setprop_from_persist() prop: " << prop << " is empty";
        return;
    }

    return;
}

// populates other props with values we've just read from persist storage
static void set_psn_and_gsn() 
{

    std::string psn = android::base::GetProperty("gsm.pcbaserialno", "");
    if(!psn.empty() && psn.length() > 2) {
       property_set("gsm.sn1", psn);
       property_set("gsm.sn",  psn);
    }

    std::string gsn = android::base::GetProperty("gsm.serialno", "");
    std::string seria = android::base::GetProperty("ro.serialno", "");
    if(!gsn.empty() && gsn.length() > 2) {
        property_set("gsm.lenovosn2",   gsn);
        property_set("sys.lenovosn",    gsn);
	property_override("ro.serialno",gsn.c_str()); 	// override LOS
    }

    std::string ccode = android::base::GetProperty("gsm.product.countrycode", "");
    if(!ccode.empty() && ccode.length() > 1) {
        property_set("ro.boot.wificountrycode", ccode.substr(0,2));
        property_set("ro.product.countrycode",  ccode);
    }
}


/*************************************************************************

 vendor_load_properties() is called by load_system_props()
 compile with TARGET_INIT_VENDOR_LIB for it to be compiled and linked.

 This code is simplified version of changes to property_service.cpp made
 by Lenovo from the X605F opensource (released June 2020).

 It sets properties from persist storage (/mnt/vendor/persist/nv), including
 device serialno, and bluetooth & wifi MAC addresses.  
 Also sets props needed for GPS.

 *************************************************************************/

void vendor_load_properties(void)
{
    setprop_from_persist("/mnt/vendor/persist/nv/bt",   "ro.vendor.bt.boot.macaddr");
    setprop_from_persist("/mnt/vendor/persist/nv/wifi", "ro.vendor.wcnss.nv");
    setprop_from_persist("/mnt/vendor/persist/nv/psn",  "gsm.pcbaserialno");
    setprop_from_persist("/mnt/vendor/persist/nv/gsn",  "gsm.serialno");
    // setprop_from_persist("/mnt/vendor/persist/nv/adbdebug", "ro.vendor.adbdebug");

    setprop_from_persist_countrycode("/mnt/vendor/persist/nv/ccode", "gsm.product.countrycode");

    // note: the following are encrypted.  So can only be read if /data is encrypted with same password as stock ROM.
    setprop_from_persist_key("/mnt/vendor/persist/data/widevine/widevine",       "gsm.product.widevinekeybox.id");
    setprop_from_persist_key("/mnt/vendor/persist/data/keymaster64/keymaster64", "gsm.product.masterkeybox.id");

    // populate other props with values we've just read from persist storage
    set_psn_and_gsn();

    // set build fingerprint
    set_fingerprint();
}

