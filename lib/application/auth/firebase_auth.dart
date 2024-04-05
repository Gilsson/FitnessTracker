import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_sync/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  late FirebaseApp? firebaseApp;

  FirebaseAuthentication() {
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    if (firebaseApp != null) {
      return;
    }
    firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return;
  }

  Future<UserCredential?> signUp(
      {required String mail, required String password}) async {
    try {
      Future<UserCredential> user = FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserCredential?> signIn(
      {required String mail, required String password}) async {
    try {
      Future<UserCredential> user = FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
