Get-ChildItem -Path "contracts" -Filter "contract*.clar" | ForEach-Object {
    $newName = $_.Name -replace '^contract', 'crt'
    Rename-Item -Path $_.FullName -NewName $newName
    Write-Host "Renamed $($_.Name) -> $newName"
}
Write-Host "Done! All contract files renamed."
