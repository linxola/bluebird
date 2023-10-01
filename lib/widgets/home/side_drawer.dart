import 'package:bluebird/common/loading_page.dart';
import 'package:bluebird/controllers/auth_controller.dart';
import 'package:bluebird/controllers/users_controller.dart';
import 'package:bluebird/theme/palette.dart';
import 'package:bluebird/views/users/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Palette.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(currentUser),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                size: 30,
              ),
              title: const Text(
                'Blue Check',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                      userModel: currentUser.copyWith(isBlueCheck: true),
                      context: context,
                      bannerFile: null,
                      profileFile: null,
                    );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
