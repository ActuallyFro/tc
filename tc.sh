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

#this could all be the same if awk was passed the type as a var...
if [[ "pdf" == "$OType_1" ]]; then
   echo "Staring pdf generation..."
   OName_3=`echo "$IName_2" | tr "." " " | awk '{print $1".pdf"}'`
   echo "Creating file: $OName_3"
elif [[ "html" == "$OType_1" ]]; then
  echo "Staring html generation..."
  OName_3=`echo "$IName_2" | tr "." " " | awk '{print $1".html"}'`
  echo "Creating file: $OName_3"
elif [[ "pptx" == "$OType_1" ]]; then
  echo "Staring pptx generation..."
  OName_3=`echo "$IName_2" | tr "." " " | awk '{print $1".pptx"}'`
  echo "Creating file: $OName_3"
elif [[ "docx" == "$OType_1" ]]; then
  echo "Staring docx generation..."
  OName_3=`echo "$IName_2" | tr "." " " | awk '{print $1".docx"}'`
  echo "Creating file: $OName_3"
fi
