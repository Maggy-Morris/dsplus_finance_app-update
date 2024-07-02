import 'package:dsplus_finance/presentation/attachements/constants/colors.dart';
import 'package:flutter/material.dart';

ListTile listTile(
    BuildContext context, String text, IconData? icon, VoidCallback onTap) {
  return icon == null
      ? ListTile(
          title: Text(
            text,
            style: const TextStyle(
              color: MyColors.textColor,
              fontSize: 14,
            ),
          ),
          onTap: onTap,
        )
      : ListTile(
          title: Text(
            text,
            style: const TextStyle(
              color: MyColors.textColor,
              fontSize: 14,
            ),
          ),
          leading: Icon(
            icon,
            color: scheme.primary,
          ),
          onTap: onTap,
        );
}
