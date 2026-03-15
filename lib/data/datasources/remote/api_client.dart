import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/sync_change.dart';

/// Keys for secure storage.
const _kAccessToken = 'access_token';
const _kRefreshToken = 'refresh_token';
const _kUserEmail = 'user_email';

/// Keys for shared preferences.
const _kServerUrl = 'server_url';
const _kSyncVersion = 'sync_version';

/// HTTP client for the Toutim sync server.
class ApiClient {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  late http.Client _httpClient;

  ApiClient({
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
  })  : _prefs = prefs,
        _secureStorage = secureStorage {
    // Trust self-signed certs for dev (localhost).
    final ioClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    _httpClient = IOClient(ioClient);
  }

  // ── Configuration ─────────────────────────────────────────

  static const defaultServerUrl = 'https://api.toutim.app';

  String get serverUrl =>
      _prefs.getString(_kServerUrl) ?? defaultServerUrl;

  Future<void> setServerUrl(String url) async {
    // Normalize: remove trailing slash.
    final normalized = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    await _prefs.setString(_kServerUrl, normalized);
  }

  int get syncVersion => _prefs.getInt(_kSyncVersion) ?? 0;

  Future<void> setSyncVersion(int version) async {
    await _prefs.setInt(_kSyncVersion, version);
  }

  bool get isConfigured => serverUrl.isNotEmpty;

  Future<bool> get isAuthenticated async {
    final token = await _secureStorage.read(key: _kAccessToken);
    return token != null && token.isNotEmpty;
  }

  Future<String?> get userEmail async {
    return _secureStorage.read(key: _kUserEmail);
  }

  // ── Health check ──────────────────────────────────────────

  /// Test server connectivity. Returns true if /health responds OK.
  Future<bool> testConnection() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('$serverUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── Auth ──────────────────────────────────────────────────

  Future<void> register(String email, String password) async {
    final response = await _post('/api/auth/register', {
      'email': email,
      'password': password,
    });
    await _handleAuthResponse(response, email);
  }

  Future<void> login(String email, String password) async {
    final response = await _post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    await _handleAuthResponse(response, email);
  }

  Future<void> logout() async {
    final refreshToken = await _secureStorage.read(key: _kRefreshToken);
    if (refreshToken != null) {
      try {
        await _post('/api/auth/logout', {'refresh_token': refreshToken});
      } catch (_) {
        // Best-effort logout on server.
      }
    }
    await _clearTokens();
  }

  Future<void> deleteAccount() async {
    final refreshToken = await _secureStorage.read(key: _kRefreshToken);
    await _authRequest('DELETE', '/api/auth/account',
        body: {'refresh_token': refreshToken ?? ''});
    await _clearTokens();
    await _prefs.remove(_kSyncVersion);
  }

  Future<void> forgotPassword(String email) async {
    await _post('/api/auth/forgot-password', {'email': email});
  }

  // ── Sync ──────────────────────────────────────────────────

  Future<PushResponse> pushChanges(
      List<SyncChange> changes, int lastVersion) async {
    final response = await _authRequest('POST', '/api/sync/push', body: {
      'changes': changes.map((c) => c.toJson()).toList(),
      'last_version': lastVersion,
    });
    return PushResponse.fromJson(jsonDecode(response.body));
  }

  Future<PullResponse> pullChanges(int sinceVersion) async {
    final response = await _authRequest('POST', '/api/sync/pull', body: {
      'since_version': sinceVersion,
    });
    return PullResponse.fromJson(jsonDecode(response.body));
  }

  Future<SyncStatusResponse> syncStatus() async {
    final response = await _authRequest('GET', '/api/sync/status');
    return SyncStatusResponse.fromJson(jsonDecode(response.body));
  }

  // ── Internal helpers ──────────────────────────────────────

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('$serverUrl$path');
    final response = await _httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      final msg = _extractError(response);
      throw ApiException(response.statusCode, msg);
    }
    return response;
  }

  /// Make an authenticated request. Auto-refreshes token on 401.
  Future<http.Response> _authRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    var response = await _rawAuthRequest(method, path, body: body);

    // Token expired — try refresh.
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        response = await _rawAuthRequest(method, path, body: body);
      } else {
        await _clearTokens();
        throw ApiException(401, 'Session expirée, veuillez vous reconnecter');
      }
    }

    if (response.statusCode >= 400) {
      final msg = _extractError(response);
      throw ApiException(response.statusCode, msg);
    }
    return response;
  }

  Future<http.Response> _rawAuthRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$serverUrl$path');
    final accessToken = await _secureStorage.read(key: _kAccessToken);
    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    switch (method) {
      case 'GET':
        return _httpClient.get(url, headers: headers);
      case 'POST':
        return _httpClient.post(url,
            headers: headers, body: body != null ? jsonEncode(body) : null);
      case 'DELETE':
        return _httpClient.delete(url,
            headers: headers, body: body != null ? jsonEncode(body) : null);
      default:
        throw ArgumentError('Unsupported method: $method');
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: _kRefreshToken);
    if (refreshToken == null) return false;

    try {
      final response = await _post('/api/auth/refresh', {
        'refresh_token': refreshToken,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      await _secureStorage.write(
          key: _kAccessToken, value: data['access_token'] as String);
      await _secureStorage.write(
          key: _kRefreshToken, value: data['refresh_token'] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleAuthResponse(
      http.Response response, String email) async {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    await _secureStorage.write(
        key: _kAccessToken, value: data['access_token'] as String);
    await _secureStorage.write(
        key: _kRefreshToken, value: data['refresh_token'] as String);
    await _secureStorage.write(key: _kUserEmail, value: email);
    // Reset sync cursor so first sync pulls all data from the new account.
    await _prefs.remove(_kSyncVersion);
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _kAccessToken);
    await _secureStorage.delete(key: _kRefreshToken);
    await _secureStorage.delete(key: _kUserEmail);
  }

  String _extractError(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['error'] as String? ?? 'Erreur inconnue';
    } catch (_) {
      return 'Erreur ${response.statusCode}';
    }
  }

  // ── File upload/download ───────────────────────────────

  /// Upload a local image file and return the server file_id.
  Future<String> uploadFile(File file) async {
    return _doUpload(file, retried: false);
  }

  Future<String> _doUpload(File file, {required bool retried}) async {
    final accessToken = await _secureStorage.read(key: _kAccessToken);
    final uri = Uri.parse('$serverUrl/api/files/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${accessToken ?? ""}'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await _httpClient.send(request);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 401 && !retried) {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        await _clearTokens();
        throw const ApiException(401, 'Session expirée, veuillez vous reconnecter');
      }
      return _doUpload(file, retried: true);
    }
    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, _extractError(response));
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['file_id'] as String;
  }

  /// Download a server file by its file_id.
  /// Returns raw bytes and the content-type header value.
  Future<(Uint8List, String)> downloadFile(String fileId) async {
    final response = await _authRequest('GET', '/api/files/$fileId');
    final contentType = response.headers['content-type'] ?? 'image/jpeg';
    return (response.bodyBytes, contentType);
  }
}

/// Exception thrown by the API client.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
