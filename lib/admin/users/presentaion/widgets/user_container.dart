import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../presentation/ask_for_cash_screen/ask_for_cash_screen.dart';

class UserContainer extends StatelessWidget {
  final String title;
  final List<UserModel> users;
  final bool isAdmin;
  final bool isSuperAdmin;
  final UsersCubit cubit;

  const UserContainer({
    required this.title,
    required this.users,
    required this.isAdmin,
    required this.cubit,
    required this.isSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: isAdmin ? Colors.blue : Colors.green),
              borderRadius: BorderRadius.circular(10),
              color: isSuperAdmin
                  ? Colors.red[100]
                  : isAdmin
                  ? Colors.blue[100]
                  : Colors.green[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: isAdmin ? Colors.blue : Colors.green),
                    borderRadius: BorderRadius.circular(10),
                    color: isSuperAdmin
                        ? Colors.red[100]
                        : isAdmin
                        ? Colors.blue[100]
                        : Colors.green[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(users[index].name),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Job Title: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(users[index].jobTitle),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(users[index].email),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text("Profile Image: ", style: TextStyle(fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(imageUrl: users[index].image),
                                  ),
                                );
                              },
                              child: Image.network(
                                users[index].image,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                        trailing: (state.currentUserRole == "SuperAdmin")
                            ? _getTrailingIcon(users[index], context)
                            : (state.currentUserRole == "Admin")
                            ? getTrailingIcon(users[index], context)
                            : null,
                        onTap: (state.currentUserRole == "SuperAdmin")
                            ? _getOnTap(users[index], context)
                            : (state.currentUserRole == "Admin")
                            ? getOnTap(users[index], context)
                            : null
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget? _getTrailingIcon(UserModel user, BuildContext context) {
    if ((user.role == 'Admin') || (user.role == 'User')) {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _showDeleteDialog(user, context);
        },
      );
    }
    return null;
  }

  Widget? getTrailingIcon(UserModel user, BuildContext context) {
    if ((user.role == 'User')) {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _showDeleteDialog(user, context);
        },
      );
    }
    return null;
  }

  void Function()? _getOnTap(UserModel user, BuildContext context) {
    return () async {
      if (user.role == 'User') {
        bool makeAdmin = await _showRoleChangeDialog(context,
            'Change User Role', 'Do you want to make this user an admin?');
        if (makeAdmin) {
          cubit.makeAdmin(user.id);
          cubit.loadAdmins();
          cubit.loadUsers();
        }
      } else if (user.role == 'Admin') {
        bool makeSuperAdmin = await showRoleChangeDialog(
            context,
            'Change User Role',
            'Do you want to make this admin a super admin or a regular user?');
        if (makeSuperAdmin) {
          cubit.makeSuperAdmin(user.id);
          cubit.loadSuperAdmins();
          // cubit.loadUsers();
          cubit.loadAdmins();
        }else if (!makeSuperAdmin){
          cubit.demoteAdmin(user.id);
          cubit.loadUsers();
          cubit.loadAdmins();
        }
      }
    };

    return null;
  }
  void Function()? getOnTap(UserModel user, BuildContext context) {
    return () async {
      if (user.role == 'User') {
        bool makeAdmin = await _showRoleChangeDialog(context,
            'Change User Role', 'Do you want to make this user an admin?');
        if (makeAdmin) {
          cubit.makeAdmin(user.id);
          cubit.loadAdmins();
          cubit.loadUsers();
        }
      }
    };
  }

  Future<void> _showDeleteDialog(UserModel user, BuildContext context) async {
    bool delete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Do you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteUser(user.id);
                cubit.loadUsers();
                cubit.loadAdmins();
                Navigator.pop(context, true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (delete) {
      cubit.deleteUser(user.id);
      cubit.loadUsers(); // Ensure the list is reloaded
    }
  }

  Future<bool> _showRoleChangeDialog(
      BuildContext context, String title, String content) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> showRoleChangeDialog(
      BuildContext context, String title, String content) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Make User'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Make Super Admin'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'),
            ),
          ],
        );
      },
    );
  }
}