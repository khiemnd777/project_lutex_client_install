
.\install-git.ps1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Set-Location -LiteralPath $PSScriptRoot

$config = Get-Content -Raw -Path '.\init.config.json' | ConvertFrom-Json
$gitProtocol = if ($config.GIT_SSL -eq 'True') {'https://'} else {'http://'}
$gitEmail = $config.GIT_USERNAME
$gitPassword = $config.GIT_PASSWORD
$gitProvider = $config.GIT_PROVIDER
$gitUser = $config.GIT_USERNAME
$gitSource = '{0}.git' -f $config.GIT_SOURCE
$gitHttps = '{0}{1}:{2}@{3}/{4}/{5}' -f $gitProtocol, $gitEmail, $gitPassword, $gitProvider, $gitUser, $gitSource

# git clone source as HTTPS
git clone $gitHttps
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }


# clone the init.config and use this as build.config
Copy-Item '.\init.config.json' -Destination ('.\{0}\build.config.json' -f $config.GIT_SOURCE)
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# switch to the source directory
Set-Location -LiteralPath $('.\' + $config.GIT_SOURCE)
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# install and run the source
.\build.ps1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Set-Location -LiteralPath $PSScriptRoot
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }