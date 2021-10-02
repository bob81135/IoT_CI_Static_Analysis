#!/bin/bash
code_path=${HOME}"/"
#input
uuid=${1}
machine_id=${2}
#setting path
FirmAE_path=${HOME}"/FirmAE"
file_path=${code_path}${uuid}"/code"
arm_compiler_path=${HOME}"/IoT_CI_Static_Analysis/armel_2.6.36.4/host/usr/bin/arm-linux-gcc"
mipseb_compiler_path=${HOME}"/IoT_CI_Static_Analysis/mipseb-2.6.36/usr/bin/mips-buildroot-linux-uclibc-gcc"
mipsel_compiler_path=${HOME}"/IoT_CI_Static_Analysis/mipsel-2.6.36/usr/bin/mipsel-buildroot-linux-uclibc-gcc"

#get arch and ip
arch=`cat ${FirmAE_path}/scratch/${machine_id}/architecture`
ip=`cat ${FirmAE_path}/scratch/${machine_id}/ip`

cd ${file_path}
#complier
case "$arch" in
    "armel") 
    echo "armel"
    rm ${uuid}
    make CC=${arm_compiler_path} EXEC=${uuid}
    ;;
    "mipseb")    
    echo "mipseb"
    rm ${uuid}
    make CC=${mipseb_compiler_path} EXEC=${uuid}
    ;;
    "mipsel")    
    echo "mipsel"
    rm ${uuid}
    make CC=${mipsel_compiler_path} EXEC=${uuid}
    ;;
    *)
    echo "error"
    ;;
esac

#mount filesystem
cd ${FirmAE_path}
${FirmAE_path}/scripts/mount.sh ${machine_id}
#cp binary to filesystem
cp ${file_path}/${uuid} ${FirmAE_path}/scratch/${machine_id}/image/etc/${uuid}
#chmod
chmod a+x ${FirmAE_path}/scratch/${machine_id}/image/etc/${uuid}
#add sh in init.d
echo "/etc/${uuid} 80 &" >> ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/S00${uuid}.sh
#chmod
chmod a+x ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/S00${uuid}.sh
#umount filesystem
${FirmAE_path}/scripts/umount.sh ${machine_id}

#run emulation
${FirmAE_path}/scratch/${machine_id}/run.sh &>/dev/null 2>&1
sleep 5m
echo "finish"

# call dynamic analysis
echo ${uuid}
echo ${ip}