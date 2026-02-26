$user = "Diana_Admin"
$apiToken = $env:MY_API_TOKEN
$remoteToken = "myJenkinsBuildToken"
$branch = "master"
$url = "http://localhost:8080/job/herokuapp/buildWithParameters?token=${remoteToken}&BRANCH=${branch}"

$auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${user}:${apiToken}"))
$headers = @{ Authorization = "Basic $auth" }

Write-Host "Sending request for branch: $branch..." -ForegroundColor Cyan

try {
    Invoke-RestMethod -Method Post -Uri $url -Headers $headers -TimeoutSec 10
    Write-Host "DONE! Jenkins accepted the request." -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    }
}

Start-Sleep -Seconds 2
exit
