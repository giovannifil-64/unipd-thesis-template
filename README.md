# Template per la tesi dell'Università degli Studi di Padova

<p align="center">
  <img width="250" src="rsc/logo_unipd_white.png#gh-dark-mode-only">
  <img width="250" src="rsc/logo_unipd.png#gh-light-mode-only">
</p>

</br>

> [!IMPORTANT]
> Questo template è stato realizzato partendo da quello reso disponibile dal grupo FIUP all'interno del suo repository GitHub [Thesis-template](https://github.com/FIUP/Thesis-template).

> [!NOTE]
> Questo template è pensato per il corso di laurea trinenale in Informatica, ma nulla vieta di utilizzarlo, con oppurtune modifiche, per altri corsi di laurea.

> [!TIP]
> Per far apparire il glossario, occorre citare almeno un termine con ```\gls{termine}```
> Il termine con |g| di glossario appare invece con  ```\glsfirstoccur{\gls{termine}}```
> Se non andasse, oltre ad alcuni accorgimenti qui adottati, eseguire:
> ``` pdflatex thesis.tex ```
> ``` makeglossaries thesis ```

> [!TIP]
- Inserire almeno un termine citato(e.g. \cite{site:scrum})

> Se il termine appare ed è stato cancellato:
- la bibliografia viene compilata dai file .bbl (ma anche .bcf volendo) all'interno di "\build" (cartella build creata in automatico)

> Nell'ordine:
1) sarà sufficiente cancellare i suddetti file (.bbl e .bcf all'interno di build) per vedere effettivamente la modifica compiersi
    - dovrebbe essere sufficiente cancellare solo il .bbl
    - nel caso si può anche cancellare il .bcf
2) fare una modifica minimale (es. spaziare un carattere) all'interno della tesi (non dentro bibliography.bib)
3) aspettare la ricompilazione del file (sarà un po' più lunga del solito, fa la build completa)

> Nota di margine:
- Non sono indispensabili gli ``` addtocategory ``` in thesis-config.tex/tesi-config.tex

