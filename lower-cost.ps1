$projectDir = $PSScriptRoot
$yamlPath = Join-Path $projectDir "deployments\default.mainnet-plan.yaml"
$sender = "SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M"

# Generates YAML for 1 to 30 with lowered fee
$yamlContent = @"
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

for ($i = 1; $i -le 30; $i++) {
    $yamlContent += @"
        - contract-publish:
            contract-name: creative$i
            expected-sender: $sender
            cost: 25
            path: "contracts/creative$i.clar"
            anchor-block-only: true
            clarity-version: 2

"@
}

$yamlContent += @"
      epoch: "2.4"
"@

[System.IO.File]::WriteAllText($yamlPath, $yamlContent.TrimEnd())
Write-Host "YAML updated for creative1 - creative30 with cost lowered to 25 microSTX"
