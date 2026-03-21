;; ClarityStore
;; Key-value storage with ownership clarity on Stacks

;; ── Storage ──────────────────────────────────────────────────────────────

(define-data-var contract-owner principal tx-sender)
(define-data-var pending-owner (optional principal) none)

(define-map store
  { key: (string-ascii 64) }
  { value: (string-utf8 256) }
)

;; ── Events (via print) ───────────────────────────────────────────────────

(define-private (emit-value-set (key (string-ascii 64)) (value (string-utf8 256)))
  (print { event: "value-set", key: key, value: value })
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

(define-public (set-value (key (string-ascii 64)) (value (string-utf8 256)))
  (begin
    (asserts! (is-owner) (err u401))
    (map-set store { key: key } { value: value })
    (emit-value-set key value)
    (ok true)
  )
)

(define-public (delete-value (key (string-ascii 64)))
  (begin
    (asserts! (is-owner) (err u401))
    (map-delete store { key: key })
    (print { event: "value-deleted", key: key })
    (ok true)
  )
)

;; ── Read (anyone, free) ──────────────────────────────────────────────────

(define-read-only (get-value (key (string-ascii 64)))
  (match (map-get? store { key: key })
    entry (ok (get value entry))
    (err u404)
  )
)

(define-read-only (has-key (key (string-ascii 64)))
  (is-some (map-get? store { key: key }))
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
