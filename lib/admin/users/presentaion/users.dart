import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_container.dart';

class UsersPage extends StatelessWidget {

  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UsersCubit>().currentUserRole();
    context.read<UsersCubit>().LoadUsers();
    context.read<UsersCubit>().LoadAdmins();
    context.read<UsersCubit>().LoadSuperAdmins();
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,

      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state.status == UsersStatus.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == UsersStatus.success) {
            if (state.admins.isEmpty && state.users.isEmpty) {
              return Center(
                child: Text('No users found'),
              );
            } else {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: BlocBuilder<UsersCubit, UsersState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        (state.currentUserRole == "SuperAdmin")?UserContainer(
                          isSuperAdmin: true,
                          title: 'Super Admins',
                          users: state.superAdmins,
                          isAdmin: false,
                          cubit: context.read<UsersCubit>(),
                        ):Container(),
                        UserContainer(
                          isSuperAdmin: false,
                          title: 'Admins',
                          users: state.admins,
                          isAdmin: true,
                          cubit: context.read<UsersCubit>(),
                        ),
                        SizedBox(height: 10),
                        UserContainer(
                          isSuperAdmin: false,
                          title: 'Users',
                          users: state.users,
                          isAdmin: false,
                          cubit: context.read<UsersCubit>(),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          } else if (state.status == UsersStatus.error) {
            return Center(
              child: Text('An error occurred'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
