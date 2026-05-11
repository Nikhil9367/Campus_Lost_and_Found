// lib/providers/auth_provider.dart
// Mock authentication backed by shared_preferences.
// Stores a list of registered users and the currently signed-in user.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String name;
  final String email;
  final String phone;
  final String password; // NOTE: plain text — mock only.

  AppUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() =>
      {'name': name, 'email': email, 'phone': phone, 'password': password};

  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
        name: m['name'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String? ?? '',
        password: m['password'] as String,
      );
}

class AuthProvider extends ChangeNotifier {
  static const _kUsersKey = 'cr_users';
  static const _kCurrentKey = 'cr_current_email';

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Called once at app start to restore session.
  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kCurrentKey);
    if (email == null) return;
    final users = await _readUsers(prefs);
    _currentUser = users.firstWhere(
      (u) => u.email == email,
      orElse: () => AppUser(name: '', email: '', phone: '', password: ''),
    );
    if (_currentUser!.email.isEmpty) _currentUser = null;
    notifyListeners();
  }

  Future<List<AppUser>> _readUsers(SharedPreferences prefs) async {
    final raw = prefs.getStringList(_kUsersKey) ?? [];
    return raw
        .map((s) => AppUser.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeUsers(
      SharedPreferences prefs, List<AppUser> users) async {
    await prefs.setStringList(
      _kUsersKey,
      users.map((u) => jsonEncode(u.toMap())).toList(),
    );
  }

  /// Register a new account. Returns null on success, or an error string.
  Future<String?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _readUsers(prefs);
    if (users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return 'An account with this email already exists.';
    }
    final user = AppUser(
        name: name, email: email, phone: phone, password: password);
    users.add(user);
    await _writeUsers(prefs, users);
    await prefs.setString(_kCurrentKey, email);
    _currentUser = user;
    notifyListeners();
    return null;
  }

  /// Sign in. Returns null on success, or an error string.
  Future<String?> signIn(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _readUsers(prefs);
    final match = users.where(
      (u) =>
          u.email.toLowerCase() == email.toLowerCase() &&
          u.password == password,
    );
    if (match.isEmpty) return 'Invalid email or password.';
    _currentUser = match.first;
    await prefs.setString(_kCurrentKey, _currentUser!.email);
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCurrentKey);
    _currentUser = null;
    notifyListeners();
  }
}
