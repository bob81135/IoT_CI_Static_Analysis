#!/bin/bash
arch=${1}
filename=${2}
output=${3}
arm_compiler_path="/home/an/armel_2.6.36.4/host/usr/bin/arm-linux-gcc"
mipseb_compiler_path="/home/an/mipseb-2.6.36/usr/bin/mips-buildroot-linux-uclibc-gcc"
mipsel_compiler_path="/home/an/mipsel-2.6.36/usr/bin/mipsel-buildroot-linux-uclibc-gcc"
case "$arch" in
    "arm") 
    echo "arm"
    ${arm_compiler_path} -static ${filename} -o ${output}
    ;;
    "mipseb")    
    echo "mipseb"
    ${mipseb_compiler_path} -static ${filename} -o ${output}
    ;;
    "mipsel")    
    echo "mipsel"
    ${mipsel_compiler_path} -static ${filename} -o ${output}
    ;;
    *)
    echo "error"
    ;;
esac

    
