import 'package:dsplus_finance/admin/add_user/cubit/add_user_cubit.dart';
import 'package:dsplus_finance/admin/add_user/widgets/text_field.dart';
import 'package:flutter/material.dart';

class FormFields extends StatefulWidget {
  final AddUserCubit addUserCubit;

  const FormFields({Key? key, required this.addUserCubit}) : super(key: key);

  @override
  _FormFieldsState createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();
  String _selectedRole = 'User';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormFieldWidget(
            controller: _userNameController,
            labelText: "User name",
            hintText: "Enter User name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a User name';
              }
              return null;
            },
            onFieldSubmitted: (_) => _addUser(context),
          ),
          SizedBox(height: 10),
          TextFormFieldWidget(
            controller: _nameController,
            labelText: "Name",
            hintText: "Enter name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onFieldSubmitted: (_) => _addUser(context),
          ),
          SizedBox(height: 10),
          TextFormFieldWidget(
            controller: _emailController,
            labelText: "Email",
            hintText: "Enter email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onFieldSubmitted: (_) => _addUser(context),
          ),
          SizedBox(height: 10),
          TextFormFieldWidget(
            controller: _passwordController,
            labelText: "Password",
            hintText: "Enter password",
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            onFieldSubmitted: (_) => _addUser(context),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            onChanged: (newValue) {
              setState(() {
                _selectedRole = newValue!;
              });
            },
            items: ['User', 'Admin']
                .map((role) => DropdownMenuItem(
              child: Text(role),
              value: role,
            ))
                .toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: "Role",
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _addUser(context),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              fixedSize: MaterialStateProperty.all(Size(200, 50)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(
              "Add User",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addUser(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _selectedRole;
    final userName = _userNameController.text;


    widget.addUserCubit.addUser(name, email, password, role, userName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User added successfully!'),
      ),
    );
    Navigator.pop(context);

    // Clearing form fields
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _userNameController.clear();
  }
}