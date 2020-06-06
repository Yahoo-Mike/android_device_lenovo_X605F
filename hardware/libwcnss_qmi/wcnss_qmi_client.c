/*--------------------------------------------------------------------------
Copyright (c) 2013, The Linux Foundation. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of The Linux Foundation nor
      the names of its contributors may be used to endorse or promote
      products derived from this software without specific prior written
      permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------------------*/

/*****************************************************************************
 * libwcnss_qmi.so provides the wifi MAC address.  If it fails, wlan0 gets
 * an auto-generated random MAC (like 00:0a:f5:2b:eb:4c).  LOS guidelines
 * require a device's real MAC address to be loaded, not a random MAC.
 *
 *****************************************************************************
 *
 * This code is based on the trail-blazing work done for the YT-X703 on LOS.
 *
 *****************************************************************************
 *
 * Lenovo have not released the X605F source for hardware/qcom/wlan/wcnss-service,
 * so we use LOS wcnss_service (wlan-caf), which dlopens this shared library.
 *
 * For this to work, compile wlan-caf/wcnss-service with: 
 *    TARGET_USES_QCOM_WCNSS_QMI := true  (builds wcnss-service)
 *    TARGET_PROVIDES_WCNSS_QMI  := true  (our promise to provide libwcnss_qmi.so)
 *
 ******************************************************************************
 * 
 * On TB-X605F, MAC address is stored as a string in /mnt/vendor/persist/nv/wifi
 * The format is usual MAC address in hex: aa:bb:cc:dd:ee:ff 
 *
 * Later on, the WLAN MAC is written, based on the result we provide, in the
 * /sys/devices/soc/a000000.qcom,wcnss-wlan/wcnss_mac_addr kernel sysfs entry
 * for the driver to process.
 *
 *****************************************************************************/

#ifdef WCNSS_QMI
#define LOG_TAG "wcnss_qmi"
#include <cutils/log.h>
#include "wcnss_qmi_client.h"
#include <cutils/properties.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <math.h>

#define SUCCESS 0
#define FAILED -1

#define WLAN_ADDR_SIZE   6	
#define WLAN_MAC_ADDR_STRING 18		// "aa:bb:cc:dd:ee:ff\0"

// forward declarations
static int get_wlan_mac_from_persist(unsigned char *mac_addr);

// libwcnss_qmi API
int wcnss_init_qmi(void)
{
	char ro_baseband[MODEM_BASEBAND_PROPERTY_SIZE];

	ALOGI("%s: Initialize wcnss QMI Interface", __func__);

	// check property [ro.baseband]
	//	apq = TB-X605F  (wifi variant)
	// ???	msm = TB-X605L  (LTE variant)    <-- needs to be confirmed
	
	memset(ro_baseband, 0, sizeof(ro_baseband));
	property_get(MODEM_BASEBAND_PROPERTY, ro_baseband, "");

	if (strcmp(ro_baseband, MODEM_BASEBAND_VALUE_MSM) == 0) {
 		ALOGI("%s: Running on TB-X605L", __func__);

		// PLACEHOLDER: this is where you'd use Device Management 
		//		Services (dms) to get info about LTE modem
	}
	else if (strcmp(ro_baseband, MODEM_BASEBAND_VALUE_APQ) == 0) {
		ALOGI("%s: Running on TB-X605F", __func__);
		// no baseband modem on wifi variant
	} else {
		ALOGE("%s: Running on unknown hardware (ro.baseband=%s)",
		      __func__, ro_baseband);
	}

	// never fail - we'll get MAC address later from persist storage
	return SUCCESS;
}

int wcnss_qmi_get_wlan_address(unsigned char *pBdAddr)
{
	if (pBdAddr == NULL) {
		ALOGE("%s: pBdAddr is NULL", __func__);
		return FAILED;
	}

	// PLACEHOLDER: this is where you'd use dms to get mac_addr for X605L

	int rc = get_wlan_mac_from_persist(pBdAddr);
	if (rc == FAILED) 
		ALOGE("%s: Failed to read WLAN MAC Address", __func__);

	return rc;
}

void wcnss_qmi_deinit()
{
	ALOGI("%s: Deinitialize wcnss QMI Interface", __func__);

	// PLACEHOLDER: this is where you'd release resources for X605L
}

//
// On TB-X605F, MAC address is stored as a string in /mnt/vendor/persist/nv/wifi
// The format is usual MAC address in hex: aa:bb:cc:dd:ee:ff 
//
static int get_wlan_mac_from_persist(unsigned char *mac_addr)
{
	const char *filename = "/mnt/vendor/persist/nv/wifi";
	FILE *fd;
	char buf[WLAN_MAC_ADDR_STRING];
	int  mac_tmp_buf[WLAN_ADDR_SIZE];

	int  rc = FAILED;

	fd = fopen(filename, "r"); // read only from persist
	if (!fd) {
		ALOGE("open '%s' failure %s.", filename, strerror(errno));
		goto out_noop;
	}

	memset(buf, 0, sizeof(buf));
	char *str = fgets(buf,sizeof(buf),fd);
	if (str==NULL) {
		ALOGE("%s: fgets returned %d", __func__, ferror(fd));
		rc = FAILED;
		goto out_close_fd;
	}

	rc = sscanf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
	           &mac_tmp_buf[0], &mac_tmp_buf[1], &mac_tmp_buf[2],
	           &mac_tmp_buf[3], &mac_tmp_buf[4], &mac_tmp_buf[5]);
	if (rc != WLAN_ADDR_SIZE) {
		ALOGE("%s: Failed to copy wifi MAC address", __func__);
		rc = FAILED;
		goto out_close_fd;
	}
	for (int i = 0; i < WLAN_ADDR_SIZE; i++) {
		mac_addr[i] = (unsigned char) mac_tmp_buf[i];
	}
	ALOGI("%s: WLAN MAC Address read from persist storage: "
	      "[%02x:%02x:%02x:%02x:%02x:%02x]", __func__,
	      mac_addr[0], mac_addr[1], mac_addr[2],
	      mac_addr[3], mac_addr[4], mac_addr[5]);

	rc = SUCCESS;
out_close_fd:
	fclose(fd);
out_noop:
	return rc;
}

#endif
