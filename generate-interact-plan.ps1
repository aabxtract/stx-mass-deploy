$planHeader = @"
---
id: 1
name: Mainnet Interactions
network: mainnet
stacks-node: "https://api.hiro.so"
bitcoin-node: "http://blockstack:blockstacksystem@bitcoin.blockstack.com:8332"
plan:
  batches:
    - id: 0
      transactions:
"@

$transactions = ""
for ($i = 56; $i -le 80; $i++) {
    $transactions += @"
        - contract-call:
            contract-id: SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M.create$i
            expected-sender: SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M
            method: set-number
            parameters:
              - "u$i"
            cost: 1000
"@
}

Set-Content -Path "deployments/interact.mainnet-plan.yaml" -Value ($planHeader + $transactions + "`n") -NoNewline
Write-Host "Done"
