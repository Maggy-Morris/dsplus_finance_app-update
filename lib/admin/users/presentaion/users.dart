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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                print(" ///////////////${state.currentUserRole}" );
                if (state.status == UsersStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == UsersStatus.error) {
                  return const Center(child: Text("Error"));
                }
                 UserContainer(
                  isSuperAdmin: true,
                  title: 'Super Admins',
                  users: state.superAdmins,
                  isAdmin: false,
                  cubit: context.read<UsersCubit>(),
                );
                return Container();
              },
            ),
            BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                if (state.status == UsersStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == UsersStatus.success) {
                  return UserContainer(
                    isSuperAdmin: false,
                    title: 'Admins',
                    users: state.admins,
                    isAdmin: false,
                    cubit: context.read<UsersCubit>(),
                  );
                  return const Center(child: Text("Error"));
                }else if (state.status == UsersStatus.error) {
                  return const Center(child: Text("Error"));
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(height: 10),
            BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                if (state.status == UsersStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == UsersStatus.success) {
                  return UserContainer(
                    isSuperAdmin: false,
                    title: 'Users',
                    users: state.users,
                    isAdmin: false,
                    cubit: context.read<UsersCubit>(),
                  );
                  return const Center(child: Text("Error"));
                }else if (state.status == UsersStatus.error) {
                  return const Center(child: Text("Error"));
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
