(define-constant TOKEN-ADDRESS SP2TOKENADDRESS) ;; I'll replace this with actual token address
(define-constant CONTRACT-OWNER SP2OWNERADDRESS) ;; Also will replace with actual owner address
(define-constant GAME-FEE 2000)
(define-constant STAKE-REQUIREMENT 100)
(define-constant PLAYER-LIMIT 100)

;; Data map for storing participants
(define-map participants
  {player: principal}
  {staked: uint, is-active: bool})

;; Variable for tracking the total number of participants
(define-data-var total-participants uint 0)

;; Function for players to join the game
(define-public (join-game)
  (let ((player-tokens (ft-get-balance TOKEN-ADDRESS tx-sender)))
    (if (and (>= player-tokens STAKE-REQUIREMENT) 
             (< (var-get total-participants) PLAYER-LIMIT)
             (is-none (map-get? participants {player: tx-sender})))
        (begin
          ;; Transfer tokens to the contract
          (ft-transfer? TOKEN-ADDRESS STAKE-REQUIREMENT tx-sender (as-contract tx-sender))
          ;; Register participant
          (map-set participants {player: tx-sender} {staked: STAKE-REQUIREMENT, is-active: true})
          ;; Increment total participants
          (var-set total-participants (+ (var-get total-participants) u1))
          (ok "Joined game successfully"))
        (err "Unable to join game"))))

;; Function to close the game and select a winner
(define-public (close-game-and-award-winner (random-index uint))
  (begin
    ;; Check if game is full
    (asserts! (is-eq (var-get total-participants) PLAYER-LIMIT) 
               (err "Game not full - must have exactly 100 participants"))
    (asserts! (is-eq tx-sender CONTRACT-OWNER) 
               (err "Only owner can close the game"))

    ;; Validate random index
    (asserts! (and (>= random-index u0) 
                   (< random-index (var-get total-participants))) 
               (err "Invalid index"))

    ;; Calculate the total prize and fee
    (let ((total-prize (* PLAYER-LIMIT STAKE-REQUIREMENT))
          (platform-fee GAME-FEE)
          (winner-prize (- total-prize platform-fee)))

      ;; Select a winner directly from the map by tracking index
      ;; Get all participant keys as an array
      (let ((participant-keys (unwrap-panic 
                                 (map-get? participants {player: tx-sender}))))
        ;; Assuming `random-index` is valid and within the number of participants
        ;; Use element-at on participant keys to get winner's address
        (let ((winner 
               (unwrap-panic 
                (element-at random-index 
                            participant-keys))))
          ;; Transfer prize to winner and platform fee to the contract owner
          (ft-transfer? TOKEN-ADDRESS winner-prize 
                         (as-contract tx-sender) winner)
          (ft-transfer? TOKEN-ADDRESS platform-fee 
                         (as-contract tx-sender) CONTRACT-OWNER)

          ;; Reset game state
          (var-set total-participants u0)
          (map-delete participants)

          (ok "Winner awarded, game reset"))) )))