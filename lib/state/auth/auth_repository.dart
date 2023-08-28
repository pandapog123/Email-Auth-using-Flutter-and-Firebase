import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required this.auth,
  });

  final FirebaseAuth auth;

  Stream<User?> get user {
    return auth.authStateChanges();
  }

  signOutAsync() async {
    await auth.signOut();
  }

  logInWithEmail(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  signUpWithEmail(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}
