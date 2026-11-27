<#
.SYNOPSIS
    Compila la tesi LaTeX e produce un PDF/A, senza Overleaf (Windows PowerShell 5.1+ oppure PowerShell 7).

.DESCRIPTION
    Equivalente di build.sh per chi lavora su Windows senza WSL.
    Usa il TeX Live / MiKTeX installato (servono latexmk, pdflatex, biber e minted con Python + Pygments);
    se non c'e', usa Docker Desktop con l'immagine texlive/texlive.
    Il PDF finale e' ./thesis.pdf e viene validato con veraPDF, se installato.

    Se PowerShell rifiuta di eseguire lo script (criteri di esecuzione):
        powershell -ExecutionPolicy Bypass -File .\build.ps1

.EXAMPLE
    .\build.ps1                        compila, crea thesis.pdf e lo valida
.EXAMPLE
    .\build.ps1 -Command check         valida il PDF/A esistente (thesis.pdf)
.EXAMPLE
    .\build.ps1 -Docker -Output Rossi_Mario.pdf
.EXAMPLE
    .\build.ps1 -Command clean

    Variabili d'ambiente: THESIS_SRC (cartella dei sorgenti, default thesis\files),
    THESIS_MAX_MB (soglia dell'avviso sulla dimensione, default 40), TEXLIVE_IMAGE (immagine Docker).
    Codici di uscita: 0 ok, 1 compilazione fallita, 2 PDF/A non valido, 3 errore d'uso o d'ambiente.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('build', 'check', 'clean')]
    [string]$Command = 'build',

    [Parameter(Position = 1)]
    [string]$File,

    [switch]$Docker,     # usa Docker anche se TeX e' installato
    [switch]$Native,     # usa il TeX installato sul sistema
    [switch]$NoCheck,    # non valida il PDF/A
    [string]$Output      # percorso del PDF finale (default: .\thesis.pdf)
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$Root  = $PSScriptRoot
$Src   = if ($env:THESIS_SRC) { $env:THESIS_SRC } else { Join-Path $Root 'thesis/files' }
$Main  = 'thesis'      # file principale: thesis.tex
$Job   = 'output'      # deve coincidere con $jobname in latexmkrc e con output.xmpdata
$Build = Join-Path $Root 'build'
$Work  = Join-Path $Build 'work'
$Out   = if ($Output) { $Output } else { Join-Path $Root 'thesis.pdf' }
$Image = if ($env:TEXLIVE_IMAGE) { $env:TEXLIVE_IMAGE } else { 'texlive/texlive:latest' }
$MaxMb = if ($env:THESIS_MAX_MB) { [int]$env:THESIS_MAX_MB } else { 40 }
$Log   = Join-Path $Build 'latexmk.log'

function Have([string]$name) { [bool](Get-Command $name -ErrorAction SilentlyContinue) }

function Fail([string]$message, [int]$code = 3) {
    [Console]::Error.WriteLine("Errore: $message")
    exit $code
}

function Warn([string]$message) { Write-Warning $message }

# Esegue un comando nativo e ne restituisce il codice di uscita (senza che gli errori su stderr fermino lo script)
function Invoke-Native([string]$exe, [string[]]$arguments, [string]$logFile) {
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        # l'output va nel file di log oppure viene scartato: altrimenti finirebbe nel valore restituito dalla funzione
        if ($logFile) { & $exe @arguments *> $logFile } else { & $exe @arguments *> $null }
        return $LASTEXITCODE
    }
    finally { $ErrorActionPreference = $previous }
}

# ---------------------------------------------------------------- validazione PDF/A
function Test-PdfA([string]$pdf) {
    if (-not (Test-Path -LiteralPath $pdf)) { Fail "file non trovato: $pdf" }
    if (-not (Have 'verapdf')) {
        Warn 'veraPDF non e'' installato: validazione PDF/A saltata (https://verapdf.org/software/).'
        return 0
    }
    Write-Host 'Validazione PDF/A con veraPDF...'
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $result = & verapdf --format text -v $pdf 2>&1 | ForEach-Object { "$_" } }
    finally { $ErrorActionPreference = $previous }
    $first = ($result | Select-Object -First 1)
    if ($first -match '^PASS') {
        $level = ($first -split '\s+')[-1]
        Write-Host "PASS: PDF/A valido, livello $level" -ForegroundColor Green
        return 0
    }
    [Console]::Error.WriteLine('FAIL: il file NON e'' un PDF/A valido. Regole violate:')
    $result | ForEach-Object { [Console]::Error.WriteLine("  $_") }
    return 2
}

# ---------------------------------------------------------------- comandi semplici
if ($Command -eq 'clean') {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $Build, $Out
    Write-Host "Pulito: build/ e $(Split-Path -Leaf $Out) rimossi."
    exit 0
}

if ($Command -eq 'check') {
    $target = if ($File) { $File } else { $Out }
    exit (Test-PdfA $target)
}

# ---------------------------------------------------------------- scelta del motore
if (-not (Test-Path -LiteralPath (Join-Path $Src "$Main.tex"))) {
    Fail "non trovo $(Join-Path $Src "$Main.tex") (imposta THESIS_SRC se i sorgenti sono altrove)"
}

function Test-NativeOk { (Have 'latexmk') -and (Have 'pdflatex') -and (Have 'biber') -and ((Have 'latexminted') -or (Have 'pygmentize')) }
function Test-DockerOk {
    if (-not (Have 'docker')) { return $false }
    return ((Invoke-Native 'docker' @('info') $null) -eq 0)
}

if ($Docker -and $Native) { Fail 'usa solo uno tra -Docker e -Native' }

if ($Docker)      { $engine = 'docker'; if (-not (Test-DockerOk)) { Fail 'Docker non e'' in esecuzione.' } }
elseif ($Native)  { $engine = 'native'; if (-not (Test-NativeOk)) { Fail 'TeX incompleto: servono latexmk, pdflatex, biber e minted (latexminted o pygmentize). Prova con -Docker.' } }
elseif (Test-NativeOk) { $engine = 'native' }
elseif (Test-DockerOk) { $engine = 'docker' }
else {
    [Console]::Error.WriteLine('Non ho trovato ne'' una distribuzione TeX completa ne'' Docker in esecuzione.')
    [Console]::Error.WriteLine('Scegline una:')
    [Console]::Error.WriteLine('  - TeX Live o MiKTeX, piu'' Python con Pygments (pip install pygments): l''elenco dei pacchetti e'' nel README')
    [Console]::Error.WriteLine("  - Docker Desktop: installalo e avvialo; la prima volta scarica l'immagine $Image")
    exit 3
}

# ---------------------------------------------------------------- copia dei sorgenti nella cartella di lavoro
# Cartella di lavoro pulita a ogni esecuzione (build/work), cosi' i file ausiliari non sporcano i sorgenti.
if (Test-Path -LiteralPath $Work) { Remove-Item -Recurse -Force $Work }
New-Item -ItemType Directory -Force -Path $Work | Out-Null
Copy-Item -Path (Join-Path $Src '*') -Destination $Work -Recurse -Force
# tolgo dalla copia i file generati che si trovano nella radice dei sorgenti
foreach ($ext in 'acn', 'acr', 'alg', 'aux', 'bbl', 'bcf', 'blg', 'fdb_latexmk', 'fls', 'glg', 'glo', 'gls', 'glsdefs', 'ist', 'lof', 'log', 'lol', 'lot', 'out', 'run.xml', 'toc', 'xmpi') {
    Get-ChildItem -LiteralPath $Work -File -Filter "*.$ext" -ErrorAction SilentlyContinue | Remove-Item -Force
}
foreach ($name in "$Job.pdf", "$Main.pdf") { Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path $Work $name) }
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue (Join-Path $Work 'minted-caches')
Get-ChildItem -LiteralPath $Work -Directory -Filter '_minted*' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
Get-ChildItem -LiteralPath $Work -Recurse -Force -File -Filter '.DS_Store' -ErrorAction SilentlyContinue | Remove-Item -Force

# ---------------------------------------------------------------- compilazione
$latexmkArgs = @('-pdf', '-shell-escape', '-interaction=nonstopmode', '-file-line-error', "$Main.tex")
$timer = [System.Diagnostics.Stopwatch]::StartNew()

if ($engine -eq 'docker') {
    Write-Host "Compilazione con Docker ($Image)..."
    $dockerArgs = @('run', '--rm', '-e', 'HOME=/tmp')
    # su Linux/macOS i file creati nel container devono appartenere all'utente (su Windows non serve)
    $onUnix = ($PSVersionTable.PSVersion.Major -ge 6) -and ($PSVersionTable.Platform -eq 'Unix')
    if ($onUnix -and (Have 'id')) {
        $dockerArgs += @('-u', "$(& id -u):$(& id -g)")
    }
    $dockerArgs += @('-v', "${Work}:/work", '-w', '/work', $Image, 'latexmk') + $latexmkArgs
    $status = Invoke-Native 'docker' $dockerArgs $Log
}
else {
    Write-Host 'Compilazione con il TeX locale...'
    Push-Location $Work
    try { $status = Invoke-Native 'latexmk' $latexmkArgs $Log }
    finally { Pop-Location }
}

$workPdf = Join-Path $Work "$Job.pdf"
if (($status -ne 0) -or -not (Test-Path -LiteralPath $workPdf)) {
    [Console]::Error.WriteLine("Compilazione fallita (latexmk, codice $status). Primi errori:")
    $texLog = Join-Path $Work "$Job.log"
    $errors = @()
    if (Test-Path -LiteralPath $texLog) {
        $errors = @(Select-String -Path $texLog -Pattern '^(\./|\.\./)?[^ ]+:\d+: |^! ' -Context 0, 3 | Select-Object -First 10)
    }
    if ($errors.Count -gt 0) {
        foreach ($e in $errors) {
            [Console]::Error.WriteLine("  $($e.Line)")
            foreach ($c in $e.Context.PostContext) { [Console]::Error.WriteLine("  $c") }
        }
    }
    elseif (Test-Path -LiteralPath $Log) {
        Get-Content -LiteralPath $Log -Tail 25 | ForEach-Object { [Console]::Error.WriteLine("  $_") }
    }
    [Console]::Error.WriteLine("Log completi: $Log  e  $texLog")
    exit 1
}

Copy-Item -LiteralPath $workPdf -Destination $Out -Force

$sizeBytes = (Get-Item -LiteralPath $Out).Length
$sizeText = '{0:N1} MB' -f ($sizeBytes / 1MB)
Write-Host ("OK: {0}, {1} in {2:N0}s" -f $Out, $sizeText, $timer.Elapsed.TotalSeconds) -ForegroundColor Green

if ($sizeBytes -gt ($MaxMb * 1MB)) {
    Warn "il PDF supera $MaxMb MB, il limite di caricamento (immagini troppo pesanti? prova a ridurle)."
}

$texLogPath = Join-Path $Work "$Job.log"
if ((Test-Path -LiteralPath $texLogPath) -and (Select-String -Path $texLogPath -Pattern 'undefined (references|citations)|There were undefined' -Quiet)) {
    Warn "ci sono riferimenti o citazioni non risolti: vedi $texLogPath"
}

if (-not $NoCheck) { exit (Test-PdfA $Out) }
exit 0
