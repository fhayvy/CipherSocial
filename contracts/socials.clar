;; CipherSocial: Decentralized Social Media Platform Smart Contract

;; Define the CipherSocial token
(define-fungible-token ciphersocial-token)

;; Define the contract owner (admin)
(define-constant contract-owner tx-sender)

;; Define the data structure for a user profile
(define-map user-profiles principal
    {
        username: (string-utf8 30),
        bio: (string-utf8 160),
        posts: (list 100 uint),
        followers: (list 1000 principal),
        following: (list 1000 principal),
        token-balance: uint,
        is-admin: bool
    })

;; Define the data structure for a post
(define-map posts uint 
    {
        author: principal,
        content: (string-utf8 280),
        timestamp: uint,
        likes: uint,
        comments: (list 100 uint),
        is-flagged: bool,
        flags-count: uint
    })

;; Counter for post IDs
(define-data-var post-id-counter uint u0)

;; Define the data structure for a comment
(define-map comments uint 
    {
        author: principal,
        post-id: uint,
        content: (string-utf8 280),
        timestamp: uint,
        is-flagged: bool,
        flags-count: uint
    })

;; Counter for comment IDs
(define-data-var comment-id-counter uint u0)

;; Function to create a new user profile
(define-public (create-profile (username (string-utf8 30)) (bio (string-utf8 160)))
    (let ((caller tx-sender))
        (asserts! (is-none (map-get? user-profiles caller)) (err u1)) ;; Profile already exists
        (asserts! (>= (len username) u1) (err u11)) ;; Username must not be empty
        (asserts! (>= (len bio) u0) (err u17)) ;; Bio can be empty, but must not be invalid
        (ok (map-set user-profiles caller {
            username: username,
            bio: bio,
            posts: (list),
            followers: (list),
            following: (list),
            token-balance: u0,
            is-admin: false
        }))
    )
)

;; Function to create a new post
(define-public (create-post (content (string-utf8 280)))
    (let (
        (caller tx-sender)
        (post-id (+ (var-get post-id-counter) u1))
    )
        (asserts! (>= (len content) u1) (err u12)) ;; Content must not be empty
        (var-set post-id-counter post-id)
        (ok (map-set posts post-id {
            author: caller,
            content: content,
            timestamp: block-height,
            likes: u0,
            comments: (list),
            is-flagged: false,
            flags-count: u0
        }))
    )
)

;; Function to like a post
(define-public (like-post (post-id uint))
    (match (map-get? posts post-id)
        post (ok (map-set posts post-id (merge post {likes: (+ (get likes post) u1)})))
        (err u13) ;; Post not found
    )
)

;; Function to follow a user
(define-public (follow-user (user-to-follow principal))
    (let (
        (caller tx-sender)
        (caller-profile (unwrap! (map-get? user-profiles caller) (err u3)))
        (follow-profile (unwrap! (map-get? user-profiles user-to-follow) (err u4)))
    )
        (asserts! (not (is-eq caller user-to-follow)) (err u14)) ;; Can't follow yourself
        (asserts! (< (len (get following caller-profile)) u1000) (err u5)) ;; Cannot follow more than 1000 users
        (let (
            (new-following (unwrap! (as-max-len? (append (get following caller-profile) user-to-follow) u1000) (err u6)))
            (new-followers (unwrap! (as-max-len? (append (get followers follow-profile) caller) u1000) (err u7)))
        )
            (map-set user-profiles caller (merge caller-profile {following: new-following}))
            (ok (map-set user-profiles user-to-follow (merge follow-profile {followers: new-followers})))
        )
    )
)

;; Function to get user profile
(define-read-only (get-profile (user principal))
    (map-get? user-profiles user)
)

;; Function to get post details
(define-read-only (get-post (post-id uint))
    (map-get? posts post-id)
)

;; Function to add a comment to a post
(define-public (add-comment (post-id uint) (content (string-utf8 280)))
    (let (
        (caller tx-sender)
        (comment-id (+ (var-get comment-id-counter) u1))
    )
        (asserts! (>= (len content) u1) (err u15)) ;; Content must not be empty
        (match (map-get? posts post-id)
            post (begin
                (var-set comment-id-counter comment-id)
                (map-set comments comment-id {
                    author: caller,
                    post-id: post-id,
                    content: content,
                    timestamp: block-height,
                    is-flagged: false,
                    flags-count: u0
                })
                (let ((new-comments (unwrap! (as-max-len? (append (get comments post) comment-id) u100) (err u9))))
                    (ok (map-set posts post-id (merge post {comments: new-comments})))
                )
            )
            (err u16) ;; Post not found
        )
    )
)

;; Function to get comment details
(define-read-only (get-comment (comment-id uint))
    (map-get? comments comment-id)
)

;; Function to get all comments for a specific post
(define-read-only (get-post-comments (post-id uint))
    (match (map-get? posts post-id)
        post (ok (map get-comment (get comments post)))
        (err u10)  ;; Post not found
    )
)

;; Function to flag a post
(define-public (flag-post (post-id uint))
    (let (
        (caller tx-sender)
    )
        (match (map-get? posts post-id)
            post (let (
                (new-flags-count (+ (get flags-count post) u1))
                (updated-post (merge post {
                    flags-count: new-flags-count,
                    is-flagged: (> new-flags-count u5)
                }))
            )
                (ok (map-set posts post-id updated-post))
            )
            (err u18) ;; Post not found
        )
    )
)

;; Function to flag a comment
(define-public (flag-comment (comment-id uint))
    (let (
        (caller tx-sender)
    )
        (match (map-get? comments comment-id)
            comment (let (
                (new-flags-count (+ (get flags-count comment) u1))
                (updated-comment (merge comment {
                    flags-count: new-flags-count,
                    is-flagged: (> new-flags-count u5)
                }))
            )
                (ok (map-set comments comment-id updated-comment))
            )
            (err u19) ;; Comment not found
        )
    )
)

;; Function to remove a flagged post (admin only)
(define-public (remove-flagged-post (post-id uint))
    (let (
        (caller tx-sender)
        (caller-profile (unwrap! (map-get? user-profiles caller) (err u20)))
    )
        (asserts! (get is-admin caller-profile) (err u21)) ;; Only admins can remove posts
        (match (map-get? posts post-id)
            post (begin
                (map-delete posts post-id)
                (ok true)
            )
            (err u22) ;; Post not found
        )
    )
)

;; Function to remove a flagged comment (admin only)
(define-public (remove-flagged-comment (comment-id uint))
    (let (
        (caller tx-sender)
        (caller-profile (unwrap! (map-get? user-profiles caller) (err u23)))
    )
        (asserts! (get is-admin caller-profile) (err u24)) ;; Only admins can remove comments
        (match (map-get? comments comment-id)
            comment (begin
                (map-delete comments comment-id)
                (ok true)
            )
            (err u25) ;; Comment not found
        )
    )
)

;; Function to add an admin (only contract owner can add admins)
(define-public (add-admin (user principal))
    (let (
        (caller tx-sender)
    )
        (asserts! (is-eq caller contract-owner) (err u26)) ;; Only contract owner can add admins
        (match (map-get? user-profiles user)
            profile (ok (map-set user-profiles user (merge profile {is-admin: true})))
            (err u27) ;; User not found
        )
    )
)

;; Function to remove an admin (only contract owner can remove admins)
(define-public (remove-admin (user principal))
    (let (
        (caller tx-sender)
    )
        (asserts! (is-eq caller contract-owner) (err u28)) ;; Only contract owner can remove admins
        (match (map-get? user-profiles user)
            profile (ok (map-set user-profiles user (merge profile {is-admin: false})))
            (err u29) ;; User not found
        )
    )
)

;; Function to check if a user is an admin
(define-read-only (is-admin (user principal))
    (match (map-get? user-profiles user)
        profile (get is-admin profile)
        false
    )
)