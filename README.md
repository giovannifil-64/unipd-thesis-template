# Template Tesi UNIPD

<p align="center">
  <img width="250" src="rsc/logo_unipd_white.png#gh-dark-mode-only">
  <img width="250" src="rsc/logo_unipd.png#gh-light-mode-only">
</p>

</br>

Template realizzato per la stesura della tesi di laurea triennale d'Informatica dell'Università degli Studi di Padova.

> [!IMPORTANT]
> Questo template è stato realizzato partendo da quello reso disponibile dal gruppo FIUP all'interno del suo repository GitHub [Thesis-template](https://github.com/FIUP/Thesis-template).

> [!NOTE]
> Questo template è pensato per il corso di laurea trinenale in Informatica, ma nulla vieta di utilizzarlo, con oppurtune modifiche, per altri corsi di laurea.

> [!WARNING]
> Si può contribuire al miglioramento costante del template, segnalando eventuali errori o suggerendo modifiche, tramite l'apertura di una issue e/o pull request, ma si prega di non caricare direttaente il template contenete i file generati dalla compilazione o il template contenente la vosra tesi. Eseguite un fork e lavorate da li.

Rispetto alla versione originale, sono state apportate alcune modifiche, tra cui:
- Rimosse le appendici
- Piccole migliorie al frontespizio
- Migliorata la struttura del documento
- Aggiunto un interlinea di 1.5
- Migliorati alcuni aspetti grafici, come la visualizzazione del PDF generato
- Semplificata la gestione della bibliografia
- Rimossi alcuni pacchetti non necessari

## Utilizzo
Questo template può essere utilizzato sia in locale, come ad esempio con TeXShop, VSCode eTeXstudio, che online su Overleaf.

È altresì possibile utilizzare il template con un qualsiasi editor di testo, ma in questo caso è necessario installare una distribuzione TeX, come ad esempio [TeX Live](https://www.tug.org/texlive/).

### latexmk

Una volta installata la distribuzione TeX, è necessario installare anche [latexmk](https://mg.readthedocs.io/latexmk.html), un tool che permette di compilare il documento in maniera automatica.

Successivamente, è possibile compilare il documento tramite il comando `latexmk -pdf thesis.tex`.

## Licenza

Il template è rilasciato sotto licenza [MIT](LICENSE).