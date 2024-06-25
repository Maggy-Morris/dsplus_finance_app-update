import 'package:dsplus_finance/admin/add_user/widgets/form_fields.dart';
import 'package:dsplus_finance/admin/add_user/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/add_user_cubit.dart';

class AddUsers extends StatelessWidget {
  final AddUserCubit addUserCubit;

  const AddUsers({Key? key, required this.addUserCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddUserCubit, AddUserStatus>(
      bloc: addUserCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Add Users"),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: FormFields(addUserCubit: addUserCubit),
          ),
        );
      },
    );
  }
}


