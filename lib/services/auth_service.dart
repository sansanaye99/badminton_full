import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    // Auto-create player profile in Firestore
    await _db.collection('players').doc(credential.user!.uid).set({
      'id': credential.user!.uid,
      'name': name.trim(),
      'email': email.trim(),
      'ranking': 0,
      'wins': 0,
      'losses': 0,
      'photoUrl': '',
      'level': 'basic',
      'role': 'member',
    });
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
