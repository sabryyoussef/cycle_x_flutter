import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import './models/models.dart';
import './user_repo.dart';

/// Mock user repository for unsupported platforms (Linux, Windows desktop)
/// This allows the app to run without Firebase for testing UI/UX
class MockUserRepo extends ChangeNotifier implements UserRepository {
  MockUserRepo();

  // Simulate a logged-in user for demo purposes
  MyUser _currentUser = MyUser.empty;
  bool _isLoggedIn = false;

  @override
  User? get currentUser => _isLoggedIn ? _createMockFirebaseUser() : null;

  // Create a mock Firebase User for compatibility
  User? _createMockFirebaseUser() {
    // This is a simplified mock - in a real scenario you'd need to create a proper mock
    return null; // We'll handle this differently
  }

  @override
  Future<void> setUserData(MyUser myuser) async {
    if (kDebugMode) {
      print('MockUserRepo: setUserData called');
    }
    _currentUser = myuser;
    notifyListeners();
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('MockUserRepo: signInWithEmailAndPassword called for $email');
    }

    // Simulate successful login
    _currentUser = MyUser(
      email: email,
      uid: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@')[0], // Use email prefix as name
      hasActiveCart: false,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  @override
  Future<MyUser> signUp({
    required MyUser myuser,
    required String password,
  }) async {
    if (kDebugMode) {
      print('MockUserRepo: signUp called for ${myuser.email}');
    }

    // Simulate successful registration
    final newUser = MyUser(
      email: myuser.email,
      uid: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
      name: myuser.name,
      hasActiveCart: false,
    );
    _currentUser = newUser;
    _isLoggedIn = true;
    notifyListeners();
    return newUser;
  }

  @override
  Future<void> updateUser(MyUser user) async {
    if (kDebugMode) {
      print('MockUserRepo: updateUser called');
    }
    _currentUser = user;
    notifyListeners();
  }

  @override
  Stream<MyUser> get user {
    // Return a stream that emits the current user state
    return Stream.value(_currentUser);
  }

  @override
  Future<void> signOut() async {
    if (kDebugMode) {
      print('MockUserRepo: signOut called');
    }
    _currentUser = MyUser.empty;
    _isLoggedIn = false;
    notifyListeners();
  }
}
