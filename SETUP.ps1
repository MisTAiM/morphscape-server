# ============================================================
#  MORPHSCAPE RSPS — FULL SETUP SCRIPT
#  Run this in PowerShell as Administrator
#  It will: clone repos, check Java, create IntelliJ run config,
#  download RSProx client, and give you a ready-to-launch server
# ============================================================

$ErrorActionPreference = "Stop"
$MORPHSCAPE_DIR = "$env:USERPROFILE\morphscape"
$JAVA21 = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot\bin\java.exe"
$JAVA17 = "C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot\bin\java.exe"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  MORPHSCAPE RSPS — SETUP STARTING" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Check Git ────────────────────────────────────────
Write-Host "[1/7] Checking Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "  OK: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Git not found. Install from https://git-scm.com" -ForegroundColor Red
    exit 1
}

# ── Step 2: Check Java ───────────────────────────────────────
Write-Host "[2/7] Checking Java 21..." -ForegroundColor Yellow
$javaExe = $null
if (Test-Path $JAVA21) {
    $javaExe = $JAVA21
    Write-Host "  OK: Found Java 21 at $JAVA21" -ForegroundColor Green
} else {
    # Try PATH
    try {
        $jv = java -version 2>&1
        $javaExe = "java"
        Write-Host "  OK: Java found in PATH: $jv" -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Java 21 not found." -ForegroundColor Red
        Write-Host "  Install: winget install --id=EclipseAdoptium.Temurin.21.JDK -e" -ForegroundColor Yellow
        exit 1
    }
}

# ── Step 3: Create workspace ─────────────────────────────────
Write-Host "[3/7] Creating workspace at $MORPHSCAPE_DIR..." -ForegroundColor Yellow
if (-not (Test-Path $MORPHSCAPE_DIR)) {
    New-Item -ItemType Directory -Path $MORPHSCAPE_DIR | Out-Null
}
Set-Location $MORPHSCAPE_DIR
Write-Host "  OK: Workspace ready" -ForegroundColor Green

# ── Step 4: Clone RSMod v2 engine ────────────────────────────
Write-Host "[4/7] Cloning RSMod v2 engine (this is the server)..." -ForegroundColor Yellow
if (-not (Test-Path "$MORPHSCAPE_DIR\rsmod")) {
    git clone https://github.com/rsmod/rsmod.git rsmod
    Write-Host "  OK: RSMod v2 cloned" -ForegroundColor Green
} else {
    Write-Host "  SKIP: rsmod already exists, pulling latest..." -ForegroundColor DarkGray
    Set-Location "$MORPHSCAPE_DIR\rsmod"
    git pull
    Set-Location $MORPHSCAPE_DIR
}

# ── Step 5: Clone Morphscape plugins ─────────────────────────
Write-Host "[5/7] Cloning Morphscape plugins..." -ForegroundColor Yellow
if (-not (Test-Path "$MORPHSCAPE_DIR\morphscape-plugins")) {
    git clone https://github.com/MisTAiM/morphscape-plugins.git morphscape-plugins
    Write-Host "  OK: morphscape-plugins cloned" -ForegroundColor Green
} else {
    Write-Host "  SKIP: morphscape-plugins already exists" -ForegroundColor DarkGray
    Set-Location "$MORPHSCAPE_DIR\morphscape-plugins"
    git pull
    Set-Location $MORPHSCAPE_DIR
}

# ── Step 6: Clone Morphscape server data ─────────────────────
Write-Host "[6/7] Cloning Morphscape server config + cache..." -ForegroundColor Yellow
if (-not (Test-Path "$MORPHSCAPE_DIR\morphscape-server")) {
    git clone https://github.com/MisTAiM/morphscape-server.git morphscape-server
    Write-Host "  OK: morphscape-server cloned" -ForegroundColor Green
} else {
    Write-Host "  SKIP: morphscape-server already exists" -ForegroundColor DarkGray
    Set-Location "$MORPHSCAPE_DIR\morphscape-server"
    git pull
    Set-Location $MORPHSCAPE_DIR
}

# ── Step 7: Download RSProx client ───────────────────────────
Write-Host "[7/7] Downloading RSProx client (the thing you play on)..." -ForegroundColor Yellow
$rsproxPath = "$MORPHSCAPE_DIR\RSProxSetup.exe"
if (-not (Test-Path $rsproxPath)) {
    $url = "https://github.com/blurite/rsprox/releases/download/v1.0/RSProxSetup.exe"
    Write-Host "  Downloading from $url..." -ForegroundColor DarkGray
    Invoke-WebRequest -Uri $url -OutFile $rsproxPath
    Write-Host "  OK: RSProxSetup.exe downloaded" -ForegroundColor Green
} else {
    Write-Host "  SKIP: RSProx already downloaded" -ForegroundColor DarkGray
}

# ── Done — Print instructions ─────────────────────────────────
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  SETUP COMPLETE! " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "YOUR FILES ARE AT: $MORPHSCAPE_DIR" -ForegroundColor White
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. OPEN IN INTELLIJ:" -ForegroundColor White
Write-Host "     File -> Open -> $MORPHSCAPE_DIR\rsmod" -ForegroundColor DarkGray
Write-Host "     When prompted: click 'Load Gradle Project'" -ForegroundColor DarkGray
Write-Host "     Wait for Gradle sync to finish (first time = 2-5 min)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  2. RUN THE SERVER IN INTELLIJ:" -ForegroundColor White
Write-Host "     Top-right dropdown -> select 'GameServer'" -ForegroundColor DarkGray
Write-Host "     Click the green Run button" -ForegroundColor DarkGray
Write-Host "     First run auto-downloads game files (~1-2 min)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  3. INSTALL RSPROX CLIENT:" -ForegroundColor White
Write-Host "     Double-click: $rsproxPath" -ForegroundColor DarkGray
Write-Host "     RSProx will connect to localhost automatically" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  4. TELL CLAUDE you're ready -> Claude will configure everything" -ForegroundColor White
Write-Host "     and push Morphscape custom content to the server" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  QUICK LAUNCH SHORTCUT:" -ForegroundColor Yellow
Write-Host "     cd $MORPHSCAPE_DIR\rsmod" -ForegroundColor DarkGray
Write-Host "     .\gradlew run --console=plain" -ForegroundColor DarkGray
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan

# Open the morphscape directory in Explorer
Start-Process explorer.exe $MORPHSCAPE_DIR
