for ($i = 1; $i -le 100; $i++) {
  $content = @"
;; Simple Number Storage Contract #$i
;; Stores a single number that any user can set and read

;; Data variable to store the number
(define-data-var stored-number uint u0)

;; Data variable to track who last updated
(define-data-var last-setter (optional principal) none)

;; Public function: set the stored number
(define-public (set-number (value uint))
  (begin
    (var-set stored-number value)
    (var-set last-setter (some tx-sender))
    (ok value)
  )
)

;; Read-only: get the stored number
(define-read-only (get-number)
  (ok (var-get stored-number))
)

;; Read-only: get who last set the number
(define-read-only (get-last-setter)
  (ok (var-get last-setter))
)

;; Read-only: get the contract id number
(define-read-only (get-contract-id)
  (ok u$i)
)
"@
  # Convert CRLF to LF
  $content = $content -replace "`r`n", "`n"
  $filePath = "contracts\c$i.clar"
  # Write with no BOM and LF line endings
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText((Resolve-Path $filePath -ErrorAction SilentlyContinue).Path, $content, $utf8NoBom)
  if (-not (Test-Path $filePath)) {
    [System.IO.File]::WriteAllText("$PWD\$filePath", $content, $utf8NoBom)
  }
  Write-Host "Fixed c$i.clar (LF)"
}

Write-Host "`nDone! All 100 contracts regenerated with LF line endings."
