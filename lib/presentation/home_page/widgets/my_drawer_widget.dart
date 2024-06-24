import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/presentation/attachements/widgets/my_alert_dialog.dart';
import 'package:dsplus_finance/presentation/profile_screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/navigator_service.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../routes/app_routes.dart';
import '../../attachements/constants/colors.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext;
  final String imageUrl;
  final String name;
  const MyDrawer(
      {super.key,
      required this.parentContext,
      required this.imageUrl,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (c) {
            return DrawerHeader(
                decoration: BoxDecoration(
                  color: scheme.primary,
                  border: Border.all(color: scheme.primary),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name.substring(0, 1) : 'F',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // NavigatorService.pushNamed(
                        //   AppRoutes.userProfileScreen,
                        // );
                      },
                      child: Text(
                        name.isNotEmpty ? name : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ));
          }),
          // listTile(
          //   context,
          //   'Orders History',
          //   Icons.my_library_books_outlined,
          //   () {
          //     // Navigator.pushNamed(context, OrderHistoryScreen.routeName);
          //   },
          // ),
          // listTile(
          //   context,
          //   'Addresses',
          //   Icons.location_on_outlined,
          //   () {
          //     // Navigator.pushNamed(context, AddressScreen.routeName);
          //   },
          // ),
          listTile(
            context,
            'User Data',
            Icons.person,
            () {
              NavigatorService.pushNamed(
                AppRoutes.userProfileScreen,
              );
            },
          ),
          Container(
            height: 1,
            color: MyColors.borderColor,
          ),
          // listTile(
          //   context,
          //   'Settings',
          //   null,
          //   () {
          //     Navigator.pop(context);
          //   },
          // ),
          // listTile(
          //   context,
          //   'Terms & Conditions / Privacy',
          //   null,
          //   () {
          //     Navigator.pop(context);
          //   },
          // ),
          Builder(builder: (c) {
            return listTile(
              context,
              'Log out',
              Icons.logout_outlined,
              () {
                Scaffold.of(c).closeDrawer();
                showDialog(
                  context: c,
                  builder: (ctx) => MyAlertDialog(
                    title: 'Logging out?'.tr,
                    subtitle: 'Thanks for stopping by. See you again soon!'.tr,
                    action1Name: 'Cancel'.tr,
                    action2Name: 'Log out'.tr,
                    action1Func: () {
                      Navigator.pop(ctx);
                    },
                    action2Func: () async {
                      // IconButton(
                      //   onPressed: () {
                      logout(context);
                      //   },
                      //   icon: Icon(Icons.logout),
                      // ),
                      // await ap.userSignOut();

                      // Navigator.pushNamedAndRemoveUntil(ctx,
                      //     AuthenticationScreen.routeName, (route) => false);
                    },
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }

  ListTile listTile(
      BuildContext context, String text, IconData? icon, VoidCallback onTap) {
    return icon == null
        ? ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            onTap: onTap,
          )
        : ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            leading: Icon(
              icon,
              color: scheme.primary,
            ),
            onTap: onTap,
          );
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      PrefUtils().clearPreferencesData();
      NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.loginPageTabContainerScreen

          //  MaterialPageRoute(
          //    builder: (context) => loginPageTabContainerScreen(),
          //  ),
          );
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
}
