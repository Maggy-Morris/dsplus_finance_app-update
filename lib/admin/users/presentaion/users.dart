import 'package:dsplus_finance/admin/add_user/cubit/add_user_cubit.dart';
import 'package:dsplus_finance/admin/add_user/widgets/form_fields.dart';
import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_container.dart';

class UsersPage extends StatelessWidget {
  // final AddUserCubit addUserCubit;

  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UsersCubit>().currentUserRole();
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
        // actions: [
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.green.withOpacity(0.5),
        //
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     margin: EdgeInsets.only(right: 10),
        //     child: BlocBuilder<AddUserCubit, AddUserStatus>(
        //       bloc: addUserCubit,
        //       builder: (context, state) {
        //         return IconButton(
        //           onPressed: () {
        //             // bottom sheet to add user
        //             showModalBottomSheet(
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(20),
        //                   topRight: Radius.circular(20),
        //                 ),
        //               ),
        //               context: context,
        //               isScrollControlled: true,
        //               backgroundColor: Colors.transparent,
        //               builder: (context) {
        //                 return DraggableScrollableSheet(
        //                   initialChildSize: 0.6,
        //                   // Set the initial height as a fraction of the screen height
        //                   expand: false,
        //                   builder: (BuildContext context,
        //                       ScrollController scrollController) {
        //                     return Container(
        //                       decoration: BoxDecoration(
        //                         color: Colors.white,
        //                         borderRadius: BorderRadius.only(
        //                           topLeft: Radius.circular(20),
        //                           topRight: Radius.circular(20),
        //                         ),
        //                       ),
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(16.0),
        //                         child: FormFields(addUserCubit: addUserCubit),
        //                       ),
        //                     );
        //                   },
        //                 );
        //               },
        //             );
        //           },
        //           icon: Icon(Icons.add),
        //         );
        //       },
        //     ),
        //   )
        // ],
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
