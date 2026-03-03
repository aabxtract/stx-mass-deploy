# rename-to-creative.ps1
# Renames all contract files from createN.clar to creativeN.clar
# and regenerates Clarinet.toml and default.mainnet-plan.yaml

$projectDir = $PSScriptRoot
$contractsDir = Join-Path $projectDir "contracts"
$clarinetToml = Join-Path $projectDir "Clarinet.toml"
$deploymentYaml = Join-Path $projectDir "deployments" "default.mainnet-plan.yaml"

# Your deployer address
$sender = "SP3JDRV4QW9SYFSFGT2V1RQ3S1T7CBYG21R29GD8M"

Write-Host "=== Step 1: Renaming contract files ===" -ForegroundColor Cyan

for ($i = 1; $i -le 100; $i++) {
    $oldName = "create$i.clar"
    $newName = "creative$i.clar"
    $oldPath = Join-Path $contractsDir $oldName
    $newPath = Join-Path $contractsDir $newName

    if (Test-Path $oldPath) {
        # Also update the comment inside the file
        $content = Get-Content $oldPath -Raw
        $content = $content -replace "Contract #$i", "Contract #$i"
        $content = $content -replace "Simple Number Storage Contract", "Simple Number Storage Contract"
        Rename-Item -Path $oldPath -NewName $newName -Force
        Write-Host "  Renamed: $oldName -> $newName" -ForegroundColor Green
    }
    elseif (Test-Path $newPath) {
        Write-Host "  Already renamed: $newName" -ForegroundColor Yellow
    }
    else {
        Write-Host "  NOT FOUND: $oldName" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Step 2: Generating Clarinet.toml ===" -ForegroundColor Cyan

$tomlContent = @"
[project]
name = "stx-mass-deploy"
description = "Mass deploy 100 contracts on mainnet"
requirements = []

"@

for ($i = 1; $i -le 100; $i++) {
    $tomlContent += @"
[contracts.creative$i]
path = "contracts/creative$i.clar"
clarity_version = 2
epoch = 2.4

"@
}

Set-Content -Path $clarinetToml -Value $tomlContent.TrimEnd() -Encoding UTF8 -NoNewline
Write-Host "  Clarinet.toml updated with creative1 - creative100" -ForegroundColor Green

Write-Host ""
Write-Host "=== Step 3: Generating default.mainnet-plan.yaml ===" -ForegroundColor Cyan

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
            path: "contracts\\creative$i.clar"
            anchor-block-only: true
            clarity-version: 2

"@
}

$yamlContent += @"
      epoch: "2.4"
"@

Set-Content -Path $deploymentYaml -Value $yamlContent.TrimEnd() -Encoding UTF8 -NoNewline
Write-Host "  default.mainnet-plan.yaml updated with creative1 - creative100" -ForegroundColor Green

Write-Host ""
Write-Host "=== Done! ===" -ForegroundColor Cyan
Write-Host "All 100 contracts renamed from 'create' to 'creative'" -ForegroundColor White
Write-Host "Clarinet.toml and deployment plan updated." -ForegroundColor White
