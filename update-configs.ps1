# Generate updated Clarinet.toml with crt naming
$header = @"
[project]
name = "stx-mass-deploy"
description = "Mass deploy 100 contracts on mainnet"
requirements = []
"@

$contracts = ""
for ($i = 31; $i -le 80; $i++) {
    $contracts += @"

[contracts.crt$i]
path = "contracts/crt$i.clar"
clarity_version = 2
epoch = 2.4
"@
}

Set-Content -Path "Clarinet.toml" -Value ($header + $contracts + "`n") -NoNewline

# Generate updated deployment plan with crt naming
$planHeader = @"
---
id: 0
name: Mainnet deployment
network: mainnet
stacks-node: "https://api.hiro.so"
bitcoin-node: "http://blockstack:blockstacksystem@bitcoin.blockstack.com:8332"
plan:
  batches:
    - id: 0
      transactions:
"@

$batch1 = ""
for ($i = 31; $i -le 55; $i++) {
    $batch1 += @"
        - contract-publish:
            contract-name: crt$i
            expected-sender: SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M
            cost: 1000
            path: "contracts\\crt$i.clar"
            anchor-block-only: true
            clarity-version: 2
"@
}

$batch2Header = @"
      epoch: "2.4"
    - id: 1
      transactions:
"@

$batch2 = ""
for ($i = 56; $i -le 80; $i++) {
    $batch2 += @"
        - contract-publish:
            contract-name: crt$i
            expected-sender: SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M
            cost: 1000
            path: "contracts\\crt$i.clar"
            anchor-block-only: true
            clarity-version: 2
"@
}

$planFooter = @"
      epoch: "2.4"
"@

Set-Content -Path "deployments/default.mainnet-plan.yaml" -Value ($planHeader + $batch1 + $batch2Header + $batch2 + $planFooter + "`n") -NoNewline

Write-Host "Updated Clarinet.toml and default.mainnet-plan.yaml with crt naming."
