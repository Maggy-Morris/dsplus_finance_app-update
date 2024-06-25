import 'package:dsplus_finance/admin/users/presentaion/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_bloc.dart';
import '../../user_bloc/users_event.dart';

class UserContainer extends StatelessWidget {
  final String title;
  final List<UserModel> users;
  final bool isAdmin;
  final bool isSuperAdmin;
  final UsersBloc bloc;

  const UserContainer({
    required this.title,
    required this.users,
    required this.isAdmin,
    required this.bloc,
    required this.isSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: isAdmin ? Colors.blue : Colors.green),
        borderRadius: BorderRadius.circular(10),
        color: isSuperAdmin ? Colors.red[100] : isAdmin ? Colors.blue[100] : Colors.green[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ...users.map((user) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user.name),
                  Text(user.email),
                  Text(
                    user.role,
                    style: TextStyle(color: isAdmin || isSuperAdmin ? Colors.red : Colors.black),
                  ),
                ],
              ),
              dense: true,
              trailing: _getTrailingIcon(user, context),
              onTap: _getOnTap(user, context),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget? _getTrailingIcon(UserModel user, BuildContext context) {
    if ((isSuperAdmin && user.role != 'SuperAdmin') || (!isAdmin && user.role == 'User')) {
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
    if (isSuperAdmin) {
      if (user.role == 'SuperAdmin') {
        return () async {
          if (user.role == 'User') {
            bool makeAdmin = await _showRoleChangeDialog(context, 'Change User Role', 'Do you want to make this user an admin?');
            if (makeAdmin) {
              bloc.add(MakeAdmin(user.id));
            }
          } else if (user.role == 'Admin') {
            bool makeSuperAdmin = await _showRoleChangeDialog(context, 'Change User Role', 'Do you want to make this admin a super admin?');
            if (makeSuperAdmin) {
              bloc.add(MakeSuperAdmin(user.id));
            } else {
              bool makeUser = await _showRoleChangeDialog(context, 'Change User Role', 'Do you want to make this admin a regular user?');
              if (makeUser) {
                bloc.add(DemoteAdmin(user.id));
              }
            }
          }
        };
      }
    }
    else if (!isAdmin && user.role == 'User') {
      return () async {
        bool makeAdmin = await _showRoleChangeDialog(context, 'Change User Role', 'Do you want to make this user an admin?');
        if (makeAdmin) {
          bloc.add(MakeAdmin(user.id));
        }
      };
    }
    return null;
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
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (delete) {
      bloc.add(DeleteUser(user.id));
    }
  }

  Future<bool> _showRoleChangeDialog(BuildContext context, String title, String content) async {
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
}
