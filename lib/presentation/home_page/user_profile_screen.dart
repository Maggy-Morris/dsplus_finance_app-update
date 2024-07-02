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
                                                        child: Center(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(75),
                                                            child: Image.network(
                                                              "${state.userModel?.image}",
                                                              fit: BoxFit.fill,
                                                              width: 150,
                                                              height: 150,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object exception,
                                                                  StackTrace?
                                                                      stackTrace) {
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
                                                                    child: Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: scheme.primary,
                                                                      size: 50,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
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

                        logout(context);

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
