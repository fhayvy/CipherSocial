;; CipherSocial: Decentralized Social Media Platform Smart Contract

;; Define the data structure for a user profile
(define-map user-profiles principal
    {
        username: (string-utf8 30),
        bio: (string-utf8 160),
        posts: (list 100 uint),
        followers: (list 1000 principal),
        following: (list 1000 principal)
    })

;; Define the data structure for a post
(define-map posts uint 
    {
        author: principal,
        content: (string-utf8 280),
        timestamp: uint,
        likes: uint,
        comments: (list 100 uint)  ;; This now stores comment IDs
    })

;; Counter for post IDs
(define-data-var post-id-counter uint u0)

;; New: Define the data structure for a comment
(define-map comments uint 
    {
        author: principal,
        post-id: uint,
        content: (string-utf8 280),
        timestamp: uint
    })

;; New: Counter for comment IDs
(define-data-var comment-id-counter uint u0)

;; Function to create a new user profile
(define-public (create-profile (username (string-utf8 30)) (bio (string-utf8 160)))
    (let ((caller tx-sender))
        (if (is-none (map-get? user-profiles caller))
            (begin
                (map-set user-profiles caller {
                    username: username,
                    bio: bio,
                    posts: (list),
                    followers: (list),
                    following: (list)
                })
                (ok true)
            )
            (err u1) ;; Profile already exists
        )
    )
)

;; Function to create a new post
(define-public (create-post (content (string-utf8 280)))
    (let (
        (caller tx-sender)
        (post-id (+ (var-get post-id-counter) u1))
    )
        (map-set posts post-id {
            author: caller,
            content: content,
            timestamp: block-height,
            likes: u0,
            comments: (list)
        })
        (var-set post-id-counter post-id)
        (ok post-id)
    )
)

;; Function to like a post
(define-public (like-post (post-id uint))
    (let ((post (unwrap! (map-get? posts post-id) (err u2))))
        (map-set posts post-id (merge post {likes: (+ (get likes post) u1)}))
        (ok true)
    )
)

;; Function to follow a user
(define-public (follow-user (user-to-follow principal))
    (let (
        (caller tx-sender)
        (caller-profile (unwrap! (map-get? user-profiles caller) (err u3)))
        (follow-profile (unwrap! (map-get? user-profiles user-to-follow) (err u4)))
    )
        (if (< (len (get following caller-profile)) u1000)
            (let (
                (new-following (unwrap! (as-max-len? (append (get following caller-profile) user-to-follow) u1000) (err u6)))
                (new-followers (unwrap! (as-max-len? (append (get followers follow-profile) caller) u1000) (err u7)))
            )
                (map-set user-profiles caller (merge caller-profile {following: new-following}))
                (map-set user-profiles user-to-follow (merge follow-profile {followers: new-followers}))
                (ok true)
            )
            (err u5) ;; Cannot follow more than 1000 users
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

;; New: Function to add a comment to a post
(define-public (add-comment (post-id uint) (content (string-utf8 280)))
    (let (
        (caller tx-sender)
        (comment-id (+ (var-get comment-id-counter) u1))
        (post (unwrap! (map-get? posts post-id) (err u8)))
    )
        (map-set comments comment-id {
            author: caller,
            post-id: post-id,
            content: content,
            timestamp: block-height
        })
        (var-set comment-id-counter comment-id)
        (map-set posts post-id (merge post {
            comments: (unwrap! (as-max-len? (append (get comments post) comment-id) u100) (err u9))
        }))
        (ok comment-id)
    )
)

;; New: Function to get comment details
(define-read-only (get-comment (comment-id uint))
    (map-get? comments comment-id)
)

;; Corrected: Function to get all comments for a specific post
(define-read-only (get-post-comments (post-id uint))
    (match (map-get? posts post-id)
        post (ok (map get-comment (get comments post)))
        (err u10)  ;; Post not found
    )
)