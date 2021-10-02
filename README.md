# FirmAE_CI

## usage 
### firmae_static_analysis.sh
```
setting:
file_path=${HOME}"/"${uuid}"/code"  #Where  source code is
run:
sh ./firmae_static_analysis.sh <UUID>
```
### firmae_cimpil.sh
```
setting:
FirmAE_path=${HOME}"/FirmAE"   # Where FirmAE is
file_path=${HOME}"/"${uuid}"/code"  #Where  source code is
arm_compiler_path=${HOME}"/IoT_CI_Static_Analysis/armel_2.6.36.4/host/usr/bin/arm-linux-gcc" #Where  cross_compile arm  is
mipseb_compiler_path=${HOME}"/IoT_CI_Static_Analysis/mipseb-2.6.36/usr/bin/mips-buildroot-linux-uclibc-gcc" #Where  cross_compile mipseb  is
mipsel_compiler_path=${HOME}"/IoT_CI_Static_Analysis/mipsel-2.6.36/usr/bin/mipsel-buildroot-linux-uclibc-gcc" #Where  cross_compile mipsel  is

run:
sh ./firmae_cimpil.sh <UUID><machine_id>
```
