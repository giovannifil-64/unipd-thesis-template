# Template Tesi UNIPD

<p align="center">
  <img width="175" src="rsc/logo_unipd_white.png#gh-dark-mode-only">
  <img width="175" src="rsc/logo_unipd.png#gh-light-mode-only">
</p>

</br>

Template realizzato per la stesura della tesi di laurea triennale d'Informatica dell'Università degli Studi di Padova.

> [!IMPORTANT]
> Questo template è stato realizzato partendo da quello reso disponibile dal gruppo FIUP all'interno del suo repository GitHub [Thesis-template](https://github.com/FIUP/Thesis-template).

> [!NOTE]
> Questo template è pensato per il corso di laurea trinenale in Informatica, ma nulla vieta di utilizzarlo, con oppurtune modifiche, per altri corsi di laurea.

> [!WARNING]
> Si può contribuire al miglioramento costante del template, segnalando eventuali errori o suggerendo modifiche, tramite l'apertura di una issue e/o pull request, ma si prega di non caricare direttaente il template contenete i file generati dalla compilazione o contenente la vosra tesi. Eseguite un fork e lavorate da li.

Rispetto alla versione originale, sono state apportate alcune modifiche, tra cui:
- Aggiunto un interlinea di 1.5 per rendere più leggibile il documento
- Migliorata la rappresentazione grafica del documento
- Sistemati alcuni problemi con la generazione del PDF/A
- Piccole migliorie al frontespizio
- Semplificata la struttura del documento
- Semplificata la gestione della bibliografia
- Ordinati i file della prefazione per numero di apparizione
- Rimossi i tag per la generazione di un PDF per la stampa
- Rimossi alcuni pacchetti non necessari
- Rimosse le appendici

## Utilizzo
Questo template può essere utilizzato sia in locale, come ad esempio con TeXShop, VSCode e TeXstudio, che online su Overleaf.

È altresì possibile utilizzare il template con un qualsiasi editor di testo, ma in questo caso è necessario installare una distribuzione TeX, come ad esempio [TeX Live](https://www.tug.org/texlive/).

### latexmk

Una volta installata la distribuzione TeX, è necessario installare anche [latexmk](https://mg.readthedocs.io/latexmk.html), un tool che permette di compilare il documento in maniera automatica.

Successivamente, è possibile compilare il documento tramite il comando `latexmk -pdf thesis.tex`.

## PDF/A

Il template è predisposto per la generazione di un PDF/A. Si consiglia di usare **sempre** jpeg pre le immagini, in modo da non avere problemi di trasparenza.

Al momento sono presenti due warning:
- **Specification: ISO 19005-1:2005, Clause: 6.8.3.3, Test number: 1**
    - The logical structure of the conforming file shall be described by a structure hierarchy rooted in the StructTreeRoot entry of the document catalog dictionary, as described in PDF Reference 9.6	Failed
      
      1 occurrences
      
      _PDDocument_
      
      _StructTreeRoot_size == 1_
      
      _root/document[0]_

- **Specification: ISO 19005-1:2005, Clause: 6.8.2.2, Test number: 1**
    - The document catalog dictionary shall include a MarkInfo dictionary with a Marked entry in it, whose value shall be true.	Failed

> [!TIP]
> - Per far apparire il glossario, occorre citare almeno un termine con ```\gls{termine}```
> - Il termine con |g| di glossario appare invece con  ```\glsfirstoccur{\gls{termine}}```
> - Se non andasse, oltre ad alcuni accorgimenti qui adottati, eseguire:
> 1) ``` pdflatex thesis.tex ```
> 2) ``` makeglossaries thesis ```

> [!WARNING]
> - Inserire almeno un termine citato(e.g. \cite{site:scrum})
> Se il termine appare ed è stato cancellato:
> - la bibliografia viene compilata dai file .bbl (ma anche .bcf volendo) all'interno di "\build" (cartella build creata in automatico)
> Nell'ordine:
> 1) sarà sufficiente cancellare i suddetti file (.bbl e .bcf all'interno di build) per vedere effettivamente la modifica compiersi
>    - dovrebbe essere sufficiente cancellare solo il .bbl
>    - nel caso si può anche cancellare il .bcf
> 2) fare una modifica minimale (es. spaziare un carattere) all'interno della tesi (non dentro bibliography.bib)
> 3) aspettare la ricompilazione del file (sarà un po' più lunga del solito, fa la build completa)
> Nota di margine:
> - Non sono indispensabili gli ``` addtocategory ``` in thesis-config.tex/tesi-config.tex

