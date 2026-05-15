import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';

abstract class FirebaseAuthDataSource {
  Future<User?> login(String email, String password);
  Future<User?> register(User user);
  Future<void> logout();
  Future<User?> getCurrentUser();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth auth;

  FirebaseAuthDataSourceImpl(this.auth);

  @override
  Future<User?> login(String email, String password) async {
    firebase_auth.UserCredential userCredential =
        await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String token = await userCredential.user?.getIdToken() ?? '';

    return UserModel.fromFirebaseUser(userCredential.user!, token).toEntity();
  }

  @override
  Future<User?> register(User user) async {
    firebase_auth.UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );

    String token = await userCredential.user?.getIdToken() ?? '';

    await userCredential.user?.updateDisplayName(user.name);
    await userCredential.user?.updatePhotoURL(user.photoUrl);

    return UserModel.fromFirebaseUser(userCredential.user!, token).toEntity();
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    firebase_auth.User? user = auth.currentUser;
    if (user != null) {
      String token = await user.getIdToken() ?? '';
      return UserModel.fromFirebaseUser(user, token).toEntity();
    } else {
      return null;
    }
  }
}
