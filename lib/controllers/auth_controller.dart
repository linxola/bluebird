import 'package:appwrite/models.dart' as model;
import 'package:bluebird/apis/auth_api.dart';
import 'package:bluebird/apis/user_api.dart';
import 'package:bluebird/constants/appwrite_constants.dart';
import 'package:bluebird/core/utils.dart';
import 'package:bluebird/views/auth/login_view.dart';
import 'package:bluebird/views/auth/signup_view.dart';
import 'package:bluebird/views/home/home_view.dart';
import 'package:bluebird/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading

  Future<model.User?> currentUser() => _authAPI.currentUser();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic:
              '${AppwriteConstants.endPoint}/storage/buckets/${AppwriteConstants.imagesBucket}/files/649d5006977f73ed6385/view?project=${AppwriteConstants.projectId}&mode=admin',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isBlueCheck: false,
        );
        final resFinal = await _userAPI.saveUserData(userModel);
        resFinal.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Account created! Please login');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.logIn(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.push(context, HomeView.route());
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void logOut(BuildContext context) async {
    final res = await _authAPI.logOut();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
        (route) => false,
      );
    });
  }
}
