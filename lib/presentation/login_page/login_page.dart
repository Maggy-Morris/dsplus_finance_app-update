import 'package:fluttertoast/fluttertoast.dart';

import 'bloc/login_bloc.dart';
import 'models/login_model.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/custom_button.dart';
import 'package:dsplus_finance/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static Widget builder(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(LoginState(loginModelObj: LoginModel()))
          ..add(LoginInitialEvent()),
        child: LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode emailFocusNode = FocusNode();

  final FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(left: 24, top: 38, right: 24),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // create a rounded container
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: getSize(212),
                      height: getSize(212),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomImageView(
                          svgPath:
                              ImageConstant.imgIllustrationBlueGray900212x212,
                          alignment: Alignment.center),
                    ),
                  ),

                  BlocSelector<LoginBloc, LoginState, TextEditingController?>(
                      selector: (state) => state.emailController,
                      builder: (context, nameController) {
                        return CustomTextFormField(
                            focusNode: emailFocusNode,
                            controller: nameController,
                            textInputType: TextInputType.emailAddress,
                            hintText: "lbl_email".tr,
                            margin: getMargin(top: 49));
                      }),
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                    return CustomTextFormField(
                        focusNode: passwordFocusNode,
                        controller: state.passwordController,
                        hintText: "lbl_password".tr,
                        margin: getMargin(top: 20),
                        padding: TextFormFieldPadding.PaddingT14,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.visiblePassword,
                        suffix: InkWell(
                            onTap: () => context.read<LoginBloc>().add(
                                ChangePasswordVisibilityEvent(
                                    value: state.isShowPassword == false)),
                            child: Container(
                                margin: getMargin(
                                    left: 30, top: 18, right: 16, bottom: 18),
                                child: Icon(
                                  (state.isShowPassword ?? false)
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey.shade500,
                                ))),
                        suffixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(52)),
                        isObscureText: state.isShowPassword);
                  }),
                ]),
          ),
        ),
        CustomButton(
            height: getVerticalSize(50),
            text: "lbl_login".tr,
            margin: getMargin(top: 30),
            shape: ButtonShape.RoundedBorder13,
            onTap: () {
              onTapLogin(context);
            }),
      ]),
    );
  }

  onTapLogin(BuildContext context) {
    context.read<LoginBloc>().add(
          CreateLoginEvent(
            onCreateLoginEventSuccess: () {
              _onCreateLoginEventSuccess(context);
            },
            onCreateLoginEventError: () {
              _onCreateLoginEventError(context);
            },
          ),
        );
  }

  void _onCreateLoginEventSuccess(BuildContext context) {
    NavigatorService.pushNamedAndRemoveUntil(
      AppRoutes.homePageContainerScreen,
    );
  }

  void _onCreateLoginEventError(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Invalid username or password!",
    );
  }
}
