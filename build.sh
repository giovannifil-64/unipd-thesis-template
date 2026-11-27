#!/usr/bin/env bash
#
# build.sh: compila la tesi LaTeX e produce un PDF/A, senza Overleaf.
#
# Uso:
#   ./build.sh                 compila, copia il PDF in ./thesis.pdf e lo valida con veraPDF
#   ./build.sh check [file]    valida un PDF/A già esistente (default: ./thesis.pdf)
#   ./build.sh clean           cancella la cartella di lavoro build/ e thesis.pdf
#
# Opzioni:
#   --docker      usa Docker (immagine texlive/texlive) anche se TeX Live è installato
#   --native      usa il TeX Live installato sul sistema
#   --no-check    non valida il PDF/A dopo la compilazione
#   -o FILE       percorso del PDF finale (default: ./thesis.pdf; per l'upload su Uniweb: Cognome_Nome.pdf)
#   -v            mostra l'output completo di latexmk durante la compilazione
#   -h            questo aiuto
#
# Variabili d'ambiente:
#   THESIS_SRC       cartella con i sorgenti (default: thesis/files)
#   THESIS_MAX_MB    soglia dell'avviso sulla dimensione del PDF (default: 40, il limite di Uniweb)
#   TEXLIVE_IMAGE    immagine Docker (default: texlive/texlive:latest; per riprodurre una versione
#                    precisa, ad esempio quella di Overleaf: texlive/texlive:TL2025-historic)
#
# Codici di uscita: 0 ok, 1 compilazione fallita, 2 PDF/A non valido, 3 errore d'uso o d'ambiente.

set -eu

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="${THESIS_SRC:-$ROOT/thesis/files}"
MAIN="thesis"   # file principale: thesis.tex
JOB="output"
BUILD="$ROOT/build"
WORK="$BUILD/work"
OUT="$ROOT/thesis.pdf"
IMAGE="${TEXLIVE_IMAGE:-texlive/texlive:latest}"

CMD="build"
ENGINE="auto"
CHECK=1
VERBOSE=0
CHECK_FILE=""

case "$(uname -s 2>/dev/null)" in
    MINGW*|MSYS*|CYGWIN*) export MSYS_NO_PATHCONV=1; WINDOWS=1 ;;
    *) WINDOWS=0 ;;
esac

if [ -t 1 ]; then
    G="$(printf '\033[32m')"; R="$(printf '\033[31m')"; Y="$(printf '\033[33m')"; N="$(printf '\033[0m')"
else
    G=""; R=""; Y=""; N=""
fi

msg()  { printf '%s\n' "$*"; }
warn() { printf '%sAttenzione:%s %s\n' "$Y" "$N" "$*" >&2; }
die()  { printf '%sErrore:%s %s\n' "$R" "$N" "$*" >&2; exit "${2:-3}"; }
have() { command -v "$1" >/dev/null 2>&1; }

usage() { sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
    case "$1" in
        build|clean) CMD="$1" ;;
        check)       CMD="check"
                     if [ $# -gt 1 ] && [ "${2#-}" = "$2" ]; then CHECK_FILE="$2"; shift; fi ;;
        --docker)    ENGINE="docker" ;;
        --native)    ENGINE="native" ;;
        --no-check)  CHECK=0 ;;
        -o)          [ $# -gt 1 ] || die "-o richiede un percorso"; OUT="$2"; shift ;;
        -v)          VERBOSE=1 ;;
        -h|--help)   usage; exit 0 ;;
        *)           die "argomento sconosciuto: $1 (vedi ./build.sh -h)" ;;
    esac
    shift
done

validate() {
    pdf="$1"
    [ -f "$pdf" ] || die "file non trovato: $pdf"
    if ! have verapdf; then
        warn "veraPDF non è installato: validazione PDF/A saltata (macOS: brew install verapdf; altri sistemi: https://verapdf.org/software/)."
        return 0
    fi
    msg "Validazione PDF/A con veraPDF..."
    # senza --flavour veraPDF legge il livello (1b, 2b...) dichiarato nei metadati del file
    result="$(verapdf --format text -v "$pdf" 2>&1 || true)"
    first="$(printf '%s\n' "$result" | head -n 1)"
    if printf '%s\n' "$first" | grep -q '^PASS'; then
        # l'ultimo campo della riga è il livello (1b, 2b...); il percorso può contenere spazi
        printf '%sPASS: PDF/A valido, livello %s%s\n' "$G" "$(printf '%s\n' "$first" | awk '{print $NF}')" "$N"
        return 0
    fi
    printf '%sFAIL: il file NON è un PDF/A valido.%s Regole violate:\n' "$R" "$N" >&2
    printf '%s\n' "$result" | sed 's/^/  /' >&2
    return 2
}

if [ "$CMD" = "clean" ]; then
    rm -rf "$BUILD" "$OUT"
    msg "Pulito: build/ e $(basename "$OUT") rimossi."
    exit 0
fi

if [ "$CMD" = "check" ]; then
    validate "${CHECK_FILE:-$OUT}" || exit $?
    exit 0
fi

[ -f "$SRC/$MAIN.tex" ] || die "non trovo $SRC/$MAIN.tex (imposta THESIS_SRC se i sorgenti sono altrove)"

native_ok() { have latexmk && have pdflatex && have biber && { have latexminted || have pygmentize; }; }
docker_ok() { have docker && docker info >/dev/null 2>&1; }

if [ "$ENGINE" = "auto" ]; then
    if native_ok; then ENGINE="native"
    elif docker_ok; then ENGINE="docker"
    else
        msg "Non ho trovato né una distribuzione TeX completa né Docker in esecuzione." >&2
        msg "Scegline una:" >&2
        msg "  - TeX Live:  macOS: brew install --cask mactex-no-gui   (poi riapri il terminale)" >&2
        msg "               Linux: sudo apt install texlive-latex-extra texlive-fonts-recommended texlive-lang-italian texlive-bibtex-extra biber latexmk python3-pygments" >&2
        msg "               (l'elenco completo dei pacchetti è nel README)" >&2
        msg "  - Docker:    installa e avvia Docker Desktop; la prima volta scarica l'immagine $IMAGE" >&2
        have docker && ! docker_ok && msg "Docker è installato ma il demone non risponde: avvia Docker Desktop." >&2
        exit 3
    fi
elif [ "$ENGINE" = "native" ]; then
    native_ok || die "TeX Live incompleto: servono latexmk, pdflatex, biber e minted (latexminted o pygmentize). Prova con --docker."
else
    docker_ok || die "Docker non è in esecuzione."
fi

mkdir -p "$WORK"
if have rsync; then
    rsync -a --delete \
        --exclude='.DS_Store' \
        --exclude='/*.acn' --exclude='/*.acr' --exclude='/*.alg' --exclude='/*.aux' --exclude='/*.bbl' \
        --exclude='/*.bcf' --exclude='/*.blg' --exclude='/*.fdb_latexmk' --exclude='/*.fls' --exclude='/*.glg' \
        --exclude='/*.glo' --exclude='/*.gls' --exclude='/*.glsdefs' --exclude='/*.ist' --exclude='/*.lof' \
        --exclude='/*.log' --exclude='/*.lol' --exclude='/*.lot' --exclude='/*.out' --exclude='/*.run.xml' \
        --exclude='/*.toc' --exclude='/*.xmpi' --exclude='/'"$JOB"'.pdf' --exclude='/'"$MAIN"'.pdf' \
        --exclude='/minted-caches/' --exclude='/_minted*' --exclude='/_*.minted' \
        "$SRC"/ "$WORK"/
else
    rm -rf "$WORK"; mkdir -p "$WORK"
    cp -R "$SRC"/. "$WORK"/
    (
        cd "$WORK"
        for ext in acn acr alg aux bbl bcf blg fdb_latexmk fls glg glo gls glsdefs ist lof log lol lot out run.xml toc xmpi; do
            rm -f ./*."$ext"
        done
        rm -rf "$JOB.pdf" "$MAIN.pdf" minted-caches _minted* _*.minted
        find . -name .DS_Store -exec rm -f {} +
    )
fi

LOG="$BUILD/latexmk.log"
SECONDS=0

if [ "$ENGINE" = "docker" ]; then
    if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
        msg "Prima esecuzione: scarico l'immagine $IMAGE (alcuni GB, serve una volta sola)..."
    fi
    msg "Compilazione con Docker ($IMAGE)..."
    if [ "$WINDOWS" -eq 1 ]; then DOCKER_USER=""; else DOCKER_USER="-u $(id -u):$(id -g)"; fi
    # HOME=/tmp: l'utente nel container non ha una home scrivibile (serve a biber e minted);
    # $DOCKER_USER resta senza virgolette di proposito: sono due argomenti ("-u" e "uid:gid") oppure nessuno
    run_tex() {
        # shellcheck disable=SC2086
        docker run --rm -e HOME=/tmp $DOCKER_USER \
            -v "$WORK":/work -w /work "$IMAGE" \
            latexmk -pdf -shell-escape -interaction=nonstopmode -file-line-error "$MAIN.tex"
    }
else
    msg "Compilazione con il TeX Live locale..."
    run_tex() {
        ( cd "$WORK" && latexmk -pdf -shell-escape -interaction=nonstopmode -file-line-error "$MAIN.tex" )
    }
fi

status=0
if [ "$VERBOSE" -eq 1 ]; then
    set +e
    run_tex 2>&1 | tee "$LOG"
    status="${PIPESTATUS[0]}"
    set -e
else
    run_tex >"$LOG" 2>&1 || status=$?
fi

if [ "$status" -ne 0 ] || [ ! -f "$WORK/$JOB.pdf" ]; then
    printf '%sCompilazione fallita%s (latexmk, codice %s). Primi errori:\n' "$R" "$N" "$status" >&2
    if [ -f "$WORK/$JOB.log" ] && grep -qE '^(\./|\.\./)?[^ ]+:[0-9]+: |^! ' "$WORK/$JOB.log"; then
        grep -E -A3 '^(\./|\.\./)?[^ ]+:[0-9]+: |^! ' "$WORK/$JOB.log" | head -n 30 | sed 's/^/  /' >&2
    else
        tail -n 25 "$LOG" | sed 's/^/  /' >&2
    fi
    msg "Log completi: $LOG  e  $WORK/$JOB.log" >&2
    exit 1
fi

cp "$WORK/$JOB.pdf" "$OUT"

pages=""; size="$(du -h "$OUT" | awk '{print $1}')"
have pdfinfo && pages="$(pdfinfo "$OUT" 2>/dev/null | awk '/^Pages:/{print $2}')"
printf '%sOK%s: %s%s, %s in %ss\n' "$G" "$N" "$OUT" "${pages:+ ($pages pagine)}" "$size" "$SECONDS"

# Uniweb accetta file PDF/A fino a 40 MB
MAX_MB="${THESIS_MAX_MB:-40}"
size_kb="$(du -k "$OUT" | awk '{print $1}')"
if [ "$size_kb" -gt $((MAX_MB * 1024)) ]; then
    warn "il PDF supera $MAX_MB MB, il limite di caricamento (immagini troppo pesanti? prova a ridurle)."
fi

if grep -qE 'undefined (references|citations)|There were undefined' "$WORK/$JOB.log" 2>/dev/null; then
    warn "ci sono riferimenti o citazioni non risolti: vedi $WORK/$JOB.log"
fi

if [ "$CHECK" -eq 1 ]; then
    validate "$OUT" || exit $?
fi
