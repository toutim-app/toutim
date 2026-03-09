import '../models/sync_change.dart';

/// Abstract repository for sync operations.
abstract class SyncRepository {
  /// Whether the server URL is configured.
  bool get isConfigured;

  /// Whether the user is authenticated.
  Future<bool> get isAuthenticated;

  /// Get the current server URL.
  String get serverUrl;

  /// Get the authenticated user's email.
  Future<String?> get userEmail;

  /// Set the server URL.
  Future<void> setServerUrl(String url);

  /// Test server connectivity.
  Future<bool> testConnection();

  /// Register a new account.
  Future<void> register(String email, String password);

  /// Login to an existing account.
  Future<void> login(String email, String password);

  /// Logout from the current account.
  Future<void> logout();

  /// Delete the current account.
  Future<void> deleteAccount();

  /// Run a full sync cycle (push local changes, then pull remote changes).
  Future<SyncResult> sync();
}
