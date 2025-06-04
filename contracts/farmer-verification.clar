;; Farmer Verification Contract
;; Validates and manages crop insurance farmers

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_FARMER_EXISTS (err u101))
(define-constant ERR_FARMER_NOT_FOUND (err u102))
(define-constant ERR_INVALID_DATA (err u103))

;; Data structures
(define-map farmers
  { farmer-id: uint }
  {
    address: principal,
    name: (string-ascii 50),
    farm-location: (string-ascii 100),
    farm-size: uint,
    crop-type: (string-ascii 30),
    verified: bool,
    registration-block: uint
  }
)

(define-data-var next-farmer-id uint u1)

;; Register a new farmer
(define-public (register-farmer (name (string-ascii 50)) (farm-location (string-ascii 100)) (farm-size uint) (crop-type (string-ascii 30)))
  (let ((farmer-id (var-get next-farmer-id)))
    (asserts! (> (len name) u0) ERR_INVALID_DATA)
    (asserts! (> farm-size u0) ERR_INVALID_DATA)
    (asserts! (is-none (map-get? farmers { farmer-id: farmer-id })) ERR_FARMER_EXISTS)

    (map-set farmers
      { farmer-id: farmer-id }
      {
        address: tx-sender,
        name: name,
        farm-location: farm-location,
        farm-size: farm-size,
        crop-type: crop-type,
        verified: false,
        registration-block: block-height
      }
    )

    (var-set next-farmer-id (+ farmer-id u1))
    (ok farmer-id)
  )
)

;; Verify a farmer (only contract owner)
(define-public (verify-farmer (farmer-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? farmers { farmer-id: farmer-id })
      farmer-data
      (begin
        (map-set farmers
          { farmer-id: farmer-id }
          (merge farmer-data { verified: true })
        )
        (ok true)
      )
      ERR_FARMER_NOT_FOUND
    )
  )
)

;; Get farmer details
(define-read-only (get-farmer (farmer-id uint))
  (map-get? farmers { farmer-id: farmer-id })
)

;; Check if farmer is verified
(define-read-only (is-farmer-verified (farmer-id uint))
  (match (map-get? farmers { farmer-id: farmer-id })
    farmer-data (ok (get verified farmer-data))
    ERR_FARMER_NOT_FOUND
  )
)

;; Get next farmer ID
(define-read-only (get-next-farmer-id)
  (var-get next-farmer-id)
)
