TC - Text Compiler
==================
This is just a glorified grouping of aliases I want to use with some combination of Latex, Markdown, and Pandoc.

Supported Output Types
----------------------
- PDF
- [TODO] HTML
- [TODO] PPTX
- [TODO] DOCX
- Wiki

PDF "Options"
-------------
Pandoc is leveraged to build the input (presumably a markdown or Latex file) to pdf.

###Bibtex Support
BibTex is a tool and format which describe references, which are mostly used with LaTeX[@BibTex].

###CSL Style Sheet support

##Formatting - Table of Contents

##Formatting - Margins

##Formatting - Black URL/Refeference links

Wiki "Options"
--------------
The output type of `wiki` will output a .wiki file that is compliant to the Mediawiki (markup) format.

###Bibtex Support
BibTex has limited support when generating the wiki file via Pandoc.
Currently the References will be manually placed in the document simliar to APA citation formats (as opposed to hyperlinked Mediawiki formatting).

TL;DR
=====
I'm lazy; this builds things from text...

Credits
=======
The CitationStyleLanguage.org website manages the CSL/XML formatting.

#References
