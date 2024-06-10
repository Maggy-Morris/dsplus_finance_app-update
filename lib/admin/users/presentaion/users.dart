import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_bloc.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_state.dart';
import 'package:dsplus_finance/admin/users/presentaion/widgets/user_container.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Implement your logic for adding a new user
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserContainer(
                title: 'Admins',
                users: state.admins,
                isAdmin: true,
                bloc: context.read<UsersBloc>(),
              ),
              SizedBox(height: 10),
              UserContainer(
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
