<#This script changes conformity bot settings
 for all accounts added in console
 Paste in your desired conformity bot time(12hr is max)
#>
$desired_bot_scan_rate = "ENTER BOT SCAN RATE"
$api_key = "ENTER API KEY"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", " application/vnd.api+json")
$headers.Add("Authorization", "ApiKey $api_key")

$response = Invoke-RestMethod 'https://us-west-2-api.cloudconformity.com/v1/accounts' -Method 'GET' -Headers $headers
$account_id = $response.data.id

$first_account = $account_id[0]
$otherAccs ='"' + $account_id[1] + '"'

for($i=2; $i -le ($account_id.length -1); $i +=1){
    $otherAccs+="," +'"'+ $account_id[$i] + '"'
}

Write-Output "Changing bot settings.."
Start-Sleep -Seconds 3

$body = "{
`n  `"data`": {
`n    `"type`": `"accounts`",
`n    `"attributes`": {
`n      `"settings`": {
`n        `"bot`": {
`n          `"delay`": $desired_bot_scan_rate
`n        }
`n      }
`n    }
`n  },
`n  `"meta`": {
`n       `"otherAccounts`": [$otherAccs]
`n  }
`n}"
$request = Invoke-RestMethod "https://us-west-2-api.cloudconformity.com/v1/accounts/$first_account/settings/bot" -Method 'PATCH' -Headers $headers -Body $body
$request | ConvertTo-Json