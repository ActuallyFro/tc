WorkingDir=`echo $0 | sed 's/\/tc.sh//g'| sed 's/tc.sh//g'`
if [[ "$WorkingDir" == "" ]]; then
  WorkingDir=`which tc`
fi
echo "[Debug] This is the location of tc: $WorkingDir"

source $WorkingDir/include/functions.sh


OType_1=$1
IName_2=$2
OName_3=$3

OTypes=(pdf html pptx docx wiki all)

#File Checks
#===========
#Output Type
#-----------------
if [[ "$OType_1" == "" ]]; then echo "No file type provided!"; exit; fi
ValidType="false"
AllType="false"
for i in ${OTypes[@]}; do
  if [[ "$i" == "$OType_1" ]]; then
      ValidType="true"
      if [[ "all" == "$OType_1" ]]; then
        AllType="true"
      fi
   fi
done
if [ "$ValidType" == "false" ]; then echo "File Output Type not supported!"; exit; fi

#Input File EXISTS
#-----------------
if [[ "$IName_2" == "" ]]; then echo "File Does NOT exist!"; exit; fi
if [ ! -f $IName_2 ]; then echo "File Does NOT exist!"; exit; fi

#funtion_CheckEmpty($FileName)

if [[ "pdf" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
   #echo "[Debug] In the pdf loop"
   if [[ "true" == "$AllType" ]]; then
     OType_1="pdf"
   fi
   OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"."type}'`
   echo "Staring $OType_1 generation...Creating file: $OName_3"

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

   #BuildStr=$BuildStr"--toc -V geometry:margin=1.125in -V linkcolor=black"
   BuildStr=$BuildStr"-V geometry:margin=1.125in -V linkcolor=black"

   echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
   pandoc -i $IName_2 $BuildStr -o $OName_3
   if [[ "true" == "$AllType" ]]; then
     OType_1="all"
   fi
fi

if [[ "html" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
  echo "[Debug] In the html loop"
  if [[ "true" == "$AllType" ]]; then
    OType_1="html"
  fi
  OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"."type}'`
  echo "Staring $OType_1 generation...Creating file: $OName_3"

  if [[ "true" == "$AllType" ]]; then
    OType_1="all"
  fi
fi

if [[ "pptx" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
  echo "[Debug] In the pptx loop"
  if [[ "true" == "$AllType" ]]; then
    OType_1="pptx"
  fi
  OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"."type}'`
  echo "Staring $OType_1 generation...Creating file: $OName_3"

  if [[ "true" == "$AllType" ]]; then
    OType_1="all"
  fi
fi

if [[ "docx" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
  echo "[Debug] In the docx loop"
  if [[ "true" == "$AllType" ]]; then
    OType_1="docx"
  fi
  OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"."type}'`
  echo "Staring $OType_1 generation...Creating file: $OName_3"

  if [[ "true" == "$AllType" ]]; then
    OType_1="all"
  fi
fi

if [[ "wiki" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
  if [[ "true" == "$AllType" ]]; then
    OType_1="wiki"
  fi
  echo "[Debug] In the wiki loop"
  OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"."type}'`
  echo "Staring $OType_1 generation...Creating file: $OName_3"
   BuildStr=""

   BibName=`echo "$IName_2" | tr "." " " | awk '{print $1".bib"}'`
   if [ -f $BibName ]; then
     BuildStr=$BuildStr"--filter=pandoc-citeproc --bibliography=$BibName "
   fi

   BuildStr=$BuildStr"--table-of-contents -s -t mediawiki"

   echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
   pandoc -i $IName_2 $BuildStr -o $OName_3
   if [[ "true" == "$AllType" ]]; then
     OType_1="all"
   fi
fi

echo "Done! Built $OType_1."
