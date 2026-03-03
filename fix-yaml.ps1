$projectDir = $PSScriptRoot
$yamlPath = Join-Path $projectDir "deployments\default.mainnet-plan.yaml"
$sender = "SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M"

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

for ($i = 1; $i -le 100; $i++) {
    $yamlContent += @"
        - contract-publish:
            contract-name: creative$i
            expected-sender: $sender
            cost: 1000
            path: "contracts\creative$i.clar"
            anchor-block-only: true
            clarity-version: 2

"@
}

$yamlContent += @"
      epoch: "2.4"
"@

Set-Content -Path $yamlPath -Value $yamlContent.TrimEnd() -Encoding UTF8 -NoNewline
Write-Host "YAML updated with creative1 - creative100"
