# Struttura del template

Il template è strutturato nel seguente modo:
```
files
├── appendix/
│   ├── bibliography.bib
│   ├── bibliography.tex
│   └── glossary-entries.tex
|
├── chapters/
│   ├── 1_introduction.tex
│   └── 2_processes.tex
|   └── ...
|
├── config/
│   ├── packages.tex
│   ├── thesis-config.tex
│   └── variables.tex
|
├── images/
│   ├── unipd-logo.png
│   └── ...
|
├── preface/
│   ├── 1_title-page.tex
│   ├── 2_copyright.tex
│   ├── 3_acknowledgements.tex
│   ├── 4_abstract.tex
│   └── 5_table-of-contents.tex
│   
├── latexmkrc
├── output.xmpdata
└── thesis.tex
```

Questi sono i documenti più importanti:

- `appendix/`: contains the last chapters, such as custom appendix chapters, bibliography and glossary.
    - `bibliography.bib`: where you put actual bibliography content.
    - `bibliography.tex`: the automatic structure of bibliography. No need to change anything here
    - `glossary-entries.tex:` where you put your glossary definitions, following the syntax of the example terms.
- `config/`
    - `variables.tex`: the first file you want to look into.
    It defines all the variables that will be used to automatically fill some contents of the document, such as the title, your name, your professor etc.
    It also fills the final PDF file metadata fields.
    - `thesis-config.tex`: some custom commands definitions and package-specific configurations.
    If you feel adventurous enough you can tune them to your preferences, but the provided ones should be ok.
    - `packages.tex`: should be pretty much self-explanatory.
    Just the declaration of all the packages used in the project.
    Nothing relevant to see here.
- `img/`: all the images you want to include in your thesis should be placed here.
- `preface/`: all those pages you find before the actual chapters are gathered here:
    - `1_title-page`: declares the structure of the front page.
        Everything is automatic and the various names, such as your name, you thesis title, your professor etc get filled from those variables you set in `config/variables.tex`.
    - `2_copyright.tex`: it's nothing special, just that blank page with copyright.
    - `3_acknowledgements.tex`: should be clear by itself. Just remember to thank your professor first
    - `4_abstract.tex`: in here you briefly explain what the thesis is about.
    You shouldn't spend much effort on this, just look at what's already in there and adapt it to your experience.
    - `5_table-of-contents`: generates the table of contents. Nothing to see here.
- `chapters/`: the real stuff is placed here.
This is the directory you will spend most of your time in, writing the main content.
You will already find some example chapters in there, which are meant to show you how to use the template and to give an example of the structure of a thesis. \
Use file names that reflect the content of the chapter, avoid calling them `chapter-03.tex`.
> [!IMPORTANT]
> When creating, deleting or editing chapters remember that you have to put them in `structure.tex` too
- `latexmkrc`: configuration file for latexmk, the tool used to compile the document. You shouldn't need to change anything here.
- `output.xmpdata`: It contains the metadata of the thesis, such as title, author, keywords etc. You should change it accordingly to your thesis, it down not accept the values from the variables defined in `config/variables.tex`.
- `thesis.tex`: the root file of your thesis. As you can read above it is the only file to compile, in order to get the final PDF.

You can customize the template to whatever you want, changing the order of the chapters, adding new ones, removing some of them etc.
Just remember to keep the structure of the document clean and consistent.