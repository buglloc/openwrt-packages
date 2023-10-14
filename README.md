## OpenWRT Packages
This repo includes packages which are missing in openwrt feeds or version is too old.

## GL.iNet

This packages is also suitable for GL.iNet devices.

### System requirements

- x86_64 platform
- Ubuntu or another linux distro

### Preparing your build environment

To use the SDK on your system will usually require you to install some extra packages.

For **Ubuntu 18.04 LTS**, run the following commands to install the required packages:

```
$ sudo apt update
$ sudo apt install asciidoc bash bc binutils bzip2 fastjar flex gawk gcc genisoimage gettext git intltool jikespg libgtk2.0-dev libncurses5-dev libssl1.0-dev make mercurial patch perl-modules python2.7-dev rsync ruby sdcc subversion unzip util-linux wget xsltproc zlib1g-dev zlib1g-dev -y
```

### Downloads

```
$ git clone https://github.com/gl-inet/sdk.git gl-sdk
$ git clone https://github.com/buglloc/openwrt-packages.git
```

For ease of use, GL.iNet store the SDK separately. You can download the specified SDK by the following command.

```
$ sd gl-sdk
$ ./download.sh
Usage:
./download.sh [target]   # Download the appropriate SDK

All available target list:
    ar71xx-1806     # usb150/ar150/ar300m16/mifi/ar750/ar750s/x750/x1200
    ath79-1907      # usb150/ar150/ar300m/mifi/ar750/ar750s/x750/x300b/xe300/e750/x1200 openwrt-19.07.7 ath79 target
    ramips-1806     # mt300n-v2/mt300a/mt300n/n300/vixmini
    ramips-1907     # mt1300 mt300n-v2/mt300a/mt300n/n300/vixmini
    ipq806x-qsdk53  # b1300/s1300
    ipq_ipq40xx-qsdk11  # b1300/s1300/ap1300/b2200 (version 3.201 and above)
    ipq_ipq60xx-qsdk11  # ax1800
    mvebu-1907      # mv1000
    siflower-1806   # sf1200/sft1200
    ipq807x-2102   # ax1800/axt1800 (version 4.x and above)
```

### Compiling
GL.iNet provide a script to compile all software packages with all targets SDK or compile all software packages with a single target SDK. You are freely to build packages for the specified platform,

```
$ ./builder.sh -d ../openwrt-packages -t [target]
```

Or run the following command to compile packages for all platform,

```
$ ./builder.sh -d ../openwrt-packages -a
```
