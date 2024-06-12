import 'package:dsplus_finance/admin/requests/requests_cubit.dart';
import 'package:dsplus_finance/admin/users/presentaion/users.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_bloc.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/navigator_service.dart';
// import '../presentation/login_page_tab_container_screen/login_page_tab_container_screen.dart';
import '../routes/app_routes.dart';
import 'history/bloc/history_cubit.dart';
import 'requests/admin.dart';
import 'add_user/add_user_cubit.dart';
import 'add_user/add_users.dart';
import 'history/presentation/orders_history.dart';

class AdminHomePage extends StatelessWidget {
  static Widget builder(BuildContext context) {
    return AdminHomePage();
  }

  AdminHomePage({super.key});
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      PrefUtils().clearPreferencesData();

      NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.loginPageTabContainerScreen

          //  MaterialPageRoute(
          //    builder: (context) => loginPageTabContainerScreen(),
          //  ),
          );
      //  Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(
      //      builder: (context) => LoginPageTabContainerScreen(),
      //    ),
      //  );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Admin Dashboard", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        primary: true,
        shrinkWrap: true,
        children: [
          InkWell(
            hoverDuration: Duration(milliseconds: 100),
            splashColor: Colors.grey[200],
            highlightColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AdminRequestsCubit()..fetchData(),
                      child: AdminRequestsView(),
                    ),
                  ));
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              semanticContainer: true,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Requests"),
                subtitle: Text("View all requests"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => UsersBloc()..add(LoadUsers()),
                      child: UsersPage(),
                    ),
                  ));
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Users"),
                subtitle: Text("View all users"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => OrderHistoryCubit()..fetchData(),
                      child: OrderHistoryView(),
                    ),
                  ));
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("History"),
                subtitle: Text("View all transactions"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => AddUserCubit(
                          FirebaseAuth.instance, FirebaseFirestore.instance),
                      child: AddUsers(
                        addUserCubit: AddUserCubit(
                            FirebaseAuth.instance, FirebaseFirestore.instance),
                      ),
                    ),
                  ));
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Add Users"),
                subtitle: Text("Add new users"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
