# Generate default.testnet-plan.yaml
$yaml = @"
---
id: 0
name: "Testnet Mass Deployment"
network: testnet
stacks-node: "https://stacks-node-api.testnet.stacks.co"
plan:
  batches:
"@

for ($batch = 0; $batch -le 9; $batch++) {
    $yaml += "`n    - id: $batch`n      transactions:`n"
    $start = ($batch * 10) + 1
    $end = $start + 9
    for ($i = $start; $i -le $end; $i++) {
        $yaml += @"
        - contract-publish:
            contract-name: c$i
            expected-sender: deployer
            cost: 180
            path: contracts/c$i.clar
            anchor-block-only: true
            clarity-version: 2

"@
    }
}

Set-Content -Path "deployments\default.testnet-plan.yaml" -Value $yaml.TrimEnd() -NoNewline
Write-Host "Created default.testnet-plan.yaml"
