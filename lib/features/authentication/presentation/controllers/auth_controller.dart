import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

class AuthController extends GetxController {
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;

  var user = Rxn<User>();

  AuthController({
    required this.signInWithGoogle,
    required this.signOut,
  });

  Future<void> login() async {
    user.value = await signInWithGoogle();
  }

  Future<void> logout() async {
    await signOut();
    user.value = null;
  }
}
