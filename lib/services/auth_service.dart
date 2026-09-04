import 'package:firebase_auth/firebase_auth.dart';
import 'package:floradex/exceptions/auth_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Unknown Error');
    }
  }

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Unknown Error');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleAuth.signIn();

      if (googleUser == null) {
        throw AuthException('cancelled', 'Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Unknown Error');
    }
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleAuth.signOut()]);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? "Unkown Error");
    }
  }
}
