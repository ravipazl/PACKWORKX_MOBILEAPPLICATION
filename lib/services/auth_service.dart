class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _currentUser;
  bool _isLoggedIn = false;

  // Getter for current user
  String? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // Login method
  Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation (in real app, this would be API call)
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = email;
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  // Logout method
  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
  }

  // Register method (placeholder)
  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simple validation
    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      _currentUser = email;
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  // Reset password method (placeholder)
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation
    if (email.isNotEmpty && email.contains('@')) {
      return true;
    }
    return false;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _isLoggedIn && _currentUser != null;
  }

  // Get user profile (placeholder)
  Map<String, dynamic> getUserProfile() {
    if (!isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    return {
      'email': _currentUser,
      'name': 'User Name',
      'role': 'Admin',
      'company': 'Packworks',
      'joinDate': '2024-01-01',
    };
  }
}
