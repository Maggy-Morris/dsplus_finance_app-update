import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dsplus_finance/presentation/attachements/banner/screens/banner_screen.dart';
// import 'package:dsplus_finance/widgets/custom_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:dsplus_finance/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;

import 'package:dsplus_finance/presentation/attachements/banner/controllers/banner_controller.dart';
import 'package:intl/intl.dart';

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
    // User? user = FirebaseAuth.instance.currentUser;
    // TransactionsModel transactionsModel = TransactionsModel();

    // final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();

    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TransferBloc(),
          ),
        ],
        child: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: ColorConstant.whiteA700,
              appBar: CustomAppBar(
                height: getVerticalSize(50),
                leadingWidth: 59,
                leading: AppbarIconbutton(
                    svgPath: ImageConstant.imgArrowleftBlack900,
                    margin: getMargin(left: 24, top: 8, bottom: 7),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/home_page',
                      );
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "اذن صرف".tr),
                // actions: [
                //   AppbarIconbutton(
                //       svgPath: ImageConstant.imgVolumeBlack900,
                //       margin: getMargin(left: 24, top: 7, right: 24, bottom: 8))
                // ]
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: getPadding(top: 10, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Padding(
                      //     padding: getPadding(top: 12),
                      //     child: Text("lbl_alex_dordan".tr,
                      //         overflow: TextOverflow.ellipsis,
                      //         textAlign: TextAlign.left,
                      //         style: AppStyle.txtPoppinsMedium18)),
                      // Padding(
                      //     padding: getPadding(top: 1),
                      //     child: Text("lbl_web_developer".tr,
                      //         overflow: TextOverflow.ellipsis,
                      //         textAlign: TextAlign.left,
                      //         style: AppStyle.txtPoppinsMedium10Gray500)),
                      Container(
                        width: getHorizontalSize(325),
                        margin: getMargin(left: 25, top: 28, right: 25),
                        padding: getPadding(
                            left: 44, top: 49, right: 44, bottom: 49),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: fs.Svg(ImageConstant.imgGroup199),
                                fit: BoxFit.cover)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageView(
                                  svgPath: ImageConstant.imgVolume23x36,
                                  height: getVerticalSize(23),
                                  width: getHorizontalSize(36),
                                  margin: getMargin(bottom: 18)),
                              CustomImageView(
                                  svgPath: ImageConstant.img1,
                                  height: getVerticalSize(4),
                                  width: getHorizontalSize(32),
                                  margin:
                                      getMargin(left: 20, top: 10, bottom: 27)),
                              CustomImageView(
                                  svgPath: ImageConstant.img1,
                                  height: getVerticalSize(4),
                                  width: getHorizontalSize(32),
                                  margin:
                                      getMargin(left: 10, top: 10, bottom: 27)),
                              Padding(
                                  padding:
                                      getPadding(left: 10, top: 3, bottom: 23),
                                  child: Text("lbl_4023".tr,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtPoppinsMedium10)),
                              Padding(
                                padding: getPadding(
                                    left: 8, top: 3, right: 38, bottom: 23),
                                child: Text("lbl_5534".tr,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtPoppinsMedium10),
                              ),
                            ]),
                      ),
                      TextFormField(
                        // variant: TextFormFieldVariant.OutlineWhite20004,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          TransferBloc.get(context).add(EditName(name: value));
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Name',
                          labelText: 'Name',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),

                      TextFormField(
                        onChanged: (value) {
                          TransferBloc.get(context).add(EditAmount(
                              amount: double.tryParse(value) ?? 0.0));
                        },
                        // focusNode: FocusNode(),
                        // variant: TextFormFieldVariant.OutlineWhite20004,
                        // controller: state.amountController,
                        keyboardType: TextInputType.number,

                        decoration: const InputDecoration(
                          icon: Icon(Icons.monetization_on_sharp),
                          hintText: 'Money',
                          labelText: 'Money',
                        ),
                        onSaved: (String? value) {},
                      ),
                      /////////////////////////////////////////
                      /////////////////////////////////////////

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile(
                              title: const Text('Cash'),
                              value: 'cash',
                              groupValue: state.selectedOption,
                              onChanged: (value) {
                                TransferBloc.get(context).add(
                                    RadioButtonChanged(
                                        selectedOption: value ?? "",
                                        showTextField: false));
                              },
                            ),
                            RadioListTile(
                              title: const Text('Credit'),
                              value: 'credit',
                              groupValue: state.selectedOption,
                              onChanged: (value) {
                                TransferBloc.get(context).add(
                                    RadioButtonChanged(
                                        selectedOption: value ?? "",
                                        showTextField: true));
                              },
                            ),
                            if (state.showTextField == true)
                              Column(
                                children: [
                                  TextFormField(
                                    // focusNode: FocusNode(),
                                    // controller: accountNumberController,
                                    onChanged: (value) {
                                      TransferBloc.get(context).add(
                                          AccountNumber(
                                              accountNumber: int.parse(value)));
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Enter Account Number'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    // focusNode: FocusNode(),

                                    // controller: bankNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Enter Bank Name'),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      TransferBloc.get(context)
                                          .add(BankName(bankName: value));
                                    },
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),

                      //   BlocSelector<TransferBloc, TransferState, List<PlatformFile>>(
                      //   selector: (state) => state.files,
                      //   builder: (context, files) {
                      //     return SingleChildScrollView(
                      //       child: Column(
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //             children: [
                      //               ElevatedButton(
                      //                 onPressed: () {
                      //                   context
                      //                       .read<TransferBloc>()
                      //                       .pickAndAddFiles(context);
                      //                 },
                      //                 child: Text(' Pick Images '),
                      //               ),
                      //               ElevatedButton(
                      //                 onPressed: () {
                      //                   context
                      //                       .read<TransferBloc>()
                      //                       .captureAndAddImage(context);
                      //                 },
                      //                 child: Text(' Capture Images '),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(height: 20),
                      //           ListView.builder(
                      //             shrinkWrap: true,
                      //             physics: const NeverScrollableScrollPhysics(),
                      //             itemCount: files.length,
                      //             itemBuilder: (context, index) {
                      //               PlatformFile file = files[index];

                      //               return ListTile(
                      //                 title: Text(file.name),
                      //                 leading: Image.file(
                      //                   File(file.path!),
                      //                   width: 50,
                      //                   height: 50,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //                 trailing: IconButton(
                      //                   icon: Icon(Icons.close),
                      //                   onPressed: () {
                      //                     // Add your logic here to remove the file from the state
                      //                     context
                      //                         .read<TransferBloc>()
                      //                         .removeFileAtIndex(index);
                      //                   },
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      // BlocBuilder<TransferBloc, TransferState>(
                      //   builder: (context, state) {
                      //     return

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<TransferBloc>()
                                        .pickAndAddFiles();
                                  },
                                  child: Text(' Pick Images '),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    TransferBloc.get(context)
                                        .captureAndAddImage();
                                  },
                                  child: Text(' Capture Images '),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ListView.builder(
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
                                      TransferBloc.get(context)
                                          .removeFileAtIndex(index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      //   },
                      // ),

                      CustomIconButton(
                        height: 70,
                        width: 70,
                        margin: getMargin(top: 40, bottom: 5),
                        variant: IconButtonVariant.OutlineBlueA70066,
                        shape: IconButtonShape.CircleBorder35,
                        padding: IconButtonPadding.PaddingAll23,
                        onTap: () async {
                          // Check if any of the text fields are empty or if there are no attachments
                          if (state.name?.isNotEmpty == true &&
                              state.amount != 0 &&
                              // state.bankNameController?.text?.isNotEmpty == true &&
                              state.files.isNotEmpty) {
                            // state.accountNumberController?.text?.isNotEmpty == true &&

                            final now = DateTime.now();
                            final dateFormat = DateFormat('dd/MM/yyyy');
                            final formattedDate = dateFormat.format(now);
                            TransactionsModel transaction = TransactionsModel(
                              email: firebaseAuth.currentUser?.email ?? "",
                              name: state.name,
                              amount: state.amount,
                              userId: firebaseAuth.currentUser?.uid,
                              type: 'اذن صرف',
                              status: 'pending',
                              date: formattedDate,
                              id: '',
                              cashOrCredit:
                                  state.selectedOption == "cash" ? true : false,
                              bankName: state.bankName,
                              accountNumber: state.accountNumber,
                            );

                            // Upload images
                            // await context
                            //     .read<TransferBloc>()
                            //     .uploadFilesAndUpdateTransaction(transaction);

                            // Navigate to the next screen
                            onTapBtnArrowright(context, transaction);
                          } else {
                            // Show a snackbar indicating that all fields are required
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please fill all fields and add attachments.'),
                              ),
                            );
                          }
                        },
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowright),
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

  void onTapBtnArrowright(BuildContext context, TransactionsModel transaction) {
    NavigatorService.pushNamed(
      AppRoutes.sendMoneyScreen,
      arguments: transaction, // Pass the transaction object as an argument
    );
  }

  onTapBtnArrowrightaftersubmittngrrequest(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.homePage,
    );
  }

  onTapArrowleft(BuildContext context) {
    NavigatorService.goBack();
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Customize app bar if needed
        title: Text('Full Screen'),
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
