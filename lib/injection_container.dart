import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'features/place/data/datasources/place_remote_datasource.dart';
import 'features/place/data/repositories/place_repository_impl.dart';
import 'features/place/domain/repositories/place_repository.dart';
import 'features/place/domain/usecases/get_nearby_places.dart';
import 'features/place/domain/usecases/manage_favorites.dart';
import 'features/place/presentation/controllers/place_controller.dart';
import 'features/authentication/data/datasources/auth_remote_datasource.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/sign_in_with_google.dart';
import 'features/authentication/domain/usecases/sign_out.dart';
import 'features/authentication/presentation/controllers/auth_controller.dart';

Future<void> init() async {
  // External
  Get.lazyPut(() => http.Client());

  // Place Feature
  Get.lazyPut<PlaceRemoteDataSource>(
      () => PlaceRemoteDataSourceImpl(client: Get.find()));
  Get.lazyPut<PlaceRepository>(() => PlaceRepositoryImpl(
        remoteDataSource: Get.find(),
        firestore: FirebaseFirestore.instance,
      ));
  Get.lazyPut(() => GetNearbyPlaces(Get.find()));
  Get.lazyPut(() => ManageFavorites(Get.find()));
  Get.lazyPut(() => PlaceController(
        getNearbyPlaces: Get.find(),
        manageFavorites: Get.find(),
      ));

  // Authentication Feature
  Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        googleSignIn: GoogleSignIn(),
      ));
  Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: Get.find()));
  Get.lazyPut(() => SignInWithGoogle(Get.find()));
  Get.lazyPut(() => SignOut(Get.find()));
  Get.lazyPut(() => AuthController(
        signInWithGoogle: Get.find(),
        signOut: Get.find(),
      ));
}
