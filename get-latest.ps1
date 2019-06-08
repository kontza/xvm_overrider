#!/usr/local/bin/pwsh
param (
    [string]$XVM_VERSION = "",
    [switch]$DEV_XVM,
    [switch]$noBCompare,
    [switch]$verbose
)

if ($DEV_XVM) {
    $XVM_VERSION = "DEV"
}
else {
    if ($XVM_VERSION) {
        Write-Output "Trying to work with XVM $XVM_VERSION..."
    }
    else {
        $XVM_VERSION = $(Invoke-WebRequest -uri http://nightly.modxvm.com/download/default/xvm_version.txt -usebasic).content.Trim()
        $answer = Read-Host "No XVM version specified (via -x). Try with the latest ($XVM_VERSION) (yes/no)"
        if (!$answer.Trim().ToLower().StartsWith("y")) {
            $XVM_VERSION = ""
            Write-Host "All done, then."
        }
    }
}

if ($XVM_VERSION) {
    if ($DEV_XVM) {
        $XVM_RELEASE = "latest_xvm.zip"
        $XVM_URL = "http://nightly.modxvm.com/download/default/$XVM_RELEASE"
    }
    else {
        $XVM_RELEASE = "xvm-$XVM_VERSION.zip"
        $XVM_URL = "http://dl1.modxvm.com/get/bin/$XVM_RELEASE"
    }
    if (Test-Path "latest") {
        Remove-Item -recurse -force latest
    }
    if (Test-Path $XVM_RELEASE) {
        $answer = Read-Host "$XVM_RELEASE already exists. Download again? (yes/no)"
    } else {
        $answer = "yes"
    }
    if ($answer.Trim().ToLower().StartsWith("y")) {
        if ($verbose) {
            Write-Output "Downloading '$XVM_URL'..."
        }
        else {
            Write-Output "Downloading '$XVM_RELEASE'..."
        }
        Invoke-WebRequest -uri $XVM_URL -out "$XVM_RELEASE"
    }
    if (Test-Path $XVM_RELEASE) {
        Write-Output "Extracting..."
        Expand-Archive "$XVM_RELEASE" -DestinationPath latest
        Write-Output "Clearing old PYC-files..."
        $scriptDir = $(Split-Path $MyInvocation.MyCommand.Path)
        Set-Location $scriptDir
        if ($verbose) {
            Write-Output "[scriptDir = $scriptDir]"
        }
        Get-ChildItem -Path ".\..\.." -Filter *.pyc -Recurse | ForEach-Object ($_) {Remove-Item $_.FullName}
        if ($noBCompare) {
            Write-Output "Bypassing Beyond Compare."
        }
        else {
            Write-Output "Launch Beyond Compare..."
            bcomp . ./latest/res_mods/configs
        }
        Write-Output "Done."
    }
    else {
        Write-Output "Download failed."
    }
}