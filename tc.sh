WorkingDir=`pwd`
source ./include/functions.sh

OType_1=$1
IName_2=$2
OName_3=$3

OTypes=(pdf html pptx docx)

#File Checks
#===========
#Output Type
#-----------------
if [[ "$OType_1" == "" ]]; then echo "No file type provided!"; exit; fi
ValidType="false"
for i in ${OTypes[@]}; do
   if [[ "$i" == "$OType_1" ]]; then
      ValidType="true"
   fi
done
if [ "$ValidType" == "false" ]; then echo "File Output Type not supported!"; exit; fi

#Input File EXISTS
#-----------------
if [[ "$IName_2" == "" ]]; then echo "File Does NOT exist!"; exit; fi
if [ ! -f $IName_2 ]; then echo "File Does NOT exist!"; exit; fi

#funtion_CheckEmpty($FileName)
