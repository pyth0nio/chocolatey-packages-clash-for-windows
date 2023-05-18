Import-Module AU
$releases = 'https://github.com/Fndroid/clash_for_windows_pkg/releases'



function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
 $latestRelease = Invoke-WebRequest $releases'/latest' -Headers @{"Accept"="application/json"}
 $latestRelease = ($latestRelease.Content | ConvertFrom-Json).tag_name
 $assets = 'https://github.com/Fndroid/clash_for_windows_pkg/releases/expanded_assets/'+$latestRelease
    $download_page = Invoke-WebRequest -Uri $assets -UseBasicParsing
	
    $regex32 = 'ia32.exe$'
    $regex64 = 'Setup[\d.]+\.exe$'
    $url32 = $download_page.links | Where-Object href -match $regex32 | Select-Object -First 1 -expand href
    $url64 = $download_page.links | Where-Object href -match $regex64 | Select-Object -First 1 -expand href
	
    $url32 = -Join ('https://ghproxy.com/https://github.com', $url32)
    $url64 = -Join ('https://ghproxy.com/https://github.com', $url64)
    $url32 -match 'releases/download/v?([\d.]+)/' | Out-Null
    $version = $matches[1]
	
    return @{ Version = $version; URL32 = $url32; URL64 = $url64 }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]fileName32\s*=\s*)('.*')" = "`$1'$($Latest.FileName32)'"
            "(^[$]fileName64\s*=\s*)('.*')" = "`$1'$($Latest.FileName64)'"
        }

        "tools\verification.txt" = @{
            "(?i)(32-Bit.+)\<.*\>" = "`${1}<$($Latest.URL32)>"
            "(?i)(64-Bit.+)\<.*\>" = "`${1}<$($Latest.URL64)>"
            "(?i)(checksum32:\s+).*" = "`${1}$($Latest.Checksum32)"
            "(?i)(checksum64:\s+).*" = "`${1}$($Latest.Checksum64)"
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor none -NoCheckChocoVersion }