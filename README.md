# Template Tesi UNIPD

<p align="center">
  <img width="175" src="rsc/logo_unipd_white.png#gh-dark-mode-only">
  <img width="175" src="rsc/logo_unipd.png#gh-light-mode-only">
</p>

</br>

Template realizzato per la stesura della tesi di laurea triennale d'Informatica dell'Università degli Studi di Padova.

> [!IMPORTANT]
> Questo template è realizzato partendo da quello reso disponibile dal gruppo FIUP all'interno della repository GitHub [Thesis-template](https://github.com/FIUP/Thesis-template).

> [!NOTE]
> Questo template è pensato per il corso di laurea triennale in Informatica, ma nulla vieta di utilizzarlo, con oppurtune modifiche, per altri corsi di laurea.

> [!WARNING]
> Si può contribuire al miglioramento costante del template, segnalando eventuali errori o suggerendo modifiche, tramite l'apertura di una issue e/o pull request, ma si prega di non caricare direttamente il template contenete i file generati dalla compilazione o con la vosra tesi.

Rispetto alla versione originale, sono state apportate alcune modifiche, tra cui:
- Aggiunto un interlinea di 1.5 per rendere più leggibile il documento
- Migliorata la rappresentazione grafica del documento
- Sistemati alcuni problemi con la generazione del PDF/A
- Piccole migliorie al frontespizio
- Semplificata la struttura del documento
- Semplificata la gestione della bibliografia
- Cambiato l'ordine di apparizione di alcune sezioni
- Rimossi i tag per la generazione di un PDF per la stampa
- Rimossi alcuni pacchetti non necessari
- Rimosse le appendici

## Utilizzo
Questo template può essere utilizzato sia in locale, come ad esempio con TeXShop, VSCode e TeXstudio, che online su Overleaf.

È altresì possibile utilizzare il template con un qualsiasi editor di testo, ma in questo caso è necessario installare una distribuzione TeX, come ad esempio [TeX Live](https://www.tug.org/texlive/).

> [!TIP]
> - Per far apparire il glossario, occorre citare almeno un termine con ```\gls{termineg}```, mentre per la lista "Acronimi e abbreviazioni" è necessario usare anche il termine ```\gls{termine}```
> - Il termine con |g| di glossario appare invece con  ```\glsfirstoccur{\gls{termine}}```
> - Se non andasse, oltre ad alcuni accorgimenti qui adottati, eseguire:
> 1) ``` pdflatex thesis.tex ```
> 2) ``` makeglossaries thesis ```

### latexmk

Una volta installata la distribuzione TeX, è necessario installare anche [latexmk](https://mg.readthedocs.io/latexmk.html), un tool che permette di compilare il documento in maniera automatica.

Successivamente, è possibile compilare il documento tramite il comando `latexmk -pdf thesis.tex`.

> [!TIP]
> Suggeriamo di utilizzare overleaf per la compilazione, in quanto è stato testato li e non presenta problemi, oltre che semplificare la condivisione del documento (oltre che essere un ulteriore luogo in cui mantenere un backup del documento, non si sa mai).\
> L'Università di Padova **non** fornisce un account premium per overleaf, ma tenendo la struttura separata in pià file, ognuno con uno scopo preciso, si può facilmente lavorare e mostrare le modifiche apportare al Realore/Relatrice.

## PDF/A

Il template è predisposto per la generazione di un file PDF/A-1a. Per le immagini si raccomanda di usare **sempre** un file _jpeg_, in modo da non avere problemi con la trasparenza per la validazione.

Al momento sono presenti due warning:
- **Specification: ISO 19005-1:2005, Clause: 6.8.3.3, Test number: 1**
    - The logical structure of the conforming file shall be described by a structure hierarchy rooted in the StructTreeRoot entry of the document catalog dictionary, as described in PDF Reference 9.6	Failed
      
      1 occurrences
      
      _PDDocument_
      
      _StructTreeRoot_size == 1_
      
      _root/document[0]_

- **Specification: ISO 19005-1:2005, Clause: 6.8.2.2, Test number: 1**
    - The document catalog dictionary shall include a MarkInfo dictionary with a Marked entry in it, whose value shall be true.	Failed

      1 occurrences
      
      _CosDocument_
      
      _Marked == true_
      
      _root_

Appena verrà trovata una soluzione, verrà aggiornato il template.

## Licenza

Il template è rilasciato sotto licenza [MIT](LICENSE).
