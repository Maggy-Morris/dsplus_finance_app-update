import 'package:dsplus_finance/presentation/home_page/bloc/home_bloc.dart';

import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:dsplus_finance/widgets/app_colors.dart';
import 'package:dsplus_finance/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ask_for_cash_screen/ask_for_cash_screen.dart';
import '../attachements/constants/colors.dart';
import '../attachements/widgets/my_alert_dialog.dart';

class UserProfileScreen extends StatelessWidget {
  static Widget builder(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => HomeBloc()..add(GetUserData()),
        child: UserProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return SafeArea(
          child: Scaffold(
              backgroundColor: ColorConstant.whiteA700,
              appBar: CustomAppBar(
                height: getVerticalSize(49),
                leadingWidth: 59,
                leading: AppbarIconbutton(
                    svgPath: ImageConstant.imgArrowleftBlack900,
                    margin: getMargin(left: 24, top: 7, bottom: 7),
                    onTap: () {
                      onTapArrowleft9(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "lbl_profile".tr),
                // actions: [
                //   AppbarIconbutton(
                //       svgPath: ImageConstant.imgSettings,
                //       margin:
                //           getMargin(left: 25, top: 7, right: 25, bottom: 8))
                // ]
              ),
              body: state.loading == true
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Stack(
                        children: [
                          CustomPaint(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                            painter: HeaderCurvedContainer(),
                          ),
                          Container(
                              width: double.maxFinite,
                              padding: getPadding(
                                  left: 24, top: 60, right: 24, bottom: 25),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("${state.userModel?.name}".tr,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400)),
                                          // Padding(
                                          //     padding: getPadding(top: 1),
                                          //     child: Text(
                                          //         "${state.userModel?.jobTitle}".tr,
                                          //         overflow: TextOverflow.ellipsis,
                                          //         textAlign: TextAlign.left,
                                          //         style: AppStyle
                                          //             .txtPoppinsMedium10Gray500))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: getPadding(
                                          left: 0, right: 0, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreenImage(
                                                          imageUrl:
                                                              "${state.userModel?.image}"),
                                                ),
                                              );
                                            },
                                            child: Container(
                                                height: getSize(150),
                                                width: getSize(150),
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        width: 150,
                                                        height: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                state.userModel
                                                                        ?.image ??
                                                                    ""),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "",
                                                            // name.isNotEmpty ? name.substring(0, 1) : 'F',
                                                            style: TextStyle(
                                                              color: scheme
                                                                  .primary,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                              height:
                                                                  getSize(150),
                                                              width:
                                                                  getSize(150),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: 1,
                                                              )))
                                                    ])),
                                          ),

                                          // CustomImageView(
                                          //     svgPath: ImageConstant.imgPlay30x30,
                                          //     height: getSize(30),
                                          //     width: getSize(30),
                                          //     margin: getMargin(
                                          //         left: 26, top: 25, bottom: 25))
                                        ],
                                      ),
                                    ),

                                    // SizedBox(
                                    //   height: 20,
                                    // ),

                                    Text(
                                      "Name:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 40),
                                      child: Text("${state.userModel?.name}"),
                                    ),
                                    Divider(),
                                    Text(
                                      "Job Title:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 40),
                                      child:
                                          Text("${state.userModel?.jobTitle}"),
                                    ),
                                    Divider(),

                                    Text(
                                      "Role:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 40),
                                      child: Text("${state.userModel?.role}"),
                                    ),
                                    Divider(),

                                    Text(
                                      "Email:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 40),
                                      child: Text("${state.userModel?.email}"),
                                    ),

                                    // Padding(
                                    //     padding: getPadding(top: 20, right: 1),
                                    //     child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           CustomImageView(
                                    //               svgPath: ImageConstant.imgIcon,
                                    //               height: getSize(40),
                                    //               width: getSize(40)),
                                    //           Padding(
                                    //               padding: getPadding(
                                    //                   left: 16, top: 7, bottom: 8),
                                    //               child: Text("lbl_personal_info".tr,
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   textAlign: TextAlign.left,
                                    //                   style: AppStyle
                                    //                       .txtPoppinsMedium16Black900)),
                                    //           Spacer(),
                                    //           CustomImageView(
                                    //               svgPath:
                                    //                   ImageConstant.imgArrowdownBlack900,
                                    //               height: getVerticalSize(8),
                                    //               width: getHorizontalSize(4),
                                    //               margin: getMargin(top: 16, bottom: 16))
                                    //         ])),
                                    // Padding(
                                    //     padding: getPadding(top: 20),
                                    //     child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           CustomImageView(
                                    //               svgPath: ImageConstant.imgUser40x40,
                                    //               height: getSize(40),
                                    //               width: getSize(40)),
                                    //           Padding(
                                    //               padding: getPadding(
                                    //                   left: 16, top: 7, bottom: 8),
                                    //               child: Text("lbl_notification".tr,
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   textAlign: TextAlign.left,
                                    //                   style: AppStyle
                                    //                       .txtPoppinsMedium16Black900)),
                                    //           Spacer(),
                                    //           Container(
                                    //               margin: getMargin(top: 13, bottom: 13),
                                    //               padding: getPadding(all: 4),
                                    //               decoration: AppDecoration.fillIndigoA100
                                    //                   .copyWith(
                                    //                       borderRadius: BorderRadiusStyle
                                    //                           .roundedBorder7),
                                    //               child: Column(
                                    //                   mainAxisSize: MainAxisSize.min,
                                    //                   crossAxisAlignment:
                                    //                       CrossAxisAlignment.end,
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment.start,
                                    //                   children: [
                                    //                     Container(
                                    //                         height: getSize(6),
                                    //                         width: getSize(6),
                                    //                         decoration: BoxDecoration(
                                    //                             color:
                                    //                                 ColorConstant.whiteA700,
                                    //                             borderRadius:
                                    //                                 BorderRadius.circular(
                                    //                                     getHorizontalSize(
                                    //                                         3))))
                                    //                   ]))

                                    //         ])),
                                    // Padding(
                                    //     padding: getPadding(top: 20, right: 1),
                                    //     child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           CustomImageView(
                                    //               svgPath: ImageConstant.imgCheckmark40x40,
                                    //               height: getSize(40),
                                    //               width: getSize(40)),
                                    //           Padding(
                                    //               padding: getPadding(
                                    //                   left: 16, top: 10, bottom: 5),
                                    //               child: Text("lbl_billing_details".tr,
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   textAlign: TextAlign.left,
                                    //                   style: AppStyle
                                    //                       .txtPoppinsMedium16Black900)),
                                    //           Spacer(),
                                    //           CustomImageView(
                                    //               svgPath:
                                    //                   ImageConstant.imgArrowdownBlack900,
                                    //               height: getVerticalSize(8),
                                    //               width: getHorizontalSize(4),
                                    //               margin: getMargin(top: 16, bottom: 16))
                                    //         ])),
                                    // Padding(
                                    //     padding: getPadding(top: 20, right: 1),
                                    //     child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           CustomImageView(
                                    //               svgPath: ImageConstant.imgFacebook40x40,
                                    //               height: getSize(40),
                                    //               width: getSize(40),
                                    //               onTap: () {
                                    //                 onTapImgFacebook(context);
                                    //               }),
                                    //           Padding(
                                    //               padding: getPadding(
                                    //                   left: 16, top: 7, bottom: 8),
                                    //               child: Text("lbl_transfer_funds".tr,
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   textAlign: TextAlign.left,
                                    //                   style: AppStyle
                                    //                       .txtPoppinsMedium16Black900)),
                                    //           Spacer(),
                                    //           CustomImageView(
                                    //               svgPath:
                                    //                   ImageConstant.imgArrowdownBlack900,
                                    //               height: getVerticalSize(8),
                                    //               width: getHorizontalSize(4),
                                    //               margin: getMargin(top: 16, bottom: 16))
                                    //         ])),
                                    // Padding(
                                    //     padding: getPadding(top: 20),
                                    //     child: Divider(
                                    //         height: getVerticalSize(1),
                                    //         thickness: getVerticalSize(1),
                                    //         color: ColorConstant.gray200)),
                                    // Padding(
                                    //     padding: getPadding(top: 19, right: 1),
                                    //     child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           CustomImageView(
                                    //               svgPath: ImageConstant.imgSignal,
                                    //               height: getSize(40),
                                    //               width: getSize(40)),
                                    //           Padding(
                                    //               padding: getPadding(
                                    //                   left: 16, top: 10, bottom: 5),
                                    //               child: Text("msg_privacy_setting".tr,
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   textAlign: TextAlign.left,
                                    //                   style: AppStyle
                                    //                       .txtPoppinsMedium16Black900)),
                                    //           Spacer(),
                                    //           CustomImageView(
                                    //               svgPath:
                                    //                   ImageConstant.imgArrowdownBlack900,
                                    //               height: getVerticalSize(8),
                                    //               width: getHorizontalSize(4),
                                    //               margin: getMargin(top: 16, bottom: 16))
                                    //         ])),
                                    // Padding(
                                    //     padding: getPadding(top: 20, right: 1, bottom: 5),
                                    //     child: Row(
                                    //         mainAxisAlignment: MainAxisAlignment.center,
                                    //         children: [
                                    //           CustomImageView(
                                    //               svgPath: ImageConstant.imgUser1,
                                    //               height: getSize(40),
                                    //               width: getSize(40)),
                                    //           Padding(
                                    //               padding: getPadding(
                                    //                   left: 16, top: 9, bottom: 6),
                                    //               child: Text("lbl_community".tr,
                                    //                   overflow: TextOverflow.ellipsis,
                                    //                   textAlign: TextAlign.left,
                                    //                   style: AppStyle
                                    //                       .txtPoppinsMedium16Black900)),
                                    //           Spacer(),
                                    //           CustomImageView(
                                    //               svgPath:
                                    //                   ImageConstant.imgArrowdownBlack900,
                                    //               height: getVerticalSize(8),
                                    //               width: getHorizontalSize(4),
                                    //               margin: getMargin(top: 16, bottom: 16))
                                    //         ]))
                                  ])),
                        ],
                      ),
                    ),
              bottomNavigationBar: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => MyAlertDialog(
                      title: 'Logging out?'.tr,
                      subtitle:
                          'Thanks for stopping by. See you again soon!'.tr,
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
                child: CustomButton(
                    height: getVerticalSize(50),
                    text: "lbl_log_out".tr,
                    margin: getMargin(left: 24, right: 24, bottom: 52),
                    padding: ButtonPadding.PaddingT13,
                    prefixWidget: Container(
                        margin: getMargin(right: 14),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgIconWhiteA7001))),
              )));
    });
  }

  onTapRowuser(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.settingsScreen,
    );
  }

  onTapImgFacebook(BuildContext context) async {
    var url = 'https://www.facebook.com/login/';
    if (!await launch(url)) {
      throw 'Could not launch https://www.facebook.com/login/';
    }
  }

  onTapArrowleft9(BuildContext context) {
    NavigatorService.goBack();
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

class ProfileCard extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String role;
  final String email;
  final String imageUrl;

  ProfileCard({
    required this.name,
    required this.jobTitle,
    required this.role,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  jobTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.purple;
    //  ..style = PaintingStyle.fill
    //  ..strokeWidth = 10;
    // canvas.drawPath(
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 255, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
