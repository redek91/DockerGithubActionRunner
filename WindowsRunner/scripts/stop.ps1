Param (
  [Parameter(Mandatory = $false)]
  [string]$owner = $env:GH_OWNER,
  [Parameter(Mandatory = $false)]
  [string]$repo = $env:GH_REPOSITORY,
  [Parameter(Mandatory = $false)]
  [string]$pat = $env:GH_TOKEN
)

# Login to github
gh auth login

#Get Runner registration Token
$jsonObj = gh api --method POST -H "Accept: application/vnd.github.v3+json" "/repos/$owner/$repo/actions/runners/registration-token"
$regToken = (ConvertFrom-Json -InputObject $jsonObj).token

# Remove runner from repository
./config.cmd remove --unattended --token $regToken