import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

class AuthController extends GetxController {
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;

  var errorMessage = ''.obs;

  var user = Rxn<User>();

  AuthController({
    required this.signInWithGoogle,
    required this.signOut,
  });

  Future<void> login() async {
    try {
      user.value = await signInWithGoogle();
    } catch (e) {
      // switch (e) {
      //   case 'user-not-found':
      //     print('No user found for that email.');
      //     break;
      //   case 'wrong-password':
      //     print('Wrong password provided.');
      //     break;
      //   case 'account-exists-with-different-credential':
      //     print('Account exists with different credentials.');
      //     break;
      //   default:
      //     print('Unknown error occurred: ${e.message}');
      // }
      errorMessage("Something went wrong");
    }
  }

  Future<void> logout() async {
    try {
      await signOut();
      user.value = null;
    } catch (e) {
      errorMessage("Something went wrong");
    }
  }
}
