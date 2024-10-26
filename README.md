# CipherSocial: Decentralized Social Media Platform

CipherSocial is a decentralized social media platform implemented with Clarity smart contracts on the Stacks blockchain. CipherSocial aims to provide users with more control over their data and content, while promoting decentralized, censorship-resistant communication.

## Features

- **User Profile Management:** Create and manage user profiles with bio and follower-following relationships.
- **Content Creation and Interactions:** Users can create posts, comment on them, and like posts.
- **Follower System:** Follow up to 1000 users, track followers and following.
- **Decentralized Data Storage:** Stores data on the Stacks blockchain to ensure transparency and data integrity.
  
## Smart Contract Functions

### User Management
- `create-profile`: Allows users to create their profiles with a unique username and bio.
- `get-profile`: Retrieve profile information for any user.
- `follow-user`: Follow another user, with a limit of 1000 followings per user.

### Post Management
- `create-post`: Create a new post up to 280 characters.
- `get-post`: Retrieve details of a specific post.
- `like-post`: Like a post, incrementing its like count.

### Comment Management
- `add-comment`: Add a comment to a post, attaching it to the post's comment list.
- `get-comment`: Retrieve details of a specific comment.
- `get-post-comments`: Retrieve all comments associated with a specific post.

### Moderation and Flagging
- **Post and Comment Flagging:** Flag posts or comments for moderation. If flagged above a certain threshold, they are automatically marked as flagged.
- **Admin Controls:** Admins can remove flagged posts and comments. Only the contract owner can assign or remove admin status from other users.

## Security and Data Integrity

- **Data Validation:** Ensures inputs meet character limits and follow expected formats.
- **Error Handling:** Provides specific error codes for common issues, such as unauthorized actions or exceeding limits.
- **Follower Validation:** Prevents users from following themselves, and limits each user to following up to 1000 users.
- **Comment Limits:** Limits comments per post to avoid spam.

## Getting Started

1. **Install Dependencies:** Ensure [Clarinet](https://github.com/hirosystems/clarinet) is installed for Clarity contract development.
2. **Clone and Navigate:** Clone this repository and enter the project directory.
3. **Testing and Deployment:** Use Clarinet to test and deploy the contract on the Stacks blockchain.

## Example Usage

```clarity
;; Create a profile
(contract-call? .ciphersocial create-profile "alice" "Blockchain enthusiast")

;; Create a post
(contract-call? .ciphersocial create-post "Hello, decentralized world!")

;; Add a comment to a post
(contract-call? .ciphersocial add-comment u1 "Great first post!")

;; Like a post
(contract-call? .ciphersocial like-post u1)

;; Follow a user
(contract-call? .ciphersocial follow-user 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
