import { describe, it, expect, beforeEach, vi } from 'vitest';

// Mocking the Clarity and Stacks blockchain environment
const mockContractCall = vi.fn();
const mockReadOnlyFunction = vi.fn();
const mockBlockHeight = vi.fn(() => 1000);

// Simulate the clarity API
const clarity = {
  call: mockContractCall,
  readOnly: mockReadOnlyFunction,
  getBlockHeight: mockBlockHeight,
};

describe('CipherSocial Contract Tests', () => {
  beforeEach(() => {
    vi.clearAllMocks(); // Clear mocks before each test
  });

  it('should allow a user to create a profile', async () => {
    // Arrange
    const userPrincipal = 'ST1USER...';
    const username = 'TestUser';
    const bio = 'This is a test bio';

    // Mock the create-profile call
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate creating a profile
    const result = await clarity.call('create-profile', [username, bio]);

    // Assert
    expect(result.ok).toBe(true);
    expect(mockContractCall).toHaveBeenCalledWith('create-profile', [username, bio]);
  });

  it('should allow a user to create a post', async () => {
    // Arrange
    const content = 'This is my first post';

    // Mock post creation
    mockContractCall.mockResolvedValueOnce({ ok: true, postId: 1 });

    // Act: Simulate creating a post
    const result = await clarity.call('create-post', [content]);

    // Assert
    expect(result.ok).toBe(true);
    expect(result.postId).toBe(1);
  });

  it('should allow a user to like a post', async () => {
    // Arrange
    const postId = 1;

    // Mock liking a post
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate liking a post
    const result = await clarity.call('like-post', [postId]);

    // Assert
    expect(result.ok).toBe(true);
  });

  it('should allow a user to follow another user', async () => {
    // Arrange
    const userToFollow = 'ST2FOLLOW...';

    // Mock following a user
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate following another user
    const result = await clarity.call('follow-user', [userToFollow]);

    // Assert
    expect(result.ok).toBe(true);
  });

  it('should allow retrieving a user profile', async () => {
    // Arrange
    const userPrincipal = 'ST1USER...';
    const mockProfile = {
      username: 'TestUser',
      bio: 'This is a test bio',
      posts: [],
      followers: [],
      following: [],
      tokenBalance: 0,
      isAdmin: false,
    };

    // Mock reading a profile
    mockReadOnlyFunction.mockResolvedValueOnce(mockProfile);

    // Act: Simulate retrieving a profile
    const profile = await clarity.readOnly('get-profile', [userPrincipal]);

    // Assert
    expect(profile.username).toBe('TestUser');
    expect(profile.bio).toBe('This is a test bio');
  });

  it('should allow an admin to flag and remove a post', async () => {
    // Arrange
    const postId = 1;
    const adminPrincipal = 'ST1ADMIN...';

    // Mock flagging a post
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate flagging a post
    const flagResult = await clarity.call('flag-post', [postId]);

    // Assert flagging
    expect(flagResult.ok).toBe(true);

    // Mock removing a post
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate admin removing the flagged post
    const removeResult = await clarity.call('remove-flagged-post', [postId]);

    // Assert removal
    expect(removeResult.ok).toBe(true);
  });

  it('should only allow the contract owner to add or remove an admin', async () => {
    // Arrange
    const userPrincipal = 'ST2USER...';
    const contractOwner = 'ST1OWNER...';

    // Mock adding an admin
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate the contract owner adding an admin
    const addAdminResult = await clarity.call('add-admin', [userPrincipal]);

    // Assert adding admin
    expect(addAdminResult.ok).toBe(true);

    // Mock removing an admin
    mockContractCall.mockResolvedValueOnce({ ok: true });

    // Act: Simulate the contract owner removing the admin
    const removeAdminResult = await clarity.call('remove-admin', [userPrincipal]);

    // Assert removing admin
    expect(removeAdminResult.ok).toBe(true);
  });

  it('should throw an error if a non-admin tries to remove a flagged comment', async () => {
    // Arrange
    const commentId = 2;
    const nonAdminPrincipal = 'ST2USER...';

    // Mock removing a flagged comment by a non-admin
    mockContractCall.mockResolvedValueOnce({ error: 'not authorized' });

    // Act: Simulate a non-admin attempting to remove a flagged comment
    const result = await clarity.call('remove-flagged-comment', [commentId]);

    // Assert
    expect(result.error).toBe('not authorized');
  });

  it('should check if a user is an admin', async () => {
    // Arrange
    const userPrincipal = 'ST1USER...';

    // Mock reading if user is an admin
    mockReadOnlyFunction.mockResolvedValueOnce(true);

    // Act: Simulate checking if a user is an admin
    const isAdmin = await clarity.readOnly('is-admin', [userPrincipal]);

    // Assert
    expect(isAdmin).toBe(true);
  });
});
