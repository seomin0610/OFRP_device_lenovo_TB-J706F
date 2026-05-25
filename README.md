<img width="1500" height="500" alt="image" src="https://github.com/user-attachments/assets/956d1771-a559-4573-a1e7-3201eb828b59" />

OrangeFox Recovery Project (OFRP) for Lenovo TB-J706F
======================================

## How to build
Check OFRP official guide https://wiki.orangefox.tech/en/dev/building
```bash
cd ~/fox_12.1
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=pearl_prc_wifi
export LC_ALL="C"
source build/envsetup.sh
lunch twrp_pearl_prc_wifi-eng
mka adbd recoveryimage 2>&1 | tee build.log
```

## How to flash

(in bootloader)
```bash
fastboot flash vbmeta --disable-verity --disable-verification vbmeta.img
fastboot flash vbmeta_system --disable-verity --disable-verification vbmeta_system.img
fastboot reboot bootloader
```
The vbmeta.img and vbmeta_system.img files are included in the official firmware. [Download firmware](https://mirrors-obs-1.lolinet.com/firmware/lenowow/2020/Tab_P11_Pro/TB-J706F/)
```bash
fastboot flash recovery ~/fox_12.1/out/target/product/pearl_prc_wifi/OrangeFox-R12.0-Unofficial-pearl.img
fastboot reboot recovery
```

## Device specifications

Feature   | Specification
-------:|:-------------------------
CPU     | Octa-core (2x2.2 GHz Kryo 470 Gold & 6x1.8 GHz Kryo 470 Silver)
CHIPSET | Qualcomm SM7150 Snapdragon 730G
GPU     | Adreno 618
Memory  | 6GB
Shipped Android Version | 10
Storage | 128GB
Battery | 8600 mAh
Dimensions | 264.28 x 171.4 x 5.8 mm
Display | 2560 x 1600 pixels, 11.5" OLED
Rear Camera  | 13MP + 5MP
Front Camera | 8MP + 8MP

<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/f8222ac0-1d1f-4cec-b5fb-fc19b3b1273b" />
