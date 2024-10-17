# CipherSocial: Decentralized Social Media Platform

CipherSocial is a decentralized social media platform implemented using Clarity smart contracts on the Stacks blockchain. It aims to give users more control over their data and content, potentially reducing issues of censorship and data misuse.

## Features

- User profile creation and management
- Post creation and retrieval
- Comments on posts
- Like functionality for posts
- User following system (limited to 1000 follows per user)
- Decentralized data storage on the blockchain

## Smart Contract Functions

### User Management
1. `create-profile`: Create a new user profile
2. `get-profile`: Retrieve a user's profile information
3. `follow-user`: Follow another user (up to 1000 users)

### Post Management
4. `create-post`: Create a new post
5. `get-post`: Retrieve details of a specific post
6. `like-post`: Like an existing post

### Comment Management
7. `add-comment`: Add a comment to a post
8. `get-comment`: Retrieve details of a specific comment
9. `get-post-comments`: Get all comments for a specific post

## Security Features

- Input validation to ensure data integrity
- Error handling for various scenarios
- Prevention of self-following
- Limits on the number of follows and comments per post

## Getting Started

1. Install the [Clarinet](https://github.com/hirosystems/clarinet) development environment for Clarity smart contracts.
2. Clone this repository and navigate to the project directory.
3. Use Clarinet to test and deploy the smart contract.

## Usage

Interact with the smart contract using a Stacks wallet or build a frontend application that connects to the contract. Here are some example interactions:

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
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Here are some areas for potential improvements:

- Implement a reposting/sharing mechanism
- Add support for media attachments (e.g., image hashes)
- Create a user reputation or verification system
- Add privacy settings for user profiles and posts


## Author

Favour Chiamaka Eze

## Acknowledgments

- The Stacks community for their support and resources
- Clarinet developers for providing excellent tools for Clarity development