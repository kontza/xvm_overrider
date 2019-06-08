#!/usr/local/bin/pwsh
$scriptDir = $(Split-Path $MyInvocation.MyCommand.Path)
Set-Location $scriptDir
Copy-Item -Verbose ".\resources\sixthsense.png" ".\..\mods\shared_resources\xvm\res\sixthsense.png"
