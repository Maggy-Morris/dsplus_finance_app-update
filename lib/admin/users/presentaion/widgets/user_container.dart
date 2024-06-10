import 'package:dsplus_finance/admin/users/presentaion/widgets/user_model.dart';
import 'package:flutter/material.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_bloc.dart';

import '../../user_bloc/users_event.dart'; // Import the User model

class UserContainer extends StatelessWidget {
  final String title;
  final List<User> users;
  final bool isAdmin;
  final UsersBloc bloc;

  const UserContainer({
    required this.title,
    required this.users,
    required this.isAdmin,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isAdmin ? Colors.blue[100] : Colors.green[100],
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
                  Text(user.role),
                ],
              ),
              dense: true,
              trailing: isAdmin
                  ? null
                  : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => bloc.add(DeleteUser(user.id)),
              ),
              onTap: isAdmin
                  ? null
                  : () async {
                bool isAdmin = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Change User Role'),
                      content: Text('Do you want to make this user an admin?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Make Admin'),
                        ),
                      ],
                    );
                  },
                );

                if (isAdmin) {
                  bloc.add(MakeAdmin(user.id));
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
