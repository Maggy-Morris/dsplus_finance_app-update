import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/core/utils/list_title.dart';
import 'package:dsplus_finance/core/utils/logout.dart';
import 'package:dsplus_finance/presentation/attachements/widgets/my_alert_dialog.dart';
import 'package:dsplus_finance/presentation/profile_screen/profile_screen.dart';
import 'package:dsplus_finance/widgets/app_colors.dart';
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
                  color: AppColors.logoColorlight,
                  border: Border.all(
                    color: AppColors.logoColorlight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius
                            .circular(75),
                        child: Image.network(
                          imageUrl.isNotEmpty ? imageUrl : '',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: ColorConstant
                                      .gray200,
                                  borderRadius:
                                  BorderRadiusStyle
                                      .roundedBorder7),
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
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      name.isNotEmpty ? name : '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ));
          }),

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
                      logout(context);

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
}
