;; Claim Automation Contract
;; Automates crop insurance claims

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_CLAIM_EXISTS (err u401))
(define-constant ERR_CLAIM_NOT_FOUND (err u402))
(define-constant ERR_INVALID_CLAIM (err u403))
(define-constant ERR_INSUFFICIENT_FUNDS (err u404))

;; Claim status constants
(define-constant CLAIM_PENDING u1)
(define-constant CLAIM_APPROVED u2)
(define-constant CLAIM_REJECTED u3)
(define-constant CLAIM_PAID u4)

;; Data structures
(define-map insurance-claims
  { claim-id: uint }
  {
    farmer-id: uint,
    season: uint,
    claim-type: uint,
    claim-amount: uint,
    yield-loss-percentage: uint,
    weather-severity: uint,
    status: uint,
    filed-block: uint,
    processed-block: uint
  }
)

(define-map claim-payouts
  { farmer-id: uint, season: uint }
  {
    total-payout: uint,
    paid-block: uint
  }
)

(define-data-var next-claim-id uint u1)
(define-data-var insurance-pool uint u0)

;; File a claim
(define-public (file-claim (farmer-id uint) (season uint) (claim-type uint) (yield-loss-percentage uint) (weather-severity uint))
  (let ((claim-id (var-get next-claim-id)))
    (asserts! (> yield-loss-percentage u0) ERR_INVALID_CLAIM)
    (asserts! (is-none (map-get? insurance-claims { claim-id: claim-id })) ERR_CLAIM_EXISTS)

    (let ((claim-amount (calculate-claim-amount farmer-id yield-loss-percentage weather-severity)))
      (map-set insurance-claims
        { claim-id: claim-id }
        {
          farmer-id: farmer-id,
          season: season,
          claim-type: claim-type,
          claim-amount: claim-amount,
          yield-loss-percentage: yield-loss-percentage,
          weather-severity: weather-severity,
          status: CLAIM_PENDING,
          filed-block: block-height,
          processed-block: u0
        }
      )

      (var-set next-claim-id (+ claim-id u1))
      (ok claim-id)
    )
  )
)

;; Process claim automatically
(define-public (process-claim (claim-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)

    (match (map-get? insurance-claims { claim-id: claim-id })
      claim-data
      (let ((should-approve (and
                              (>= (get yield-loss-percentage claim-data) u20)
                              (>= (get weather-severity claim-data) u5))))
        (map-set insurance-claims
          { claim-id: claim-id }
          (merge claim-data {
            status: (if should-approve CLAIM_APPROVED CLAIM_REJECTED),
            processed-block: block-height
          })
        )
        (ok should-approve)
      )
      ERR_CLAIM_NOT_FOUND
    )
  )
)

;; Pay approved claim
(define-public (pay-claim (claim-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)

    (match (map-get? insurance-claims { claim-id: claim-id })
      claim-data
      (begin
        (asserts! (is-eq (get status claim-data) CLAIM_APPROVED) ERR_INVALID_CLAIM)
        (asserts! (>= (var-get insurance-pool) (get claim-amount claim-data)) ERR_INSUFFICIENT_FUNDS)

        (var-set insurance-pool (- (var-get insurance-pool) (get claim-amount claim-data)))

        (map-set insurance-claims
          { claim-id: claim-id }
          (merge claim-data { status: CLAIM_PAID })
        )

        (map-set claim-payouts
          { farmer-id: (get farmer-id claim-data), season: (get season claim-data) }
          {
            total-payout: (get claim-amount claim-data),
            paid-block: block-height
          }
        )

        (ok (get claim-amount claim-data))
      )
      ERR_CLAIM_NOT_FOUND
    )
  )
)

;; Calculate claim amount based on yield loss and weather severity
(define-private (calculate-claim-amount (farmer-id uint) (yield-loss-percentage uint) (weather-severity uint))
  (let ((base-amount u1000)
        (loss-multiplier (/ yield-loss-percentage u10))
        (weather-multiplier (/ weather-severity u2)))
    (* base-amount (+ loss-multiplier weather-multiplier))
  )
)

;; Get claim details
(define-read-only (get-claim (claim-id uint))
  (map-get? insurance-claims { claim-id: claim-id })
)

;; Get insurance pool balance
(define-read-only (get-pool-balance)
  (var-get insurance-pool)
)

;; Add funds to insurance pool
(define-public (add-to-pool (amount uint))
  (begin
    (var-set insurance-pool (+ (var-get insurance-pool) amount))
    (ok (var-get insurance-pool))
  )
)
