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

- `appendice/`: contiene gli ultimi capitoli, come i capitoli di appendice personalizzati, la bibliografia e il glossario.
    - `bibliography.bib`: dove si inserisce il contenuto effettivo della bibliografia.
    - `bibliografia.tex`: la struttura automatica della bibliografia. Non è necessario modificare nulla qui
    - `glossary-entries.tex:` dove si inseriscono le definizioni del glossario, seguendo la sintassi dei termini di esempio.
- `config/`
    - `variables.tex`: è il primo file da consultare.
    Definisce tutte le variabili che verranno utilizzate per riempire automaticamente alcuni contenuti del documento, come il titolo, il vostro nome, il vostro professore, ecc.
    Compila anche i campi dei metadati del file PDF finale.
    - `thesis-config.tex`: alcune definizioni di comandi personalizzati e configurazioni specifiche del pacchetto.
    Se ci si sente abbastanza avventurosi, si possono adattare alle proprie preferenze, ma quelle fornite dovrebbero andare bene.
    - `packages.tex`: dovrebbe essere abbastanza autoesplicativo.
    È solo la dichiarazione di tutti i pacchetti usati nel progetto.
    Non c'è nulla di rilevante da vedere qui.
- `img/`: tutte le immagini che si vogliono includere nella tesi dovrebbero essere inserite qui.
- `preface/`: tutte le pagine che si trovano prima dei capitoli veri e propri sono raccolte qui:
    - `1_title-page`: dichiara la struttura della prima pagina.
        Tutto è automatico e i vari nomi, come il vostro nome, il titolo della tesi, il vostro professore ecc. vengono riempiti dalle variabili impostate in `config/variables.tex`.
    - `2_copyright.tex`: non è niente di speciale, solo una pagina vuota con il copyright.
    - `3_riconoscimenti.tex`: dovrebbe essere chiaro da solo. Ricordatevi solo di ringraziare prima il vostro professore
    - `4_abstract.tex`: qui si spiega brevemente di cosa tratta la tesi.
    Non si dovrebbe spendere molto per questo, basta guardare a quello che c'è già e adattarlo alla propria esperienza.
    - `5_table-of-contents`: genera l'indice dei contenuti. Non c'è niente da vedere qui.
- `chapters/`: qui si trova il materiale vero e proprio.
Questa è la cartella in cui si passerà la maggior parte del tempo, scrivendo il contenuto principale.
Vi si trovano già alcuni capitoli di esempio, che hanno lo scopo di mostrare come usare il modello e di dare un esempio della struttura di una tesi. \
Utilizzate nomi di file che riflettano il contenuto del capitolo, evitando di chiamarli `capitolo-03.tex`.
> [!IMPORTANT]
> Quando si creano, si cancellano o si modificano i capitoli, ricordarsi che è necessario aggiornarli anche in `thesis.tex`
- `latexmkrc`: file di configurazione per latexmk, lo strumento usato per compilare il documento. Non dovrebbe essere necessario modificare nulla qui.
- `output.xmpdata`: Contiene i metadati della tesi, come titolo, autore, parole chiave ecc. Dovete modificarlo in base alla vostra tesi, non accetta i valori delle variabili definite in `config/variables.tex`.
- `thesis.tex`: il file principale della tesi. Come si può leggere sopra, è l'unico file da compilare per ottenere il PDF finale.

È possibile personalizzare il modello in base alle proprie esigenze, cambiando l'ordine dei capitoli, aggiungendone di nuovi, rimuovendone alcuni, ecc.
Ricordate solo di mantenere la struttura del documento pulita e coerente.
