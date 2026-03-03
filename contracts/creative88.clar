;; Simple Number Storage Contract #88
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
  (ok u88)
)