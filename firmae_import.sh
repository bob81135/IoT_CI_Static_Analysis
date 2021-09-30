firmAE_path="/home/an/FirmAE"
firmware_id=${1}
filename=${2}

${firmAE_path}/scripts/mount.sh ${firmware_id}
cp ${filename} ${firmAE_path}/scratch/${firmware_id}/image/etc/${filename}
sed -i '1a /etc/'${filename}'\n' ${firmAE_path}/scratch/${firmware_id}/image/etc/init.d/rcS
${firmAE_path}/scripts/umount.sh ${firmware_id}
