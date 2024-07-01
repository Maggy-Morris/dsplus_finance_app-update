import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:dsplus_finance/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:intl/intl.dart';

import '../attachements/banner/controllers/banner_controller.dart';
import '../home_page/models/transactions_model.dart';
import '../transfer_screen/bloc/transfer_bloc.dart';

class AskForCashScreen extends StatefulWidget {
  static Widget builder(BuildContext context) {
    return AskForCashScreen();
  }

  @override
  State<AskForCashScreen> createState() => _AskForCashScreenState();
}

class _AskForCashScreenState extends State<AskForCashScreen> {
  BannerController bannerController = BannerController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TransferBloc()),
        ],
        child: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: ColorConstant.whiteA700,
                appBar: CustomAppBar(
                  height: getVerticalSize(50),
                  leadingWidth: 59,
                  leading: AppbarIconbutton(
                    svgPath: ImageConstant.imgArrowleftBlack900,
                    margin: getMargin(left: 24, top: 8, bottom: 7),
                    onTap: () {
                      Navigator.pushNamed(context, '/home_page');
                    },
                  ),
                  centerTitle: true,
                  title: AppbarSubtitle(text: "اذن صرف".tr),
                ),
                body: SingleChildScrollView(
                  padding: getPadding(left: 24, right: 24, top: 30, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildBanner(),
                      buildTextFormField(
                        context,
                        state,
                        'Name',
                        Icons.person,
                        TextInputType.text,
                        (value) {
                          TransferBloc.get(context).add(EditName(name: value));
                          TransferBloc.get(context)
                              .add(EditUserName(userName: state.userName));
                        },
                      ),
                      SizedBox(height: 16),
                      buildTextFormField(
                        context,
                        state,
                        'Money',
                        Icons.monetization_on_sharp,
                        TextInputType.number,
                        (value) {
                          TransferBloc.get(context).add(EditAmount(
                              amount: double.tryParse(value) ?? 0.0));
                        },
                      ),
                      SizedBox(height: 16),
                      buildRadioOptions(context, state),
                      SizedBox(height: 16),
                      buildImagePickers(context, state),
                      SizedBox(height: 20),
                      buildAttachmentsList(context, state),
                      SizedBox(height: 40),
                      Center(
                        child: CustomIconButton(
                          height: 70,
                          width: 70,
                          variant: IconButtonVariant.OutlineBlueA70066,
                          shape: IconButtonShape.CircleBorder35,
                          padding: IconButtonPadding.PaddingAll23,
                          onTap: () async {
                            if (state.name?.isNotEmpty == true &&
                                state.amount != 0 &&
                                state.files.isNotEmpty) {
                              final now = DateTime.now();
                              final dateFormat = DateFormat('dd/MM/yyyy');
                              final formattedDate = dateFormat.format(now);
                              TransactionsModel transaction = TransactionsModel(
                                createdAt: DateTime.now(),
                                email: firebaseAuth.currentUser?.email ?? "",
                                attachments: state.files,
                                name: state.name,
                                userName: state.userName,
                                amount: state.amount,
                                userId: firebaseAuth.currentUser?.uid,
                                type: 'اذن صرف',
                                status: 'pending',
                                date: formattedDate,
                                id: '',
                                cashOrCredit: state.selectedOption == "cash",
                                bankName: state.bankName,
                                accountNumber: state.accountNumber,
                              );

                              onTapBtnArrowright(context, transaction);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Please fill all fields and add attachments.')),
                              );
                            }
                          },
                          child: CustomImageView(
                              svgPath: ImageConstant.imgArrowright),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBanner() {
    return Container(
      width: double.infinity,
      margin: getMargin(bottom: 28),
      padding: getPadding(left: 44, top: 49, right: 44, bottom: 49),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: fs.Svg(ImageConstant.imgGroup199),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            svgPath: ImageConstant.imgVolume23x36,
            height: getVerticalSize(23),
            width: getHorizontalSize(36),
            margin: getMargin(bottom: 18),
          ),
          Spacer(),
          Text(
            "lbl_4023".tr,
            style: AppStyle.txtPoppinsMedium10,
          ),
          Padding(
            padding: getPadding(left: 8),
            child: Text(
              "lbl_5534".tr,
              style: AppStyle.txtPoppinsMedium10,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(
    BuildContext context,
    TransferState state,
    String labelText,
    IconData icon,
    TextInputType keyboardType,
    Function(String) onChanged,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Widget buildRadioOptions(BuildContext context, TransferState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile(
          title: Text('Cash'),
          value: 'cash',
          groupValue: state.selectedOption,
          onChanged: (value) {
            TransferBloc.get(context).add(
              RadioButtonChanged(
                selectedOption: value ?? "",
                showTextField: false,
              ),
            );
          },
        ),
        RadioListTile(
          title: Text('Credit'),
          value: 'credit',
          groupValue: state.selectedOption,
          onChanged: (value) {
            TransferBloc.get(context).add(
              RadioButtonChanged(
                selectedOption: value ?? "",
                showTextField: true,
              ),
            );
          },
        ),
        if (state.showTextField == true)
          Column(
            children: [
              buildTextFormField(
                context,
                state,
                'Enter Account Number',
                Icons.account_balance,
                TextInputType.number,
                (value) {
                  TransferBloc.get(context)
                      .add(AccountNumber(accountNumber: int.parse(value)));
                },
              ),
              SizedBox(height: 16),
              buildTextFormField(
                context,
                state,
                'Enter Bank Name',
                Icons.account_balance_outlined,
                TextInputType.text,
                (value) {
                  TransferBloc.get(context).add(BankName(bankName: value));
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget buildImagePickers(BuildContext context, TransferState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<TransferBloc>().pickAndAddFiles();
          },
          child: Text('Pick Images'),
        ),
        ElevatedButton(
          onPressed: () {
            TransferBloc.get(context).captureAndAddImage();
          },
          child: Text('Capture Images'),
        ),
      ],
    );
  }

  Widget buildAttachmentsList(BuildContext context, TransferState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.files.length,
      itemBuilder: (context, index) {
        PlatformFile file = state.files[index];

        return ListTile(
          title: Text(file.name),
          leading: Image.file(
            File(file.path!),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              TransferBloc.get(context).removeFileAtIndex(index);
            },
          ),
        );
      },
    );
  }

  void onTapBtnArrowright(BuildContext context, TransactionsModel transaction) {
    NavigatorService.pushNamed(
      AppRoutes.sendMoneyScreen,
      arguments: transaction,
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
