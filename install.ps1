#!/usr/local/bin/pwsh
param (
    [string]$XVM_VERSION = "",
    [switch]$DEV_XVM,
    [switch]$verbose
)

# Figure out the XVM version to work with.
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
    # Set up the URL to download from.
    if ($DEV_XVM) {
        $XVM_RELEASE = "latest_xvm.zip"
        $XVM_URL = "http://nightly.modxvm.com/download/default/$XVM_RELEASE"
    }
    else {
        $XVM_RELEASE = "xvm-$XVM_VERSION.zip"
        $XVM_URL = "http://dl1.modxvm.com/get/bin/$XVM_RELEASE"
    }

    if (Test-Path $XVM_RELEASE) {
        $answer = Read-Host "$XVM_RELEASE already exists. Download again? (yes/no)"
    }
    else {
        $answer = "yes"
    }

    # Download.
    if ($answer.Trim().ToLower().StartsWith("y")) {
        if ($verbose) {
            Write-Output "Downloading '$XVM_URL'..."
        }
        else {
            Write-Output "Downloading '$XVM_RELEASE'..."
        }
        Invoke-WebRequest -uri $XVM_URL -out "$XVM_RELEASE"
    }

    # Remove previous mods & res_mods.
    if (Test-Path "..\mods") {
        Remove-Item -recurse -force "..\mods"
    }
    if (Test-Path "..\res_mods") {
        Remove-Item -recurse -force "..\res_mods"
    }
    Write-Output "Cleared away the old XVM installation."

    # Unzip.
    if (Test-Path $XVM_RELEASE) {
        Write-Output "Extracting..."
        Expand-Archive -force "$XVM_RELEASE" -DestinationPath "..\"
        Write-Output "Done."
    }
    else {
        Write-Output "Download failed."
    }

    # Rename the sample config to be the real config.
    Move-Item ".\..\res_mods\configs\xvm\xvm.xc.sample" ".\..\res_mods\configs\xvm\xvm.xc"

    # Copy our overrider.
    @{
        id                     = "com.modxvm.xvm.overrider";
        name                   = "XVM Overrider";
        description            = "XVM Overrider module";
        version                = "1.0";
        dependencies           = @("com.modxvm.xvm");
        url                    = "https://modxvm.com/";
        url_update             = "https://modxvm.com/";
        wot_version_min        = "1.5.0.4";
        wot_version_exactmatch = $False;
        features               = @("python");
    } | ConvertTo-Json -Compress | Out-File -FilePath xvm_overrider/xfw_package.json -Encoding UTF8
    Write-Output "Generated xfw_package.json for the overrider."
    Copy-Item -Recurse ".\xvm_overrider"  "..\res_mods\mods\xfw_packages\"
    Write-Output "Copied the XVM Overrider plugin."

    # Sixthsense.
    Copy-Item "resources\sixthsense.png" ".\..\res_mods\mods\shared_resources\xvm\res\sixthsense.png"
    Write-Output "Copied the sixth sense -image."
}