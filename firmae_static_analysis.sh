
# execute cppchek
code_path=${HOME}"/"
#uuid =>uuid
uuid=${1}
# create dir
mkdir ${code_path}${uuid}"/static"
# setting path
dir_path=${code_path}${uuid}"/code"
log_path=${code_path}${uuid}"/static"

cd ${dir_path}
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
        mkdir ${log_path}/${path}
    fi
    /home/an/cppcheck-2.5/cppcheck -q --template='{file}\n{line}\n{callstack}\n{severity}\n{message}\n{id}\n{code}' ${dir_path}/${i} --output-file=${log_path}"/"${i}".log"
done
