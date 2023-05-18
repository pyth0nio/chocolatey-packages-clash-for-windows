$ErrorActionPreference = 'Stop';
$packageName = $env:ChocolateyPackageName
$softwareName = 'Clash for Windows*'
$fileType = 'exe'
$uninstallArgs = '/currentuser /S'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $file = $key[0].QuietUninstallString.Split('/')[0]
  Uninstall-ChocolateyPackage $packageName $fileType $uninstallArgs $file
}
