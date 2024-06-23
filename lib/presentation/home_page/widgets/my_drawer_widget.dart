import 'package:dsplus_finance/presentation/attachements/widgets/my_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/utils/navigator_service.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../routes/app_routes.dart';
import '../../attachements/constants/colors.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const MyDrawer({super.key, required this.parentContext});

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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fill,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "",
                          // ap.name!.isNotEmpty ? ap.name!.substring(0, 1) : 'F',
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
                        // Navigator.pushNamed(
                        //     context, RegisterShopScreen.routeName);
                      },
                      child: Text(
                        // ap.name!.isNotEmpty ? ap.name! :
                        '',
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
              Navigator.pop(context);
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
                    title: 'Logging out?',
                    subtitle: 'Thanks for stopping by. See you again soon!',
                    action1Name: 'Cancel',
                    action2Name: 'Log out',
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
      print('Error signing out: $e');
    }
  }
}
