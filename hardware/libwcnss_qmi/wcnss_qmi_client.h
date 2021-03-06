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
#if defined(__BIONIC_FORTIFY)
#include <sys/system_properties.h>
#endif

#define MODEM_BASEBAND_PROPERTY   "ro.baseband"
#if defined(__BIONIC_FORTIFY)
#define MODEM_BASEBAND_PROPERTY_SIZE  PROP_VALUE_MAX
#else
#define MODEM_BASEBAND_PROPERTY_SIZE  10
#endif
#define MODEM_BASEBAND_VALUE_APQ  "apq"
#define MODEM_BASEBAND_VALUE_MSM  "msm"

#if defined (WCNSS_QMI) || defined (WCNSS_QMI_OSS)
#ifndef WCNSS_QMI_CLIENT_H
#define WCNSS_QMI_CLIENT_H

int wcnss_init_qmi(void);
int wcnss_qmi_get_wlan_address(unsigned char *pBdAddr);
void wcnss_qmi_deinit(void);

#endif
#endif
