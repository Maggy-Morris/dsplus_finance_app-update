import 'package:dsplus_finance/admin/add_user/cubit/add_user_cubit.dart';
import 'package:dsplus_finance/admin/add_user/widgets/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_bloc.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_state.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_container.dart';

class UsersPage extends StatelessWidget {
  final AddUserCubit addUserCubit;

  const UsersPage({super.key, required this.addUserCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.5),

              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(right: 10),
            child: BlocBuilder<AddUserCubit, AddUserStatus>(
              bloc: addUserCubit,
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    // bottom sheet to add user
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.6, // Set the initial height as a fraction of the screen height
                          expand: false,
                          builder: (BuildContext context, ScrollController scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FormFields(addUserCubit: addUserCubit),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                );
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserContainer(
                title: 'Super Admins',
                users: state.superAdmins,
                isAdmin: false,
                isSuperAdmin: true,
                bloc: context.read<UsersBloc>(),
              ),
              UserContainer(
                isSuperAdmin: false,
                title: 'Admins',
                users: state.admins,
                isAdmin: true,
                bloc: context.read<UsersBloc>(),
              ),
              SizedBox(height: 10),
              UserContainer(
                isSuperAdmin: false,
                title: 'Users',
                users: state.users,
                isAdmin: false,
                bloc: context.read<UsersBloc>(),
              ),
            ],
          );
        },
      ),
    );
  }
}
