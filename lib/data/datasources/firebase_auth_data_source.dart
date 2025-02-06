import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:devpaul_todo_app/data/models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> register(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth auth;

  FirebaseAuthDataSourceImpl(this.auth);

  @override
  Future<UserModel?> login(String email, String password) async {
    firebase_auth.UserCredential userCredential =
        await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String token = await userCredential.user?.getIdToken() ?? '';

    return UserModel.fromFirebaseUser(userCredential.user!, token);
  }

  @override
  Future<UserModel?> register(String email, String password) async {
    firebase_auth.UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String token = await userCredential.user?.getIdToken() ?? '';

    return UserModel.fromFirebaseUser(userCredential.user!, token);
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    firebase_auth.User? user = auth.currentUser;
    if (user != null) {
      String token = await user.getIdToken() ?? '';
      return UserModel.fromFirebaseUser(user, token);
    } else {
      return null;
    }
  }
}
