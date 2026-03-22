;; StudentStore
;; Stores student records (name and age) with ownership clarity

;; ── Storage ──────────────────────────────────────────────────────────────

(define-data-var contract-owner principal tx-sender)
(define-data-var pending-owner (optional principal) none)

(define-map students
  { name: (string-ascii 64) }
  { age: uint }
)

;; ── Events (via print) ───────────────────────────────────────────────────

(define-private (emit-student-set (name (string-ascii 64)) (age uint))
  (print { event: "student-set", name: name, age: age })
)

(define-private (emit-ownership-proposed (proposed principal))
  (print { event: "ownership-proposed", proposed: proposed })
)

(define-private (emit-ownership-accepted (new-owner principal))
  (print { event: "ownership-accepted", new-owner: new-owner })
)

;; ── Guards ───────────────────────────────────────────────────────────────

(define-private (is-owner)
  (is-eq tx-sender (var-get contract-owner))
)

;; ── Write (owner only) ───────────────────────────────────────────────────

(define-public (set-student (name (string-ascii 64)) (age uint))
  (begin
    (asserts! (is-owner) (err u401))
    (map-set students { name: name } { age: age })
    (emit-student-set name age)
    (ok true)
  )
)

(define-public (delete-student (name (string-ascii 64)))
  (begin
    (asserts! (is-owner) (err u401))
    (map-delete students { name: name })
    (print { event: "student-deleted", name: name })
    (ok true)
  )
)

;; ── Read (anyone, free) ──────────────────────────────────────────────────

(define-read-only (get-student (name (string-ascii 64)))
  (match (map-get? students { name: name })
    entry (ok (get age entry))
    (err u404)
  )
)

(define-read-only (has-student (name (string-ascii 64)))
  (is-some (map-get? students { name: name }))
)

(define-read-only (get-owner)
  (ok (var-get contract-owner))
)

(define-read-only (get-pending-owner)
  (ok (var-get pending-owner))
)

;; ── Ownership (two-step) ─────────────────────────────────────────────────

(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-owner) (err u401))
    (asserts! (not (is-eq new-owner (var-get contract-owner))) (err u400))
    (var-set pending-owner (some new-owner))
    (emit-ownership-proposed new-owner)
    (ok true)
  )
)

(define-public (accept-ownership)
  (let ((pending (unwrap! (var-get pending-owner) (err u404))))
    (asserts! (is-eq tx-sender pending) (err u401))
    (var-set contract-owner pending)
    (var-set pending-owner none)
    (emit-ownership-accepted pending)
    (ok true)
  )
)
