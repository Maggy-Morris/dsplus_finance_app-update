import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomAppBar extends StatefulWidget {
  final Function(BottomBarEnum)? onChanged;

  const CustomBottomAppBar({super.key, this.onChanged});

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgLock,
      type: BottomBarEnum.Lock,
      isSelected: true,
      name: 'lbl_home'.tr,
    ),
    // BottomMenuModel(
    //   icon: ImageConstant.imgCheckmarkGray500,
    //   type: BottomBarEnum.CheckMarkGray500,
    //   name: 'lbl_statistics'.tr,
    // ),
    // BottomMenuModel(
    //   icon: ImageConstant.imgComputerGray500,
    //   type: BottomBarEnum.ComputerGray500,
    //   name: 'lbl_wallet'.tr,
    // ),
    BottomMenuModel(
      icon: ImageConstant.imgSearchGray5002,
      type: BottomBarEnum.SearchGray5002,
      name: 'lbl_profile'.tr,
    )
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        for (var element in bottomMenuList) {
          element.isSelected = false;
        }
        bottomMenuList[index].isSelected = true;
        widget.onChanged?.call(bottomMenuList[index].type);
        _index = index;
        setState(() {});
      },
      selectedIndex: _index,
      indicatorColor: Colors.transparent,
      indicatorShape: CircleBorder(),
      destinations: [
        ...bottomMenuList.map((bottomMenu) {
          return NavigationDestination(
            selectedIcon: SvgPicture.asset(bottomMenu.icon,
                colorFilter:
                    ColorFilter.mode(Colors.redAccent, BlendMode.srcIn)),
            icon: SvgPicture.asset(bottomMenu.icon,
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
            label: bottomMenu.name,
          );
        }).toList(),
      ],
    );
  }
}

enum BottomBarEnum {
  Lock,
  CheckMarkGray500,
  ComputerGray500,
  SearchGray5002,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.type,
    this.isSelected = false,
    this.iconSize = 22,
    required this.name,
  });

  String icon;

  String name;

  int iconSize;

  BottomBarEnum type;

  bool isSelected;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
