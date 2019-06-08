#!/usr/local/bin/pwsh
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