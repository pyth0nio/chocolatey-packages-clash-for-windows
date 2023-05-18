$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileName32 = 'Clash.for.Windows.Setup.0.20.23.ia32.exe'
$fileName64 = 'Clash.for.Windows.Setup.0.20.23.exe'

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'exe'
  file         = "$toolsDir\$fileName32"
  file64       = "$toolsDir\$fileName64"
  softwareName = 'Clash for Windows*'
  silentArgs   = '/S'
}

Install-ChocolateyInstallPackage @packageArgs
Remove-Item $packageArgs.file -Force -ea 0
Remove-Item $packageArgs.file64 -Force -ea 0
