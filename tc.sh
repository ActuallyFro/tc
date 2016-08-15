#!/bin/bash
Version="0.1.2"

read -d '' HelpMessage << EOF
Text Compiler v$Version
====================
This 'tool' helps generate outputs for specific templates of documentation.
These are simply the formats I find the most useful when leveraging an .md file.
You may choose a single output format, or all formats, at runtime.

Supported Types
---------------
tc pdf <filename>
tc html <filename>
tc docx <filename>
tc wiki <filename>

The 'all' Option
----------------
tc all <filename> - builds all the above supported types.

Templates
---------
tc init <type> - see --templates

Other Options
-------------
--license - print license
--version - print version number
--templates - show options for available templates
--install - copy this script to /bin/$0
EOF

read -d '' TemplatesMsg << EOF
[WORK IN PROGRESS -- TBD FINISH]
Templates
=========
To help quickly document projects a few templates will be provided.
This is not all in inclusive, but I find these to be my most used types.

Report (tc init report)
-----------------------
This template will pull down the needed files to build an IEEE cited report.

NOTE: It will overwrite your tc_authorinfo.yml file!

eBook (tc init ebook)
---------------------
This template pulls down an example eBook template.

NOTE: It is NOT directly tc compatible; I just simply admire its formatting.

Thesis (tc init thesis)
-----------------------

Website  (tc init website)
--------------------------

EOF



read -d '' License << EOF
Copyright (c) 2016 Brandon Froberg

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF

WorkingDir=`echo $0 | sed 's/\/tc.sh//g'| sed 's/tc.sh//g'`
if [[ "$WorkingDir" == "" ]]; then
  WorkingDir=`which tc`
fi
#echo "[Debug] This is the location of tc: $WorkingDir"

OType_1=$1
IName_2=$2
OName_3=$3

OTypes=(pdf html docx wiki all init) #Add in : webppt

#File Checks
#===========
#Output Type
#-----------------
if [[ "$OType_1" == "--help" ]] || [[ "$OType_1" == "-h" ]];then
   echo ""
   echo "$HelpMessage"
   exit
fi

if [[ "$OType_1" == "--version" ]];then
   echo ""
   echo "Version: $Version"
   echo "md5 (less last line): "`cat $0 | head -n -1 | md5sum | awk '{print $1}'`
   exit
fi

if [[ "$OType_1" == "--templates" ]];then
   echo ""
   echo "$TemplatesMsg"
   exit
fi

if [[ "$OType_1" == "--license" ]];then
   echo ""
   echo "$License"
   exit
fi

if [[ "$OType_1" == "--install" ]];then
   echo ""
   echo "Attempting to install $0 to /bin"

   User=`whoami`
   if [[ "$User" != "root" ]]; then
      echo "[WARNING] Currently NOT root!"
   fi
   cp $0 /bin/tc
   Check=`ls /bin/tc | wc -l`
   if [[ "$Check" == "1" ]]; then
      echo "tc installed successfully!"
   fi

   exit
fi

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
if [ "$ValidType" == "false" ]; then
   echo "File Output Type not supported!"
   exit
fi

#Input File EXISTS
#-----------------
if [[ "$IName_2" == "" ]];then
   if [[ "init" == "$OType_1" ]]; then
      echo "Init type missing!"; exit;
   else
      echo "Input file missing!"; exit;
   fi
else
   if [ ! -f $IName_2 ] && [[ "init" != "$OType_1" ]]; then echo "File Does NOT exist!"; exit; fi
fi


#funtion_CheckEmpty($FileName)

if [[ "pdf" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
   #echo "[Debug] In the pdf loop"
   if [[ "true" == "$AllType" ]]; then
     OType_1="pdf"
   fi
   OName_3=`echo "$IName_2" | tr "/" "\n" | grep "." | tr "." " " | grep [^[:blank:]] | awk -v type="$OType_1" '{print $1"."type}'`
   echo "Staring $OType_1 generation...Creating file: $OName_3"

   BuildStr=""
   #BibName=`echo "$IName_2" | tr "." " " | awk '{print $1".bib"}'`
   BibName=`ls | grep ".bib"`
   if [ -f $BibName ] && [[ "$BibName" != "" ]]; then
      BuildStr=$BuildStr"--bibliography $BibName "
   fi

   CslName=`ls | grep ".csl"`
   if [[ ! "$CslName" == "" ]]; then
      BuildStr=$BuildStr"--csl $CslName "
   fi

   AuthorFile="tc_authorinfo.yml"
   if [ -f $AuthorFile ]; then
      BuildStr=$BuildStr"-s $AuthorFile "
   fi

   #For a report: ""--toc -V documentclass:report"
   BuildStr=$BuildStr"-V geometry:margin=1.125in -V fontsize=12pt -V papersize=letter -V linkcolor=black"

   #echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
   pandoc -i $IName_2 $BuildStr -o $OName_3
   if [[ "true" == "$AllType" ]]; then
     OType_1="all"
   fi
fi

if [[ "html" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
  #echo "[Debug] In the html loop"
  if [[ "true" == "$AllType" ]]; then
    OType_1="html"
  fi
  OName_3=`echo "$IName_2" | tr "/" "\n" | grep "." | tr "." " " | grep [^[:blank:]] | awk -v type="$OType_1" '{print $1"."type}'`
  echo "Staring $OType_1 generation...Creating file: $OName_3"

  BuildStr=""
  #BibName=`echo "$IName_2" | tr "." " " | awk '{print $1".bib"}'`
  BibName=`ls | grep ".bib"`
  if [ -f $BibName ] && [[ "$BibName" != "" ]]; then
     BuildStr=$BuildStr"--bibliography $BibName "
  fi

  CslName=`ls | grep ".csl"`
  if [[ ! "$CslName" == "" ]]; then
     BuildStr=$BuildStr"--csl $CslName "
  fi

  AuthorFile="tc_authorinfo.yml"
  if [ -f $AuthorFile ]; then
     BuildStr=$BuildStr"-s $AuthorFile "
  fi

  FooterName=`ls | grep -i footer.html`
  if [ -f $FooterName ]; then
     BuildStr=$BuildStr"-A $FooterName "
  fi

  CssName=`ls | grep css`
  if [[ ! "$CssName" == "" ]]; then
     BuildStr=$BuildStr"-c $CssName "
  fi

  BuildStr=$BuildStr"--number-sections --table-of-contents "

  #echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
  pandoc -i $IName_2 $BuildStr -o $OName_3

  if [[ "true" == "$AllType" ]]; then
    OType_1="all"
  fi
fi

#if [[ "webppt" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
#   #echo "[Debug] In the pptx loop"
#   OType_1="ppt.html"
#
#   OName_3=`echo "$IName_2" | tr "." " " | awk -v type="$OType_1" '{print $1"_"type}'`
#   echo "Staring $OType_1 generation...Creating file: $OName_3"
#
#   BuildStr=""
#   #BibName=`echo "$IName_2" | tr "." " " | awk '{print $1".bib"}'`
#   BibName=`ls | grep ".bib"`
#   if [ -f $BibName ] && [[ "$BibName" != "" ]]; then
#      BuildStr=$BuildStr"--bibliography $BibName "
#   fi
#
#   CslName=`ls | grep ".csl"`
#   if [[ ! "$CslName" == "" ]]; then
#      BuildStr=$BuildStr"--csl $CslName "
#   fi
#
#   AuthorFile="tc_authorinfo.yml"
#   if [ -f $AuthorFile ]; then
#      BuildStr=$BuildStr"-s $AuthorFile "
#   fi
#
#   #For a report: ""--toc -V documentclass:report"
#   BuildStr=$BuildStr"-s --mathjax -t revealjs"
#
#   #echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
#   pandoc -i $IName_2 $BuildStr -o $OName_3
#   if [[ "true" == "$AllType" ]]; then
#     OType_1="all"
#   fi
#fi

if [[ "docx" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
   #echo "[Debug] In the docx loop"
   if [[ "true" == "$AllType" ]]; then
     OType_1="docx"
   fi
   OName_3=`echo "$IName_2" | tr "/" "\n" | grep "." | tr "." " " | grep [^[:blank:]] | awk -v type="$OType_1" '{print $1"."type}'`
   echo "Staring $OType_1 generation...Creating file: $OName_3"

   BuildStr=""
   #BibName=`echo "$IName_2" | tr "." " " | awk '{print $1".bib"}'`
   BibName=`ls | grep ".bib"`
   if [ -f $BibName ] && [[ "$BibName" != "" ]]; then
      BuildStr=$BuildStr"--bibliography $BibName "
   fi

   CslName=`ls | grep ".csl"`
   if [[ ! "$CslName" == "" ]]; then
      BuildStr=$BuildStr"--csl $CslName "
   fi

   AuthorFile="tc_authorinfo.yml"
   if [ -f $AuthorFile ]; then
      BuildStr=$BuildStr"-s $AuthorFile "
   fi

   #For a report: ""--toc -V documentclass:report"
   BuildStr=$BuildStr"-V geometry:margin=1.125in -V fontsize=12pt -V papersize=letter -V linkcolor=black"

   #echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
   pandoc -i $IName_2 $BuildStr -o $OName_3
   if [[ "true" == "$AllType" ]]; then
     OType_1="all"
   fi
fi

if [[ "wiki" == "$OType_1" ]] || [[ "all" == "$OType_1" ]] ; then
  if [[ "true" == "$AllType" ]]; then
    OType_1="wiki"
  fi
  #echo "[Debug] In the wiki loop"
  OName_3=`echo "$IName_2" | tr "/" "\n" | grep "." | tr "." " " | grep [^[:blank:]] | awk -v type="$OType_1" '{print $1"."type}'`
  echo "Staring $OType_1 generation...Creating file: $OName_3"
   BuildStr=""

   BuildStr=""
   AuthorFile="tc_authorinfo.yml"
   if [ -f $AuthorFile ]; then
      BuildStr=$BuildStr"-s $AuthorFile "
   fi

   BibName=`ls | grep ".bib"`
   if [ -f $BibName ] && [[ "$BibName" != "" ]]; then
     BuildStr=$BuildStr"--filter=pandoc-citeproc --bibliography=$BibName "
   fi

   CslName=`ls | grep ".csl"`
   if [[ ! "$CslName" == "" ]]; then
      BuildStr=$BuildStr"--csl $CslName "

   fi
   BuildStr=$BuildStr"--table-of-contents "
   BuildStr=$BuildStr"-s -t mediawiki"

   #echo "[Debug] This is the Build string: pandoc -i $IName_2 $BuildStr -o $OName_3"
   pandoc -i $IName_2 $BuildStr -o $OName_3
   if [[ "true" == "$AllType" ]]; then
     OType_1="all"
   fi
fi

if [[ "init" == "$OType_1" ]]; then
   if [[ "report" == "$IName_2" ]]; then
      echo "Initializing a report"
      wget https://raw.githubusercontent.com/citation-style-language/styles/master/ieee-with-url.csl
      wget https://gist.githubusercontent.com/nylki/e723f1ae15edc1baea43/raw/4d8dd17776844649e060efe2e51e32ed6fb0a887/bla.bib

iconv -c -f utf-8 -t ascii < bla.bib > example.bib
rm bla.bib

read -d '' authorYML << EOF
---
title:  'TC - Report Example'
author:
- ActuallyFro
date: Summer 2016
...
EOF
      echo "$authorYML" > tc_authorinfo.yml

      echo "Example Refs" > tc_report_ex.md
      echo "============" >> tc_report_ex.md
      echo "" >> tc_report_ex.md
      cat example.bib | grep "@" | grep "{" | tr "{" "\n" | grep , | tr -d "," | grep -v "?" | awk '{print "- Example Reference[@"$1"]"}' >> tc_report_ex.md
      echo "" >> tc_report_ex.md
      echo "#References" >> tc_report_ex.md

      $0 pdf tc_report_ex.md

   elif [[ "ebook" == "$IName_2" ]]; then
      echo "Initializing an ebook"
      wget http://www.latextemplates.com/templates/books/4/ebook.zip && unzip ebook.zip && rm ebook.zip

read -d '' EbookScript << EOF
#!/bin/bash
pdflatex ebook.tex
EOF

echo "$EbookScript" >> MakeEBOOK.sh
chmod +x MakeEBOOK.sh

   elif [[ "thesis" == "$IName_2" ]]; then
      echo "Initializing a thesis"
      if [ ! -f ./master.zip ]; then wget https://github.com/tompollard/phd_thesis_markdown/archive/master.zip; fi
      unzip master.zip phd_thesis_markdown-master/source/* phd_thesis_markdown-master/style/* && mv phd_thesis_markdown-master/* . && rm -r phd_thesis_markdown-master/
      mkdir ./source/figures
      rm ./style/univ_logo.eps
      if [ ! -f ./logo.png ]; then wget http://www.publicdomainpictures.net/pictures/140000/velka/business-logo-1449254128SoX.jpg && mv business-logo-1449254128SoX.jpg logo.jpg; fi
      sed -i 's/ThisULCornerWallPaper{1.0}{style\/univ_logo.eps}/includegraphics[width=2in]{logo.jpg}/g' source/01_title_page.md
      if [ ! -f ./source/figures/boat.jpg ]; then wget https://upload.wikimedia.org/wikipedia/commons/6/6a/%22Calypso%22_-_Montreal%2C_1980.jpg && mv %22Calypso* ./source/figures/boat.jpg; fi
      echo "\documentclass{report} \usepackage[total={5in,3.25in},top=0in,left=0in]{geometry} \usepackage{graphicx} \pagestyle{empty} \begin{document} \pdfpagewidth 5in \pdfpageheight 3.25in \begin{figure} \includegraphics[width=5in]{source/figures/boat.jpg} \end{figure} \end{document}" > ./boat.tex && pdflatex ./boat.tex && mv ./boat.pdf ./source/figures/ && rm boat.* && sed -i 's/example_figure.pdf/boat.pdf/g' ./source/11_chapter_2.md

      #rm master.zip

read -d '' ThesisScript << EOF
#!/bin/bash
pandoc source/*.md -o thesis.pdf --bibliography=source/references.bib --csl=style/ref_format.csl -N
EOF
      echo "$ThesisScript" > MakeThesis.sh
      ./MakeThesis.sh
   elif [[ "website" == "$IName_2" ]]; then
      echo "Stealing the report example files ..."
      $0 init report

      echo "Initializing a website"

read -d '' FooterFile << EOF
<div id="footer">
   <span style="display: inline-block; text-align: right; margin: 0px; -moz-transform: scaleX(-1); -o-transform: scaleX(-1); -webkit-transform: scaleX(-1); transform: scaleX(-1); filter: FlipH; -ms-filter: “FlipH”;">&copy;</span> Copyleft 2016
</div>
EOF
echo $FooterFile > footer.html

      wget http://pandoc.org/demo/pandoc.css

      $0 html tc_report_ex.md
      rm *.pdf

   else
      echo "Init type '$IName_2' not supported!"
   fi
fi
echo "Done! Built $OType_1."

#Current File MD5 (less this line): 0a684a923419ef4ae3ecdae27a951e87
