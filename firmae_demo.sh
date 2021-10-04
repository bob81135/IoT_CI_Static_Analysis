#!/bin/bash
#input
exec 5<&1
exec 6<&2
exec >/dev/null 2>&1
uuid=${1}
machine_id=${2}
code_root_folder=${3}
log_root_folder=${4}
#setting path
FirmAE_path=${HOME}"/FirmAE"
file_path=${code_root_folder}${uuid}
arm_compiler_path=${HOME}"/IoT_CI_Static_Analysis/armel_2.6.36.4/host/usr/bin/arm-linux-gcc"
mipseb_compiler_path=${HOME}"/IoT_CI_Static_Analysis/mipseb-2.6.36/usr/bin/mips-buildroot-linux-uclibc-gcc"
mipsel_compiler_path=${HOME}"/IoT_CI_Static_Analysis/mipsel-2.6.36/usr/bin/mipsel-buildroot-linux-uclibc-gcc"
#static analysis
# create dir
cd ${log_root_folder}
mkdir -p ${uuid}/static

# setting path
log_path=${log_root_folder}${uuid}"/static"
cd ${file_path}
#find all .c file
tag=$(find . -type f -name "*.c")
#static analysis
for i in ${tag};
do
    cd ${log_path}
    # if dir not found create it
    path=$(dirname $i)
    if   [ -d "${log_path}/$path" ]; then
        :
    else
        mkdir -p ${log_path}/${path}
    fi
    ${HOME}/cppcheck-2.5/cppcheck -q --template='{file}\n{line}\n{callstack}\n{severity}\n{message}\n{id}\n{code}' ${file_path}/${i} --output-file=${log_path}"/"${i}".log"
done

#compile
#get arch and ip
arch=`cat ${FirmAE_path}/scratch/${machine_id}/architecture`
ip=`cat ${FirmAE_path}/scratch/${machine_id}/ip`
cd ${file_path}
make clean
rm ${uuid}
#complier
case "$arch" in
    "armel") 
    echo "armel"
    make CC=${arm_compiler_path} EXEC=${uuid} CFLAGS="-O2 -g -Wall -I include -std=gnu99"
    ;;
    "mipseb")    
    echo "mipseb"
    make CC=${mipseb_compiler_path} EXEC=${uuid} CFLAGS="-O2 -g -Wall -I include -std=gnu99"
    ;;
    "mipsel")    
    echo "mipsel"
    make CC=${mipsel_compiler_path} EXEC=${uuid} CFLAGS="-O2 -g -Wall -I include -std=gnu99"
    ;;
    *)
    :
    ;;
esac

# compile error
echo $?
if   [ $? -ne 0 ]; then
    echo "failed" >&5
    exit
fi
#mount filesystem
cd ${FirmAE_path}
${FirmAE_path}/scripts/mount.sh ${machine_id}

#cp binary to filesystem
rm -r ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/test
mkdir ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/test
cp ${file_path}/${uuid} ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/test/${uuid}

#chmod
chmod a+x ${FirmAE_path}/scratch/${machine_id}/image/etc/${uuid}
#add sh in init.d
rm ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/S00${uuid}.sh
echo "/etc/init.d/test/${uuid} 80 &" >> ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/S00${uuid}.sh

#chmod
chmod a+x ${FirmAE_path}/scratch/${machine_id}/image/etc/init.d/S00${uuid}.sh
#umount filesystem
${FirmAE_path}/scripts/umount.sh ${machine_id}

#run emulation
${FirmAE_path}/scratch/${machine_id}/run.sh & 
sleep 5m

ping -c 1 -w 1 ${ip} && result=0 || result=1
# ping error
if   [ ${result} -ne 0 ]; then
    echo "failed"  >&5
    exit
fi


# call dynamic analysis
echo ${uuid}
echo ${ip}
echo "success"  >&5