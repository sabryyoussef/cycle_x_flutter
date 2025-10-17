import 'package:firebase_auth/firebase_auth.dart' show User;
import './models/user.dart';

abstract class UserRepository {
  Stream<MyUser> get user;
  User? get currentUser; // Add currentUser to the interface
  Future<void> updateUser(MyUser user);

  Future<MyUser> signUp({required MyUser myuser, required String password});

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<void> setUserData(MyUser user);

  Future<void> signOut();
}
