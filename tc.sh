source ./include/functions.sh

FileName=$1
OutputType=$2
OutputName=$3

#if [[ "$FileName" == "" ]]; then echo "No File Name provided!"; exit; fi
if [ ! -f $FileName ]; then echo "File Does NOT exist!"; exit; fi

#funtion_CheckEmpty($FileName)
