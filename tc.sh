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

OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"."type}'`
echo "Staring $OType_1 generation...Creating file: $OName_3"
if [[ "pdf" == "$OType_1" ]]; then
   #echo "[Debug] In the pdf loop"

   BuildStr=""
   BibName=`echo "$IName_2" | tr "." " " | awk '{print $1".bib"}'`
   if [ -f $BibName ]; then
      BuildStr=$BuildStr"--bibliography $BibName "
   fi

   AuthorFile="authorinfo.yml"
   if [ -f $AuthorFile ]; then
      BuildStr=$BuildStr"-s $AuthorFile "
   fi

   CslName=`ls | grep csl`
   if [[ ! "$CslName" == "" ]]; then
      BuildStr=$BuildStr"--csl $CslName "
   fi

   BuildStr=$BuildStr"--toc -V documentclass=report -V geometry:margin=1.125in -V linkcolor=black"

   echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
   pandoc -i $IName_2 $BuildStr -o $OName_3

elif [[ "html" == "$OType_1" ]]; then
  echo "[Debug] In the html loop"
elif [[ "pptx" == "$OType_1" ]]; then
  echo "[Debug] In the pptx loop"
elif [[ "docx" == "$OType_1" ]]; then
  echo "[Debug] In the docx loop"
fi

echo "Done!"
