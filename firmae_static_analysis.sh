
# execute cppchek
filename=${1}
output=${2}
/home/an/cppcheck-2.5/cppcheck -q --template='{file}-{line}-{callstack}-{severity}-{message}-{id}\n{code}' ${filename} --output-file=${output}
