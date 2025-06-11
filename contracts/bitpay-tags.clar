;; BitPay Tags - Decentralized Payment Requests on Stacks
;;
;; Title: BitPay Tags - Bitcoin-Native Payment Request Protocol
;;
;; Summary: 
;; A trustless payment request system enabling users to create, share, and fulfill
;; Bitcoin-backed payment requests with built-in expiration and state management.
;;
;; Description:
;; BitPay Tags revolutionizes peer-to-peer payments by creating shareable payment
;; requests that leverage sBTC on the Stacks blockchain. Users can generate tagged
;; payment requests with custom amounts, expiration times, and memos, while payers
;; can fulfill these requests seamlessly. Perfect for merchants, freelancers, and
;; anyone needing a professional Bitcoin payment solution with guaranteed settlement.
;;
;; Key Features:
;; - Create timestamped payment requests with auto-expiration
;; - Decentralized fulfillment using sBTC tokens
;; - Built-in state management (pending, paid, expired, canceled)
;; - Creator and recipient indexing for efficient queries
;; - Event emission for real-time payment tracking
;; - Protection against double payments and unauthorized access

;; Error Codes
(define-constant ERR-TAG-EXISTS u100)
(define-constant ERR-NOT-PENDING u101)
(define-constant ERR-INSUFFICIENT-FUNDS u102)
(define-constant ERR-NOT-FOUND u103)
(define-constant ERR-UNAUTHORIZED u104)
(define-constant ERR-EXPIRED u105)
(define-constant ERR-INVALID-AMOUNT u106)
(define-constant ERR-EMPTY-MEMO u107)
(define-constant ERR-MAX-EXPIRATION-EXCEEDED u108)
(define-constant ERR-INVALID-RECIPIENT u109)
(define-constant ERR-SELF-PAYMENT u110)

;; State Constants
(define-constant STATE-PENDING "pending")
(define-constant STATE-PAID "paid")
(define-constant STATE-EXPIRED "expired")
(define-constant STATE-CANCELED "canceled")

;; Contract Configuration
;; sBTC token contract address (update with actual mainnet address)
(define-constant SBTC-CONTRACT 'ST1F7QA2MDF17S807EPA36TSS8AMEFY4KA9TVGWXT.sbtc-token)

;; Contract deployer for administrative functions
(define-constant CONTRACT-DEPLOYER tx-sender)

;; Maximum expiration time (30 days in blocks, ~10 min per block)
(define-constant MAX-EXPIRATION-BLOCKS u4320)

;; Maximum number of tags per user for efficient indexing
(define-constant MAX-TAGS-PER-USER u100)

;; Minimum payment amount to prevent spam (0.00001 sBTC)
(define-constant MIN-PAYMENT-AMOUNT u1000)

;; Data Storage

;; Core payment tag storage
(define-map payment-tags
  { id: uint }
  {
    creator: principal,
    recipient: principal,
    amount: uint,
    created-at: uint,
    expires-at: uint,
    memo: (optional (string-ascii 256)),
    state: (string-ascii 16),
    payment-tx: (optional (buff 32)),
    payment-block: (optional uint),
  }
)

;; Creator index for efficient querying
(define-map creator-index
  { creator: principal }
  {
    tag-ids: (list 100 uint),
    count: uint,
  }
)

;; Recipient index for efficient querying
(define-map recipient-index
  { recipient: principal }
  {
    tag-ids: (list 100 uint),
    count: uint,
  }
)