<img width="1500" height="500" alt="image" src="https://github.com/user-attachments/assets/956d1771-a559-4573-a1e7-3201eb828b59" />

OrangeFox Recovery Project (OFRP) for Lenovo TB-J706F
======================================

## How to build
Check OFRP official guide https://wiki.orangefox.tech/en/dev/building
> [!NOTE]
>For those building the recovery themselves:
If you build the firmware without any modifications, selecting Reboot to System in OrangeFox may boot back into OrangeFox instead of Android.
This happens because TWRP's `clear_bootloader_message()` cannot locate the `/misc` partition due to differences in the fstab format.
To work around this issue, either reboot into the bootloader and run `fastboot erase misc` followed by `fastboot reboot`, or modify `static void reboot()` in `~/fox_12.1/bootable/recovery/twrp.cpp` as shown below before building.

<details>
  <summary>Modification instructions:</summary>
  
Modify the following section in `static void reboot()` as shown below:  
  
```
  ...
	else if (Reboot_Arg == "fastboot")
		TWFunc::tw_reboot(rb_fastboot);
	else {
		// clear misc
		std::string misc_path = "";
		if (TWFunc::Path_Exists("/dev/block/by-name/misc")) {
		    misc_path = "/dev/block/by-name/misc";
		}
		if (!misc_path.empty()) {
		    std::string cmd = "dd if=/dev/zero of=" + misc_path + " bs=4096 count=1 2>/dev/null";
		    TWFunc::Exec_Cmd(cmd);
		    LOGINFO("misc cleared: %s\n", misc_path.c_str());
		} else {
		    LOGINFO("misc partition not found!\n");
		}
		
		TWFunc::tw_reboot(rb_system);
	}
```

</details>

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

## If the folder names in `/data/` look weird

The folders are encrypted (FBE), so their names look like base64 garbage until
`/data` is decrypted.

> [!NOTE]
> An earlier version of this README blamed the 4.14 kernel and the
> `BINDER_SET_MAX_THREADS` ioctl for this. That was wrong on both counts, and
> no custom kernel is needed. See below.

### What actually blocked decryption

The recovery ramdisk had no device VINTF manifest, so **no HIDL service in
recovery could register at all** - including the keymaster that decryption
needs.

`libhidlbase` is built with `-DENFORCE_VINTF_MANIFEST`, so `registerAsService()`
first asks hwservicemanager for the interface's transport and gives up unless it
is `HWBINDER` (`system/libhidl/transport/ServiceManagement.cpp`):

```
Service android.hardware.keymaster@4.0::IKeymasterDevice/default
must be in VINTF manifest in order to register/get.
```

That transport comes from the device HAL manifest, and
`VintfObject::fetchDeviceHalManifest()` (`system/libvintf/VintfObject.cpp`) only
reads the fragment directory `/vendor/etc/vintf/manifest/` **after
`/vendor/etc/vintf/manifest.xml` itself parses**. There was no such file in the
ramdisk, no `/odm`, and no legacy `/vendor/manifest.xml`, so the device manifest
came out empty - which also meant the `boot@1.1`, `boot@1.2` and `health@2.1`
fragments the build already installs there were being ignored.

So `android.hardware.keymaster@4.0-service-qti` started, failed to register, and
exited; keystore2 then had no keymaster to talk to.

### Why it is not a kernel problem

- OrangeFox here does not build a kernel at all. `BoardConfig.mk` sets
  `TARGET_FORCE_PREBUILT_KERNEL := true` with
  `TARGET_PREBUILT_KERNEL := device/lenovo/pearl_prc_wifi/prebuilt/kernel`, i.e.
  the **stock** kernel out of the stock `boot.img`.
- `BINDER_SET_MAX_THREADS` has been in the binder driver since long before 4.14,
  and when the ioctl does fail `ProcessState::open_driver()` only logs
  `ALOGE("Binder ioctl to set max threads failed")` and keeps the fd. The only
  fatal case there is a `BINDER_VERSION` mismatch. That log line is a red
  herring, not a reason for keystore2 to die.
- The same stock 4.14 kernel runs keystore2 fine in the LineageOS port of this
  device, where `/data` does get decrypted.

### The fix

`recovery/root/vendor/etc/vintf/manifest.xml`, declaring what the device
actually registers on stock (`lshal`:
`android.hardware.keymaster@4.0::IKeymasterDevice/default`):

```xml
<manifest version="2.0" type="device">
    <hal format="hidl">
        <name>android.hardware.keymaster</name>
        <transport>hwbinder</transport>
        <version>4.0</version>
        <interface>
            <name>IKeymasterDevice</name>
            <instance>default</instance>
        </interface>
        <fqname>@4.0::IKeymasterDevice/default</fqname>
    </hal>
</manifest>
```

Declare `@4.0`, not `@4.1`: `getService()` matches the fqname exactly, so a
`@4.1` declaration leaves every client waiting forever. For the same reason
`init.recovery.qcom.rc` now starts `vendor.keymaster-4-0` only.

To check on the device:

```bash
adb shell getprop init.svc.vendor.keymaster-4-0   # expect: running
adb shell lshal | grep keymaster
```

If `must be in VINTF manifest` no longer shows up in the recovery log, this wall
is cleared. Whether `/data` then actually unlocks still needs a real-hardware
test - that has not been done yet.

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
