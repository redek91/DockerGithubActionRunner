Param (
  [Parameter(Mandatory = $false)]
  [string]$owner = $env:GH_OWNER,
  [Parameter(Mandatory = $false)]
  [string]$repo = $env:GH_REPOSITORY,
  [Parameter(Mandatory = $false)]
  [string]$pat = $env:GH_TOKEN
)

# Login to docker
gh auth login

#Get Runner registration Token
$jsonObj = gh api --method POST -H "Accept: application/vnd.github.v3+json" "/repos/$owner/$repo/actions/runners/registration-token"
$regToken = (ConvertFrom-Json -InputObject $jsonObj).token
$runnerBaseName = "dockerNode-"
$runnerName = $runnerBaseName + (((New-Guid).Guid).replace("-", "")).substring(0, 5)

try {
  #Register new runner instance
  write-host "Registering GitHub Self Hosted Runner on: $owner/$repo"
  ./config.cmd --unattended --url "https://github.com/$owner/$repo" --token $regToken --name $runnerName

  #Remove PAT token after registering new instance
  $pat = $null
  $env:GH_TOKEN = $null

  #Start runner listener for jobs
  ./run.cmd
}
catch {
  Write-Error $_.Exception.Message
}