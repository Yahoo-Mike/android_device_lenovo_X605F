# device tree for Lenovo Smart Tab M10 wifi (TB-X605F)

## Release info
This is a work in progress.

### About Device

![Lenovo Smart Tab M10](https://static.lenovo.com/ww/campaigns/2019/smarttab/lenovo-smart-tab-gallery-5.jpg "Lenovo Smart Tab M10 (TB-X605F)")

## tablet
Recovery Device Tree for Lenovo Tab/Smart Tab M10 wifi (TB-X605F)
=================================================================
Component   | Specs
-------:|:-------------------------
Chipset| Qualcomm Snapdragon 450 (SDM450)
CPU | ARM Cortex-A53, Octa-Core, 1.8 GHz
GPU     | Qualcomm Adreno 506, 650 MHz
Memory  | 3 GB (soldered)
Shipped Android Version | 8.0 (Oreo), upgrade to 9.0 (Pie)
Storage | 32 GB (eMPC)
MicroSD | Up to 256 GB
Battery | 4850 mAh, Li-Po (non-removable)
Display | 1920x1200 pixels, 10.1", 224 px/in
Front Camera | 2.0 MP, fixed focus
Rear Camera  | 5.0 MP, auto focus
Wifi | dual band, 802.11a/ac/b/g/n 802.11n 5GHz
Bluetooth | v4.2
USB | USB-C charging/storage/OTG
Release Date | August 2018

## dock (with Alexa)
Component   | Specs
-------:|:-------------------------
audio | 2 x 3W full-range speakers
microphone | 3 fair-field mics (DSP DBMD5VT181P4BNl)
bluetooth | Actions Semiconductor ATS2825
power | 12V 2A

To build:

```
source build/envsetup.sh
brunch lineage_X605F-eng
```

