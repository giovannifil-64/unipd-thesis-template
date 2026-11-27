# Struttura del template

I sorgenti LaTeX della tesi sono nella cartella `files/`. È la cartella da comprimere in uno `.zip` per caricarla su Overleaf, e quella che `build.sh` / `build.ps1` (nella radice del repository) compilano.

```text
files/
├── chapters/
│   ├── 1_introduction.tex
│   ├── 2_processes.tex
│   └── ...
│
├── code/
│   ├── example.py
│   └── ...
│
├── config/
│   ├── packages.tex
│   ├── thesis_config.tex
│   └── variables.tex
│
├── img/
│   ├── logo_unipd.jpeg
│   └── ...
│
├── preface/
│   ├── 1_title_page.tex
│   ├── 2_copyright.tex
│   ├── 3_acknowledgements.tex
│   ├── 4_abstract.tex
│   └── 5_table_of_contents.tex
│
├── references/
│   ├── bibliography.bib
│   ├── bibliography.tex
│   ├── glossary_acronyms.tex
│   └── webliography.tex
│
├── latexmkrc
├── output.xmpdata
└── thesis.tex
```

## Cosa fa ogni file

- `thesis.tex`: il file principale della tesi, l'unico da compilare per ottenere il PDF finale. Elenca, nell'ordine, le parti del documento.
- `config/`
  - `variables.tex`: **è il primo file da consultare.** Definisce le variabili che riempiono automaticamente titolo, nome, relatore, matricola, anno accademico ecc. nel frontespizio, nella pagina del copyright e nei ringraziamenti.
  - `thesis_config.tex`: comandi personalizzati e impostazioni dei pacchetti (interlinea, intestazioni, link, didascalie, listati di codice). Se ci si sente avventurosi si può adattare, ma quella fornita dovrebbe andare bene.
  - `packages.tex`: la dichiarazione dei pacchetti usati, con le note sui vincoli di ordine e sul PDF/A. L'elenco commentato è anche nel [README](../README.md#pacchetti-latex-richiesti) principale.
- `preface/`: tutte le pagine che precedono i capitoli.
  - `1_title_page.tex`: il frontespizio. È tutto automatico: i dati arrivano da `config/variables.tex`.
  - `2_copyright.tex`: pagina con il copyright.
  - `3_acknowledgements.tex`: ringraziamenti. Ricordate di ringraziare prima il relatore.
  - `4_abstract.tex`: il sommario della tesi.
  - `5_table_of_contents.tex`: indice generale, elenco delle figure, delle tabelle e dei listati. Non c'è nulla da modificare.
- `chapters/`: il contenuto vero e proprio, e la cartella dove si passerà più tempo. I capitoli presenti sono esempi della struttura di una tesi di stage. Usate nomi di file che descrivano il contenuto del capitolo, evitando `capitolo-03.tex`.
- `references/`
  - `bibliography.bib`: le voci bibliografiche (libri, articoli, siti web).
  - `bibliography.tex` e `webliography.tex`: la struttura automatica di Bibliografia e Sitografia. Di norma non serve modificarli. Entrambi usano `\nocite{*}`: vengono quindi stampate **tutte** le voci di `bibliography.bib`, anche quelle non citate nel testo. Per stampare solo le voci citate, togliere `\nocite{*}`.
  - `glossary_acronyms.tex`: acronimi e voci di glossario, da compilare seguendo gli esempi presenti.
- `code/`: i file di codice da includere nella tesi con `\inputminted{python}{code/example.py}`.
- `img/`: le immagini. Per il PDF/A usate JPEG, oppure PNG **senza** canale alpha (la trasparenza non è ammessa).
- `latexmkrc`: configurazione di `latexmk`, lo strumento che compila il documento (esegue pdfLaTeX e biber quante volte serve, con `--shell-escape`; i glossari li genera da solo il pacchetto `glossaries`, grazie all'opzione `automake`). Non dovrebbe servire modificarlo.
- `output.xmpdata`: i metadati del PDF (titolo, autore, lingua, parole chiave). Va compilato **a mano**: non legge le variabili di `config/variables.tex`. Il file si chiama `output` perché il nome del job è forzato a `output` (lo fa anche Overleaf).

> [!IMPORTANT]
> Quando si creano, si cancellano o si rinominano i file dei capitoli, aggiornare l'elenco di `\input{chapters/...}` in `thesis.tex`.

È possibile personalizzare il modello a piacere: cambiare l'ordine dei capitoli, aggiungerne o toglierne. Basta mantenere la struttura del documento pulita e coerente.
