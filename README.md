# Template Tesi UNIPD

<p align="center">
  <img width="175" src="res/logo_unipd_white.png#gh-dark-mode-only">
  <img width="175" src="res/logo_unipd.png#gh-light-mode-only">
</p>

</br>

Template realizzato per la stesura della tesi di laurea triennale d'Informatica dell'Università degli Studi di Padova.

> [!IMPORTANT]
> Questo template è realizzato partendo da quello del Gruppo FIUP, reso disponibile all'interno della repository GitHub [Thesis-template](https://github.com/FIUP/Thesis-template).

> [!NOTE]
> La struttura della tesi è pensata per il Corso di Laurea in Informatica, ma nulla vieta di utilizzarlo, con le oppurtune modifiche, per altri corsi di laurea.

> [!WARNING]
> Si può contribuire al miglioramento costante del template, segnalando eventuali errori o suggerendo modifiche, tramite l'apertura di una issue e/o pull request, ma si prega di non caricare direttamente il template contenete i file generati dalla compilazione o con la vostra tesi.

Rispetto alla versione originale, sono state apportate alcune modifiche, tra cui:

- Sistemati alcuni problemi con la generazione del PDF/A;
- Aggiunto un interlinea di 1.5 per rendere più leggibile il documento;
- Migliorata la rappresentazione grafica del documento;
- Piccole migliorie al frontespizio;
- Semplificata la struttura del documento;
- Migliorato l'ordine di apparizione di alcune sezioni;
- Rimossi alcuni pacchetti non necessari;
- Rimossi i tag per la generazione di un PDF per la stampa;
- Semplificata la gestione della bibliografia;
- Aggiunta la Sitografia dedicata;
- Rimosse le appendici.

Qui puoi vedere un esempio del [PDF generato](res/thesis_template.pdf).

> [!NOTE]
> Se devi stampare la tesi, assicurati di rimuovere il colore dal documento decommentando la riga `\hypersetup{draft}` in `config/thesis_config.tex`, in modo da rimuovere i link e il colore dai riferimenti.

## Utilizzo

Dopo aver scaricato la repo, nel percorso [```thesis/files```](https://github.com/giovannifil-64/unipd-thesis-template/tree/main/thesis/files) troverete i file in LaTeX della tesi. Per utilizzarla su Overleaf va compressa la cartella ```files``` e caricate lo ```.zip``` ottenuto.

È altresì possibile utilizzare il template con un qualsiasi editor di testo, ma in questo caso è necessario installare una distribuzione TeX, come [TeX Live](https://www.tug.org/texlive/), installando tutti i pacchetti, o selezionando a mano i quelli da installare partendo dal file ```packages.tex```.

Su sistemi UNIX/Linux, è possibile installare i pacchetti necessari con il comando:

```bash
sudo apt install texlive-full
```

> [!IMPORTANT]
> Le seguenti istruzioni sono state testate su TeXstudio
> Una volta installato tutto sulla macchina, eseguite i seguenti passaggi per compilare il documento:
>
> 1) Se avete file in python, dovete installare Pygment con pip. In caso di ambienti gestiti esternamente usare ```sudo apt install python3-pygments```
> 2) impostare --shell-escape per la compilazione ([Qui viene spiegato come fare](https://tex.stackexchange.com/a/99476/279981))
> 3) forzare biber come compiler della bibliografia ([Qui viene spiegato come fare](https://tex.stackexchange.com/a/429968/279981))
>
> Se i riferimenti, bibliografia etc. non dovessero comparire, provate a cancellare i file generati e ricompilare. Tutte le volte che è comparso il problema si è risolto in questo modo.

> [!TIP]
> Suggerisco di utilizzare Overleaf, è stato testato e non presenta problemi di compilazione, oltre che semplificare la condivisione del documento (e permette di avere un backup online del proprio lavoro).
> L'Università di Padova **non** fornisce un account premium per Overleaf, per cui si potrebbe incorrere in problemi di compilazione per documenti di grandi dimensioni. Se dovesse comparire il warning sulla dimensione del documento, si può risolvere impostando la modalità di compilazione su "Fast [draft]", dove non vengono renderizzate le immagini.

> [!NOTE]
>
> Per far apparire il Glossario e la lista degli Acronimi e abbreviazioni occorre citare almeno un termine all'interno del documento. Per farlo si può utilizzare la sintassi ```\gls{termine}```.
> Ad esempio:
> ```latex
> Lorem \gls{sdkg} ispum dolor
> ```
> il termine apparirà come "_Software Development Kit (SDK)<sub>G</sub>_".
> Nei successivi utilizzi, il termine apparirà come "_Software Development Kit<sub>G</sub>_".
> se invece si vuole che il termine appaia sempre con la sigla, si può utilizzare la sintassi ```\gls{sdkg}``` (l'utilizzo di g è una convenzione per indicare che il termine è un acronimo).
> Per inserire un termine nel Glossario, bisogna aggiungere la voce nel file ```references/glossary_acronyms.tex```, seguendo la struttura già presente.
>
> In caso di dubbi, si può consultare il Capitolo 7 di questo template, che mostra alcuni esempi di utilizzo.

### latexmk

Una volta installata la distribuzione TeX, è necessario installare anche [latexmk](https://mg.readthedocs.io/latexmk.html), un tool che permette di compilare il documento in maniera automatica.

Successivamente, è possibile compilare il documento tramite il comando `latexmk -pdf thesis.tex`.

## PDF/A

Il template è predisposto per la generazione di un file PDF/A-1A. Per le immagini si raccomanda di usare **sempre** un file _jpeg_ o _jpg_, in modo da non avere problemi con la trasparenza per la validazione.

Al momento sono presenti due warning:

- **Specification: ISO 19005-1:2005, Clause: 6.8.3.3, Test number: 1**
  - The logical structure of the conforming file shall be described by a structure hierarchy rooted in the StructTreeRoot entry of the document catalog dictionary, as described in PDF Reference 9.6 Failed

      1 occurrences

      _PDDocument_

      _StructTreeRoot_size == 1_

      _root/document[0]_

- **Specification: ISO 19005-1:2005, Clause: 6.8.2.2, Test number: 1**
  - The document catalog dictionary shall include a MarkInfo dictionary with a Marked entry in it, whose value shall be true. Failed

      1 occurrences

      _CosDocument_

      _Marked == true_

      _root_

Appena verrà trovata una soluzione, verrà aggiornato il template.

## Licenza

Il template è rilasciato sotto licenza [MIT](LICENSE).
