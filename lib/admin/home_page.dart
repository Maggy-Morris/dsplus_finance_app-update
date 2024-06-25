import 'package:dsplus_finance/admin/requests/cubit/requests_cubit.dart';
import 'package:dsplus_finance/admin/users/presentaion/users.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_bloc.dart';
import 'package:dsplus_finance/admin/users/user_bloc/users_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/navigator_service.dart';

import '../routes/app_routes.dart';
import 'history/bloc/history_cubit.dart';
import 'requests/requests.dart';
import 'add_user/cubit/add_user_cubit.dart';
import 'add_user/add_users.dart';
import 'history/presentation/orders_history.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.loginPageTabContainerScreen
          );
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
      body: BlocProvider(
        create: (context) => AdminRequestsCubit(),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio:
                3 / 5, // Adjust the aspect ratio to fit your design
          ),
          itemCount: 4,
          // Total number of items in the grid
          itemBuilder: (context, index) {
            return InkWell(
              hoverDuration: Duration(milliseconds: 100),
              splashColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => AdminRequestsCubit(),
                        child: AdminRequestsView(),
                      ),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => UsersBloc()..add(LoadUsers()),
                          ),
                          BlocProvider(
                            create: (context) => AddUserCubit(
                                FirebaseAuth.instance,
                                FirebaseFirestore.instance),
                          ),
                        ],
                        child: UsersPage(
                          addUserCubit: AddUserCubit(FirebaseAuth.instance,
                              FirebaseFirestore.instance),
                        ),
                      ),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OrderHistoryCubit(),
                        child: OrderHistoryView(),
                      ),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => AddUserCubit(
                            FirebaseAuth.instance, FirebaseFirestore.instance),
                        child: AddUsers(
                          addUserCubit: AddUserCubit(FirebaseAuth.instance,
                              FirebaseFirestore.instance),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                semanticContainer: true,
                margin: EdgeInsets.all(10),
                child: (index == 0)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: StreamBuilder(
                                  stream: context
                                      .read<AdminRequestsCubit>()
                                      .numberOfRequests(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && (snapshot.data != 0) && (snapshot.data != null)) {
                                      return SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Badge(
                                          backgroundColor:
                                              Colors.red.withOpacity(0.6),
                                          alignment: Alignment.topRight,
                                          label: (snapshot.data! <= 99)? Text(
                                            snapshot.data.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ): Text(
                                            "99",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Badge(
                                          backgroundColor:
                                          Colors.red.withOpacity(0.6),
                                          alignment: Alignment.topRight,
                                          label: Text(
                                            "0",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          ListTile(
                            title: Text(_getTitle(index)),
                            subtitle: Text(_getSubtitle(index)),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          Spacer(
                            flex: 6,
                          )
                        ],
                      )
                    : Center(
                        child: ListTile(
                          title: Text(_getTitle(index)),
                          subtitle: Text(_getSubtitle(index)),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Requests";
      case 1:
        return "Users";
      case 2:
        return "History";
      case 3:
        return "Add Users";
      default:
        return "";
    }
  }

  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return "View all requests";
      case 1:
        return "View all users";
      case 2:
        return "View all transactions";
      case 3:
        return "Add new users";
      default:
        return "";
    }
  }
}
