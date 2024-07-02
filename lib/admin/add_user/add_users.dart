import 'package:dsplus_finance/admin/add_user/widgets/form_fields.dart';
import 'package:dsplus_finance/admin/add_user/widgets/text_field.dart';
import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:dsplus_finance/core/utils/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/add_user_cubit.dart';

class AddUsers extends StatelessWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Users"),
        centerTitle: true,
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state.status == UsersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return (state.currentUserRole == "Admin" ||
                  state.currentUserRole == "SuperAdmin")
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: FormFields(),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You are not authorized to view this page"),
                      ElevatedButton(
                        onPressed: () => logout(context),
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
