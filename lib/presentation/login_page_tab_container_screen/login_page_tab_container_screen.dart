import '../../admin/login_page_second.dart';
import 'bloc/login_page_tab_container_bloc.dart';
import 'models/login_page_tab_container_model.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/presentation/login_page/login_page.dart';
import 'package:flutter/material.dart';

class LoginPageTabContainerScreen extends StatefulWidget {
  @override
  _LoginPageTabContainerScreenState createState() =>
      _LoginPageTabContainerScreenState();

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginPageTabContainerBloc>(
      create: (context) => LoginPageTabContainerBloc(LoginPageTabContainerState(
        loginPageTabContainerModelObj: LoginPageTabContainerModel(),
      ))
        ..add(LoginPageTabContainerInitialEvent()),
      child: LoginPageTabContainerScreen(),
    );
  }
}

class _LoginPageTabContainerScreenState
    extends State<LoginPageTabContainerScreen> with TickerProviderStateMixin {
  late TabController loginsignupController;

  @override
  void initState() {
    super.initState();
    loginsignupController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPageTabContainerBloc, LoginPageTabContainerState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: 
            TabBarView(
              controller: loginsignupController,
              children: [
                LoginPageSecond(),
              ],
            ),
          ),
        );
      },
    );
  }
}
