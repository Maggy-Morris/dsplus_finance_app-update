import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_container.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usersCubit = context.read<UsersCubit>();
    usersCubit.currentUserRole();
    usersCubit.loadUsers();
    usersCubit.loadAdmins();
    usersCubit.loadSuperAdmins();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state.status == UsersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == UsersStatus.error) {
            return const Center(child: Text("Error loading users"));
          }
          if (state.status == UsersStatus.adminSuccess ||
              state.status == UsersStatus.superAdminSuccess ||
              state.status == UsersStatus.userSuccess) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  (state.currentUserRole == "SuperAdmin")
                      ? UserContainer(
                    isSuperAdmin: true,
                    title: 'Super Admins',
                    users: state.superAdmins,
                    isAdmin: false,
                    cubit: context.read<UsersCubit>(),
                  )
                      : Container(),
                  (state.admins.isEmpty)
                      ? Container()
                      : UserContainer(
                    isSuperAdmin: false,
                    title: 'Admins',
                    users: state.admins,
                    isAdmin: true,
                    cubit: context.read<UsersCubit>(),
                  ),
                  SizedBox(height: 10),
                  (state.users.isEmpty)
                      ? Container()
                      : UserContainer(
                    isSuperAdmin: false,
                    title: 'Users',
                    users: state.users,
                    isAdmin: false,
                    cubit: context.read<UsersCubit>(),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
