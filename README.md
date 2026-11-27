# Template Tesi UNIPD

<p align="center">
  <img width="175" src="res/unipd_pictogram_white.png#gh-dark-mode-only">
  <img width="175" src="res/unipd_pictogram.png#gh-light-mode-only">
</p>

</br>

Template per la stesura della tesi di laurea triennale in Informatica dell'Università degli Studi di Padova, con generazione di un **PDF/A** pronto per il caricamento su Uniweb. Si compila su Overleaf oppure, con un solo comando, sul proprio computer (macOS, Linux, Windows).

> [!IMPORTANT]
> Questo template è realizzato partendo da quello del Gruppo FIUP, reso disponibile all'interno della repository GitHub [Thesis-template](https://github.com/FIUP/Thesis-template).

> [!NOTE]
> La struttura della tesi è pensata per il Corso di Laurea in Informatica, ma nulla vieta di utilizzarlo, con le opportune modifiche, per altri corsi di laurea.

> [!WARNING]
> Si può contribuire al miglioramento costante del template, segnalando eventuali errori o suggerendo modifiche, tramite l'apertura di una issue e/o pull request, ma si prega di non caricare direttamente il template contenente i file generati dalla compilazione o con la vostra tesi.

Qui si può vedere un esempio del [PDF generato](res/thesis_template.pdf).

**Indice:** [Novità della versione 2](#novità-della-versione-2) · [Struttura](#struttura-del-repository) · [Overleaf](#usare-overleaf) · [In locale](#compilare-sul-proprio-computer) · [Pacchetti richiesti](#pacchetti-latex-richiesti) · [PDF/A e Uniweb](#pdfa-e-caricamento-su-uniweb) · [Glossario](#glossario-e-acronimi) · [Problemi comuni](#problemi-comuni) · [Compatibilità](#compatibilità-verificata)

## Novità della versione 2

**Correzioni**

- **Compila di nuovo con le versioni attuali di TeX Live e di minted.** La versione 1 si fermava con due errori: `\minted@cleancache` non esiste più in minted 3.x e un `\description[...]` mal posizionato apriva una lista mai chiusa.
- **PDF/A valido.** Prima il template dichiarava `PDF/A-1a` ma falliva due regole di validazione (6.8.2.2 e 6.8.3.3), perché pdfLaTeX non produce un PDF con i tag di struttura richiesti dal livello "a". Ora è **PDF/A-1b** e supera la validazione con veraPDF, con la compilazione su Overleaf o in locale.
- **Collegamenti delle note a piè di pagina funzionanti**: `setspace` (e, con TeX Live meno recenti, `footmisc`), caricato dopo `pdfx`, rompeva le destinazioni dei link (avviso `Hfootnote.N has been referenced but does not exist`). Ora sono caricati prima.
- **Numerazione delle pagine**: la bibliografia e la sitografia non ripartono più da "i, ii" dopo l'ultimo capitolo (il che creava anche destinazioni duplicate nel PDF); la numerazione araba prosegue.
- Sezione "Valutazione personale" duplicata, tabella a tre colonne riempita solo con due, segnalibro "Compendio" su un capitolo intitolato "Sommario", autori della voce bibliografica separati da virgola invece che da `and`, refusi.
- `.gitignore` non funzionava (le voci erano scritte senza `*`, quindi non ignoravano nulla).

**Novità**

- Script **`build.sh`** (macOS, Linux, WSL) e **`build.ps1`** (Windows PowerShell): compilano la tesi e validano il PDF/A, senza Overleaf. Usano il TeX installato oppure, se manca, Docker.
- `latexmkrc` con il file principale indicato (`@default_files`): in `thesis/files` basta `latexmk`.
- Pacchetti non usati rimossi (`chngpage`, `comment`, `epigraph`, `mparhack`, `relsize`, `nameref`, `quoting`, `subfig`, `varioref`, `zref-totpages`, `inputenc`). L'impaginazione dei capitoli non cambia: è stata confrontata pagina per pagina. Se vi serve un pacchetto rimosso (per esempio per le sottofigure), in `config/packages.tex` ci sono le righe da decommentare.
- **Log pulito**: spariti i tre avvisi che comparivano su Overleaf (`xcolor`: opzione obsoleta passata da `pdfx`; `tracklang`: `datatool` non ha il supporto per l'italiano; `pdfx`: messaggio informativo sul colore RGB del PDF/A). I primi due sono risolti alla radice, il terzo è filtrato con `silence`.
- Elenco dei [pacchetti richiesti](#pacchetti-latex-richiesti) con i comandi di installazione provati, e `.gitattributes` per evitare i problemi di fine riga su Windows.

> [!NOTE]
> Se avete già iniziato la tesi con la versione 1, i vostri capitoli restano compatibili (i comandi e gli ambienti del template non sono cambiati). Il modo più semplice per passare alla versione 2 è scaricarla e copiarci dentro i vostri capitoli, le immagini, `config/variables.tex`, `output.xmpdata` e la bibliografia.

## Struttura del repository

```text
.
├── build.sh            compila e valida il PDF/A (macOS, Linux, WSL)
├── build.ps1           lo stesso per Windows PowerShell
├── thesis/
│   ├── README.md       descrizione dei singoli file del template
│   └── files/          i sorgenti LaTeX: thesis.tex, config/, chapters/, preface/, references/, img/, code/
└── res/                PDF di esempio e immagini di questo README
```

Il PDF prodotto dagli script è `thesis.pdf` nella radice del repository (non viene tracciato da git). Per la descrizione di ogni file in `thesis/files` vedi [`thesis/README.md`](thesis/README.md).

Per cominciare: modifica `thesis/files/config/variables.tex` (titolo, nome, relatore, matricola...) e `thesis/files/output.xmpdata` (metadati del PDF), poi scrivi i capitoli in `thesis/files/chapters/`.

## Usare Overleaf

È il modo più semplice per cominciare, e permette di condividere il documento e di averne un backup online.

1. Crea uno `.zip` che abbia `thesis.tex` **alla radice** (non dentro una cartella). Il modo più sicuro è da terminale, dalla radice del repository: `cd thesis/files && zip -r ../../tesi.zip . -x "*.DS_Store"`. In alternativa comprimi a mano il *contenuto* di `thesis/files`.
2. Su Overleaf: **New Project → Upload Project** e carica lo `.zip`.
3. Nel menu del progetto controlla che **Main document** sia `thesis.tex`, il **Compiler** sia **pdfLaTeX** e il **TeX Live version** sia una versione recente (almeno la 2022).
4. Compila. Il PDF scaricato si chiama `output.pdf` (è il nome del job, forzato da `latexmkrc`): rinominalo.

### Il limite di tempo di Overleaf

L'Università di Padova **non** fornisce un account premium di Overleaf, e il piano gratuito ferma la compilazione dopo **10 secondi**. Il template fa parecchio lavoro: tre passate di pdfLaTeX (ognuna ricarica circa 80 pacchetti), biber, i glossari e l'evidenziazione dei listati con `minted`. Una compilazione completa da zero richiede circa 5 secondi su un computer recente, e di più sui server condivisi di Overleaf, quindi **la prima compilazione può terminare con il messaggio "Your project needs more compile time"**. Non è un errore del template.

- Premi di nuovo **Recompile**: di norma Overleaf conserva i file intermedi della compilazione interrotta (indice, bibliografia, glossari, cache di `minted`) e prosegue da lì. Non usare "Clear cached files", che butterebbe via proprio questo lavoro.
- Dopo la prima compilazione riuscita, le successive sono molto più rapide: basta una passata.
- La modalità "Fast [draft]" aiuta poco: salta solo le immagini, non biber, glossari e listati.
- Mentre scrivi un capitolo puoi mettere un `%` davanti agli `\input{chapters/...}` degli altri in `thesis.tex`: compila prima. I riferimenti agli altri capitoli compaiono come `?` finché non li riattivi.
- Se la tesi cresce, compila in locale con `./build.sh` (nessun limite di tempo) e usa Overleaf per condividere il testo.

Per verificare che il PDF scaricato sia un PDF/A usa `./build.sh check output.pdf` (serve [veraPDF](https://verapdf.org/software/)) oppure il [validatore online](https://www.pdf-online.com/osa/validate.aspx).

## Compilare sul proprio computer

Servono, in ogni caso, queste cose:

| Che cosa | A cosa serve |
|---|---|
| Una distribuzione **TeX** con pdfLaTeX (TeX Live o MiKTeX) | compilare il documento |
| **`latexmk`** (richiede Perl) | esegue pdfLaTeX e biber tutte le volte che serve |
| **`biber`**, nella versione che corrisponde a `biblatex` | bibliografia |
| **Python 3** con il pacchetto **Pygments** | evidenziazione dei listati di codice (`minted`) |
| *(facoltativo)* **veraPDF** | validare il PDF/A |
| *(alternativa)* **Docker** | compilare senza installare TeX (l'immagine pesa circa 9 GB) |

Poi si compila con un solo comando, dalla radice del repository:

```bash
./build.sh                 # compila, crea ./thesis.pdf e lo valida con veraPDF
./build.sh check [file]    # valida un PDF/A già esistente
./build.sh clean           # cancella build/ e thesis.pdf
./build.sh -h              # tutte le opzioni (--docker, --native, -o file.pdf, -v ...)
```

Lo script usa il TeX Live installato; se manca, usa Docker (la prima volta scarica l'immagine `texlive/texlive`). La compilazione avviene in `build/work/`, così i sorgenti restano puliti. Se avete già TeX e volete forzare Docker usate `--docker`; per riprodurre una versione precisa (per esempio quella di Overleaf) impostate `TEXLIVE_IMAGE=texlive/texlive:TL2025-historic` (queste immagini storiche esistono solo per processori amd64: su un Mac Apple Silicon girano in emulazione, più lente).

Senza lo script, dentro `thesis/files`, basta `latexmk`: legge `latexmkrc` e produce `output.pdf`.

### macOS

```bash
brew install --cask mactex-no-gui     # TeX Live completo, circa 5 GB; poi riapri il terminale
brew install verapdf                  # facoltativo, per la validazione
python3 -m pip install --user pygments
```

In alternativa a MacTeX c'è BasicTeX (`brew install --cask basictex`, circa 100 MB): dopo l'installazione serve il comando `tlmgr install ...` dell'[elenco dei pacchetti](#installazione-minimale-con-tlmgr). Se `pip` risponde `externally-managed-environment` (Python gestito da Homebrew), installate Pygments con `brew install pygments` oppure in un ambiente virtuale. Se non volete installare TeX, basta [Docker Desktop](https://www.docker.com/products/docker-desktop/): `./build.sh` si accorge da solo che manca TeX.

### Linux

Debian e Ubuntu (provato su Ubuntu 22.04 e 24.04):

```bash
sudo apt install texlive-latex-extra texlive-fonts-recommended texlive-lang-italian texlive-lang-greek \
                 texlive-lang-european texlive-bibtex-extra biber latexmk python3-pygments
```

Se preferite non pensarci, `sudo apt install texlive-full biber latexmk python3-pygments` installa tutto (circa 5 GB). Su altre distribuzioni (Fedora, Arch...) installate TeX Live completo con il gestore di pacchetti o con l'[installer ufficiale](https://tug.org/texlive/), più `biber`, `latexmk` e Pygments.

> [!WARNING]
> Le versioni di `biber` e `biblatex` devono corrispondere. Se compare `Found biblatex control file version X, expected version Y`, avete due installazioni diverse (per esempio TeX Live del sistema e `biber` di un'altra fonte): usate quelle della stessa distribuzione.

### Windows

La strada più sicura è **WSL 2**: dentro Ubuntu il template si compila esattamente come su Linux.

1. In PowerShell (come amministratore): `wsl --install -d Ubuntu`, poi riavvia e crea l'utente.
2. Nel terminale di Ubuntu installa i pacchetti come nella sezione [Linux](#linux) e usa `./build.sh`.
3. Tieni il repository **dentro** il filesystem di Ubuntu (per esempio in `~/tesi`), non in `/mnt/c/...`: è molto più veloce. Da Windows lo raggiungi con `\\wsl$\Ubuntu\home\<utente>\tesi`.

Senza WSL, direttamente da Windows:

- **TeX Live** (installer `install-tl-windows.exe`, include `latexmk`, `biber` e Perl) oppure **MiKTeX** (con Perl, ad esempio Strawberry Perl, per `latexmk`; i pacchetti mancanti li scarica da solo se si imposta "Always install missing packages on the fly");
- **Python 3** da [python.org](https://www.python.org/downloads/) o dal Microsoft Store, poi `py -m pip install pygments`;
- si compila da PowerShell con `.\build.ps1` (o con `latexmk` dentro `thesis\files`). Se PowerShell rifiuta di eseguire lo script: `powershell -ExecutionPolicy Bypass -File .\build.ps1`.

Con **Docker Desktop** installato e avviato basta `.\build.ps1` (o `./build.sh` da WSL): non serve altro.

> [!NOTE]
> Scaricando il repository con Git su Windows, i fine riga di `build.sh` potrebbero diventare CRLF e impedirne l'esecuzione in WSL (`bash\r: command not found`). Il file `.gitattributes` del repository lo evita; se capita lo stesso: `git config core.autocrlf input` e poi ricloni.

### Editor

Con VS Code (estensione *LaTeX Workshop*), TeXstudio o simili, impostate come strumento di compilazione **`latexmk`**: legge `latexmkrc` e non servono altre impostazioni. Se invece l'editor esegue pdfLaTeX e biber a mano, vanno impostati `--shell-escape` (per `minted` e `glossaries`), biber come motore della bibliografia e va compilato più volte; con `latexmk` tutto questo è automatico.

## Pacchetti LaTeX richiesti

Sono tutti inclusi in TeX Live e in MiKTeX. Il template li carica in `thesis/files/config/packages.tex`.

| Pacchetto | A cosa serve |
|---|---|
| `setspace` | rende compatti float e didascalie con l'interlinea 1.5. **Va caricato prima di `pdfx`**, come `footmisc` |
| `pdfx` (`a-1b,mathxmp`) | PDF/A-1b e metadati XMP letti da `output.xmpdata`; carica anche `hyperref` e `colorprofiles` |
| `fontenc` (T1), `lmodern` | font Latin Modern, con gli accenti italiani corretti |
| `babel` (italian) | lingua del documento |
| `geometry`, `fancyhdr`, `titlesec`, `footmisc` (prima di `pdfx`), `indentfirst`, `emptypage` | margini, intestazioni, titoli, note, pagine vuote |
| `graphicx`, `caption`, `longtable`, `float`, `calc` | figure, didascalie, tabelle su più pagine, posizione `[H]` |
| `xcolor` (`rgb`, con l'opzione `table` della classe) | colori e righe colorate nelle tabelle. **Va caricato prima di `pdfx`** |
| `silence`, `tracklang` | tolgono tre avvisi informativi dal log (vedi `config/packages.tex`) |
| `glossaries` (`toc, acronym, automake`) | glossario e acronimi; `automake` richiede `--shell-escape` |
| `biblatex` + **`biber`** (`verbose-ibid`, `backref`) | bibliografia e citazioni a piè di pagina |
| `csquotes` | virgolette corrette |
| `minted` + **Python/Pygments** | listati di codice; richiede `--shell-escape` |
| `bookmark`, `etoolbox` | segnalibri del PDF, utilità |
| `lipsum` | testo segnaposto: toglietelo quando scrivete la tesi vera |

Sono caricati anche dai pacchetti sopra e vanno presenti (li porta con sé una distribuzione completa): `hyperref`, `colorprofiles`, `xmpincl`, `tracklang`, `translator`, `datatool`, `mfirstuc`, `fvextra`, `latex2pydata`, `pgf`, `greek-fontenc` (per le stringhe Unicode di `hyperref`), i modelli di sillabazione italiani e latini. `microtype` non è usato di proposito: rallenta la compilazione e cambia l'impaginazione; se lo volete, c'è una riga da decommentare.

### Installazione minimale con tlmgr

Per chi ha una installazione ridotta (BasicTeX, TeX Live `scheme-basic`) questo elenco è stato provato su un TeX Live 2025 e su un TeX Live 2026 minimali:

```bash
sudo tlmgr install latexmk biber babel-italian hyphen-italian hyphen-latin biblatex caption catchfile csquotes \
    datatool emptypage everyshi fancyvrb float fontname footmisc fvextra glossaries glossaries-italian \
    greek-fontenc latex2pydata lineno lipsum logreq mfirstuc minted pdfx pgf pgfopts setspace silence \
    supertabular titlesec tracklang translator upquote xcolor xfor xkeyval xmpincl
```

(Non basta elencare solo i pacchetti che il template carica: `pdfx` usa `everyshi` senza dichiararlo tra le dipendenze.) Servono comunque Python 3 e Pygments per `minted`.

## PDF/A e caricamento su Uniweb

Il template produce un **PDF/A-1b** (ISO 19005-1, livello B). L'Ateneo richiede genericamente un "PDF/A" e non impone un livello: il livello "a" richiederebbe un PDF con tag di struttura, che pdfLaTeX non sa generare.

- Per le immagini usate **JPEG** oppure PNG **senza canale alpha**: PDF/A-1 non ammette la trasparenza e la validazione fallirebbe.
- Verifica: `./build.sh check` (veraPDF) oppure il [validatore online](https://www.pdf-online.com/osa/validate.aspx). Gli script lo fanno già alla fine di ogni compilazione.
- Metadati (titolo, autore, parole chiave) in `thesis/files/output.xmpdata`: vanno scritti a mano.
- Per l'upload su Uniweb le [istruzioni di Ateneo](https://www.unipd.it/manuali-uniweb) chiedono un file **PDF/A** di al massimo **40 MB**, nominato `Cognome_Nome.pdf` (`./build.sh -o Rossi_Mario.pdf`). I dati da riportare sul frontespizio sono indicati nella pagina Moodle del proprio corso di laurea. Le regole possono cambiare: controllate sempre le istruzioni aggiornate della vostra struttura.
- Per stampare la tesi senza colori, decommentate `\hypersetup{draft}` in `config/thesis_config.tex`: rimuove link e colore dai riferimenti.

## Glossario e acronimi

Per far apparire il Glossario e la lista degli Acronimi e abbreviazioni occorre citare almeno un termine nel documento, con `\gls{...}`. Le voci si definiscono in `thesis/files/references/glossary_acronyms.tex`.

- `\gls{sdk}` (voce di acronimo): la prima volta compare "_Software Development Kit (SDK)_<sub>G</sub>", poi solo "_SDK_<sub>G</sub>".
- `\gls{sdkg}` (voce di glossario, per convenzione con la `g` finale): compare sempre il termine per esteso, "_Software Development Kit_<sub>G</sub>".
- Ogni termine compare in corsivo con il pedice **G**; nel Glossario e nell'elenco degli acronimi sono indicate le pagine in cui è usato.

Esempi d'uso sono nel capitolo 7 del PDF di esempio (`chapters/7_conclusions.tex`).

## Problemi comuni

| Sintomo | Causa e rimedio |
|---|---|
| Riferimenti `?`, bibliografia vuota, glossario vuoto | Succede alla prima compilazione o dopo modifiche ai file ausiliari: ricompila. Se persiste, `./build.sh clean` (o cancella i file generati) e ricompila. Il glossario compare solo se si cita almeno un termine con `\gls` |
| `You must invoke LaTeX with the -shell-escape flag` | `minted` e `glossaries` richiedono `--shell-escape`: compila con `latexmk` (lo imposta `latexmkrc`) o con `build.sh` |
| `Command \minted@cleancache undefined` | È l'errore della versione 1 con minted 3.x: aggiornare ai file della versione 2 |
| `File 'puenc-greek.def' not found` o `lmodern.sty not found` | Mancano pacchetti TeX: su Debian/Ubuntu `texlive-lang-greek`, `texlive-fonts-recommended`; altrove vedi l'[elenco dei pacchetti](#pacchetti-latex-richiesti) |
| `pygmentize`/`latexminted` non trovato, o errore `minted` | Installare Python 3 e Pygments e riaprire il terminale |
| Il PDF non è PDF/A: regole `6.4.x` (trasparenza) o `6.3.x` (font) | Immagini PNG con canale alpha: usare JPEG o PNG senza alpha. Font non incorporati: vengono da un'immagine o da un PDF inserito |
| Overleaf: "Your project needs more compile time" | È il limite di 10 secondi del piano gratuito, vedi [Il limite di tempo di Overleaf](#il-limite-di-tempo-di-overleaf): ripremere **Recompile** |

## Compatibilità verificata

Il template è stato compilato e validato (veraPDF: **PDF/A-1b valido**) in questi ambienti:

| Ambiente | Esito |
|---|---|
| macOS (Apple Silicon), `./build.sh` con Docker, TeX Live 2026 | verificato |
| macOS, `build.ps1` con PowerShell 7 e Docker | verificato |
| Linux, TeX Live 2026 e 2025 minimali (`tlmgr`, elenco sopra) | verificato |
| Ubuntu 22.04 (TeX Live 2022, minted 2.6) con i pacchetti `apt` indicati | verificato |
| Ubuntu 24.04 (TeX Live 2023, minted 2.9) con i pacchetti `apt` indicati | verificato |
| Compilazione in stile Overleaf (`-jobname=output`, cartella di output separata) | verificato |
| Overleaf (TeX Live 2026, piano gratuito) | compila senza errori; la prima compilazione può superare il limite di 10 s |
| Windows con WSL 2 (Ubuntu) | equivalente ai test su Ubuntu, ma non provato su un PC Windows |
| macOS con TeX Live nativo, Windows nativo (TeX Live/MiKTeX, `build.ps1`), MiKTeX, Git Bash | non provato |

## Licenza

Il template è rilasciato sotto licenza [MIT](LICENSE).
