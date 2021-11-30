#credit to @diomark

# Put your details here:
$walletName = "WALLET_NAME" 
$unlockWallet = 1 # swap to 0 if you want to unlock wallet manually 
$walletPassword = "WALLET_PASSWORD" # only needed if unlocking wallet in script


# unlock wallet
if($unlockWallet -eq 1){
 $body = @{ password=$walletPassword } | ConvertTo-Json
 Invoke-RestMethod -Method Post -Uri "http://127.0.0.1:12973/wallets/$($walletName)/unlock" `
   -ContentType "application/json" -Headers @{ accept='*/*' } -Body $body
}

#check wallet
$oldBalance = Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:12973/wallets/$($walletName)/balances" `
 -ContentType "application/json" | Select-Object -ExpandProperty TotalBalanceHint
Write-Output "Current balance: $($oldBalance)"
$oldDate=Get-Date

while($true) {
 Write-Host "." -NoNewLine
 $newBalance=Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:12973/wallets/$($walletName)/balances" `
  -ContentType "application/json" | Select-Object -ExpandProperty TotalBalanceHint

 if($oldBalance -ne $newBalance) {
   $newDate=Get-Date

   $msg="`nWon a block after $($(($newDate - $oldDate).TotalMinutes).tostring("#")) minutes!"
   " $($msg) Current balance: $($newBalance) " | Write-Output

   $oldDate=$newDate
   $oldBalance = $newBalance
 }

 Start-Sleep 30
}