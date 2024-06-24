// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dsplus_finance/presentation/attachements/banner/controllers/banner_controller.dart';
import 'package:dsplus_finance/presentation/attachements/widgets/custom_textbutton.dart';
import 'package:dsplus_finance/presentation/attachements/widgets/ficon_button.dart';
import '../../../Settlement_of_accounts/bloc/settlements_of_accounts_bloc.dart';
import '../../../home_page/models/transactions_model.dart';

class AddBannerScreen extends StatefulWidget {
  TransactionsModel? homePageItemModelObj;

  static Widget builder(BuildContext context) {
    return BlocProvider<SettlementsOfAccountsBloc>(
      create: (context) =>
          SettlementsOfAccountsBloc(SettlementsOfAccountsState())
            ..add(SettlementsOfAccountsEvent()),
      child: AddBannerScreen(),
    );
  }

  // static const String routeName = '/add-banner-screen';
  // String transId;
  AddBannerScreen({
    Key? key,
    // required this.transId,
  }) : super(key: key);

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  late TransactionsModel homePageItemModelObj;

  // @override
  // void initState() {
  //   super.initState();
  //   homePageItemModelObj = widget.homePageItemModelObj!;
  // }

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  // TextEditingController descriptionController = TextEditingController();
  // String descriptionText = '';

  takePhoto() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  uploadPhoto() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  Future<void> handleConfirm() async {
    final TransactionsModel homePageItemModelObj =
        ModalRoute.of(context)!.settings.arguments as TransactionsModel;
    final state = context.read<SettlementsOfAccountsBloc>().state;

    if (state.descriptionController.isNotEmpty == true &&
        state.amountController != 0) {
      // final name = state.descriptionController?.text ?? '';
      // final amount = double.parse(state.amountController?.text ?? '');

      if (state.amountController > (homePageItemModelObj.amount ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('You cannot ask for more money than your balance.'),
          ),
        );
      } else {
        // Proceed with creating the banner
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          //  ..backgroundColor = Colors.blue
          ..indicatorColor = Colors.blue
          //  ..maskColor = Colors.red
          ..userInteractions = false;
        EasyLoading.show(); // Show loading animation

        BannerController bannerController = BannerController();
        await bannerController.createBanner(
            image: imageXFile!,
            description: state.descriptionController,
            transactionID: homePageItemModelObj.id,
            amount: state.amountController,
            status: "pending",
            reason: "");

        // Print debug message
       debugPrint(
            "Banner created successfully with transaction ID: ${homePageItemModelObj.id}");
        EasyLoading.dismiss();

        // Pop the screen
        Navigator.pop(context);
      }
    } else {
      // Show a snackbar or any other UI feedback indicating that all fields are required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill all fields.'),
        ),
      );

      // Hide loading animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettlementsOfAccountsBloc, SettlementsOfAccountsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text(
              'Add Attachments',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: imageXFile == null ||
                        context
                            .read<SettlementsOfAccountsBloc>()
                            .state
                            .descriptionController
                            .isEmpty ||
                        context
                                .read<SettlementsOfAccountsBloc>()
                                .state
                                .amountController !=
                            0
                    ? () {}
                    : handleConfirm,
                icon: Icon(
                  Icons.add,
                  color: imageXFile == null ||
                          context
                              .read<SettlementsOfAccountsBloc>()
                              .state
                              .descriptionController
                              .isEmpty ||
                          context
                                  .read<SettlementsOfAccountsBloc>()
                                  .state
                                  .amountController !=
                              0
                      ? Colors.grey[400]
                      : Colors.white,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageXFile == null
                            // && imageUrl.isEmpty
                            ? DottedBorder(
                                color: Colors.grey[500]!,
                                strokeWidth: 1,
                                dashPattern: const [10, 6],
                                child: SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 70,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: CustomTextButton(
                                              text: 'Take a photo',
                                              onPressed: takePhoto,
                                              isDisabled: false,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: CustomTextButton(
                                              text: 'Upload a photo',
                                              onPressed: uploadPhoto,
                                              isDisabled: false,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : DottedBorder(
                                color: Colors.grey[500]!,
                                strokeWidth: 1,
                                dashPattern: const [10, 6],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 180,
                                        // width: MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 4 / 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        File(imageXFile!.path),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: FIconButton(
                                                  icon: const Icon(Icons.close),
                                                  backgroundColor: Colors.white,
                                                  onPressed: () {
                                                    setState(() {
                                                      // imageUrl = '';
                                                      imageXFile = null;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        TextFormField(
                          // focusNode: FocusNode(),
                          onChanged: (value) {
                            context
                                .read<SettlementsOfAccountsBloc>()
                                .add(EditDescrition(description: value));
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Description',
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        TextFormField(
                          // focusNode: FocusNode(),

                          onChanged: (value) {
                            context
                                .read<SettlementsOfAccountsBloc>()
                                .add(EditAmount(amount: double.parse(value)));
                          },
                          decoration: InputDecoration(
                            icon: Icon(Icons.monetization_on_sharp),
                            hintText: 'Money',
                            labelText: 'Money',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                CustomTextButton(
                  text: 'Confirm',
                  onPressed: handleConfirm,
                  isDisabled: imageXFile == null ||
                      context
                          .read<SettlementsOfAccountsBloc>()
                          .state
                          .descriptionController
                          .isEmpty ||
                      context
                              .read<SettlementsOfAccountsBloc>()
                              .state
                              .amountController ==
                          0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
