Param(
    [string]$AVD = ""
)

$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$adb = Join-Path $sdk "platform-tools\adb.exe"
$emulator = Join-Path $sdk "emulator\emulator.exe"
$gradle = "./gradlew.bat"

if (-not (Test-Path $adb)) { Write-Error "adb not found at $adb"; exit 1 }
if (-not (Test-Path $emulator)) { Write-Error "emulator not found at $emulator"; exit 1 }

# Ensure platform-tools and emulator are available in this session
$env:Path = "$($sdk)\platform-tools;$($sdk)\emulator;" + $env:Path

# Helper to check connected devices
function Get-DeviceList {
    $out = & $adb devices 2>$null
    if (-not $out) { return @() }
    return ($out -split "\r?\n" | Where-Object { $_ -match '\tdevice$' })
}

$devs = Get-DeviceList
if ($devs.Count -eq 0) {
    $avds = & $emulator -list-avds 2>$null
    if (-not $avds) { Write-Error "No AVDs found. Create one in Android Studio AVD Manager."; exit 1 }
    if (-not $AVD) { $AVD = ($avds | Select-Object -First 1).Trim() }

    Start-Process -FilePath $emulator -ArgumentList "-avd `"$AVD`"" -NoNewWindow
    Write-Host "Starting AVD $AVD..."

    & $adb wait-for-device

    # Wait for Android to finish booting
    $tries = 0
    while ((& $adb shell getprop sys.boot_completed 2>$null).Trim() -ne "1") {
        Start-Sleep -Seconds 1
        $tries++
        if ($tries -gt 240) { Write-Error "Emulator boot timed out"; exit 1 }
    }
    Write-Host "Emulator booted."
} else {
    Write-Host "Device/emulator already connected."
}

# Run gradle installDebug in repo root
Write-Host "Building and installing debug APK..."
& $gradle installDebug
if ($LASTEXITCODE -ne 0) { Write-Error "gradle installDebug failed"; exit $LASTEXITCODE }

# Launch the app (update package name if needed)
$pkg = "com.example.lankasmartmart"
Write-Host "Launching $pkg..."
& $adb shell monkey -p $pkg -c android.intent.category.LAUNCHER 1

Write-Host "Done. App should be running on the emulator."