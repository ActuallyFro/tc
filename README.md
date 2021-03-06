TCC - Text Compiler
===================
This is just a glorified grouping of aliases I want to use with some combination of Latex, Markdown, and Pandoc.

TL;DR
-----
I'm lazy; this builds pretty things from a text file.

Required Tools/Libraries
------------------------
Ensure that MikTex/TexLive is installed, and Pandoc works with your CLI.

Supported Output Types
----------------------
- PDF
- HTML
- [TODO] Web PPT
- DOCX
- Wiki

Current templates
-----------------
- Report
- eBook
- Thesis
- Website

Compile Settings
================
The following sections detail default/optional settings for the file outputs.

Global/Default Settings
-----------------------
###Automated Bibtex Support
BibTex is a tool and format which describe references and is mostly used with LaTeX[@BibTex].
The first ".bib" file, co-located with the input file, will be used.

###Automated CSL Style Sheet support
The format BibTex will be presented in is a Citation Style Language file[@CSL].
The first ".csl" file, co-located with the input file, will be used.

###Automated YAML metadata block support
Pandoc supports a great document metadata block for information about the document[@PandocYAML].
The first ".yml" file, co-located with the input file, will be used.

####Supported Variables[@PandocVars]:
- title
- author
- date
- subtitle
- institute
- abstract
- keywords

PDF Settings
------------
Pandoc builds the input (presumably a markdown or Latex file) to pdf via LaTeX.

###Formatting - Margins
The default margins are 1.125in

###Formatting - Black URL/Reference links
To ensure no odd BibTex auto/referencing has blue hyperlinks a black url setting is included.

Wiki Settings
--------------
The output type of `wiki` will output a .wiki file that is compliant to the Mediawiki (markup) format.

###Formatting - Table of Contents
A default/simple ToC is included.
It does NOT like to render on the MediaWiki website, but appears to work fine with Wikipedia.

###Bibtex Note
BibTex has limited support when generating the wiki file via Pandoc.
Currently the References will be manually placed in the document similar to APA citation formats (as opposed to hyperlinked Mediawiki formatting).

Credits
=======
- The CitationStyleLanguage.org website manages the CSL/XML formatting[@CSLWeb].
- John MacFarlane created Pandoc and hosts a TON of great examples on his website[@PandocAbout].
- Tom Pollard provides his Thesis Template via a [Creative Commons Attribution 4.0 License](http://creativecommons.org/licenses/by/4.0)

#References
