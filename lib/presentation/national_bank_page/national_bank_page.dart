import '../national_bank_page/widgets/nationalbank_item_widget.dart';
import 'bloc/national_bank_bloc.dart';
import 'models/national_bank_model.dart';
import 'models/nationalbank_item_model.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_iconbutton_2.dart';
import 'package:dsplus_finance/widgets/app_bar/appbar_subtitle.dart';
import 'package:dsplus_finance/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NationalBankPage extends StatelessWidget {
  static Widget builder(BuildContext context) {
    return BlocProvider<NationalBankBloc>(
        create: (context) => NationalBankBloc(
            NationalBankState(nationalBankModelObj: NationalBankModel()))
          ..add(NationalBankInitialEvent()),
        child: NationalBankPage());
  }

  @override
  Widget build(BuildContext context) {
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
                      onTapArrowleft7(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "lbl_wallet".tr),
                actions: [
                  AppbarIconbutton(
                    svgPath: ImageConstant.imgVolumeBlack900,
                    margin: getMargin(left: 24, top: 7, right: 24, bottom: 7),
                  )
                ]),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 12, right: 24, bottom: 12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                          svgPath: ImageConstant.imgArrowdown,
                          height: getSize(98),
                          width: getSize(98),
                          margin: getMargin(top: 13)),
                      Padding(
                          padding: getPadding(top: 15),
                          child: Text("EGP 1000".tr,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtPoppinsMedium30)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: getPadding(top: 28),
                              child: Text("msg_10_790_00_total".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsMedium14Gray500))),
                      Padding(
                          padding: getPadding(left: 1, top: 16),
                          child: BlocSelector<NationalBankBloc,
                                  NationalBankState, NationalBankModel?>(
                              selector: (state) => state.nationalBankModelObj,
                              builder: (context, nationalBankModelObj) {
                                return ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: getVerticalSize(15));
                                    },
                                    itemCount: nationalBankModelObj
                                            ?.nationalbankItemList.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      NationalbankItemModel model =
                                          nationalBankModelObj
                                                      ?.nationalbankItemList[
                                                  index] ??
                                              NationalbankItemModel();
                                      return NationalbankItemWidget(model);
                                    });
                              }))
                    ]))));
  }

  onTapArrowleft7(BuildContext context) {
    NavigatorService.goBack();
  }
}
