# CipherSocial

CipherSocial is a decentralized social media platform implemented as a smart contract. It provides core social networking features while maintaining transparency and user control through blockchain technology.

## Features

- **User Profiles**
  - Create and manage user profiles with customizable usernames and bios
  - Follow/unfollow functionality
  - Token balance tracking
  - Admin role support

- **Content Management**
  - Create and view posts (up to 280 characters)
  - Comment on posts
  - Like posts
  - Content moderation through flagging system

- **Moderation System**
  - Community-driven content flagging
  - Automated content flagging threshold (>5 flags)
  - Admin-controlled content removal
  - Hierarchical admin management

## Smart Contract Functions

### User Management

```clarity
create-profile (username: string-utf8, bio: string-utf8) → response
follow-user (user-to-follow: principal) → response
get-profile (user: principal) → response
```

### Content Management

```clarity
create-post (content: string-utf8) → response
like-post (post-id: uint) → response
add-comment (post-id: uint, content: string-utf8) → response
get-post (post-id: uint) → response
get-comment (comment-id: uint) → response
get-post-comments (post-id: uint) → response
```

### Moderation

```clarity
flag-post (post-id: uint) → response
flag-comment (comment-id: uint) → response
remove-flagged-post (post-id: uint) → response
remove-flagged-comment (comment-id: uint) → response
```

### Administration

```clarity
add-admin (user: principal) → response
remove-admin (user: principal) → response
is-admin (user: principal) → response
```

## Technical Specifications

- **Post Limitations**
  - Maximum content length: 280 characters
  - Maximum comments per post: 100
  - Automatic flagging at 5+ flags

- **Profile Limitations**
  - Username max length: 30 characters
  - Bio max length: 160 characters
  - Maximum following/followers: 1000 users

## Error Codes

| Code | Description |
|------|-------------|
| u1   | Profile already exists |
| u11  | Username must not be empty |
| u12  | Content must not be empty |
| u13  | Post not found |
| u14  | Can't follow yourself |
| u15  | Comment content must not be empty |
| u16  | Post not found for comment |
| u20-29 | Various admin and moderation errors |

## Security Features

- Contract owner controls admin appointments
- Only admins can remove flagged content
- Built-in protection against self-following
- Automated content flagging system
- User limits to prevent spam and abuse

## Token System

The platform includes a native fungible token (`ciphersocial-token`) that can be used for future platform features and governance.

## Getting Started

To interact with the CipherSocial platform:

1. Deploy the smart contract to your chosen Stacks network
2. Create a user profile using `create-profile`
3. Start engaging with content through posts, comments, and likes
4. Follow other users to build your network

## Administration

The contract includes a robust administration system:
- The contract owner is set during deployment
- Only the contract owner can appoint/remove admins
- Admins have special privileges for content moderation
- Admin status can be verified using the `is-admin` function

## Future Considerations

Potential areas for expansion:
- Token utility implementation
- Advanced content moderation features
- Enhanced profile customization
- Direct messaging system
- Content encryption features

## Contributing

The smart contract is open for review and improvement suggestions. Please ensure any proposed changes maintain the security and efficiency of the platform.
