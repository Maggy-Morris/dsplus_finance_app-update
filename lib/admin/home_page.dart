import 'package:dsplus_finance/admin/requests/cubit/requests_cubit.dart';
import 'package:dsplus_finance/admin/requests/cubit/requests_state.dart';
import 'package:dsplus_finance/admin/users/cubit/users_cubit.dart';
import 'package:dsplus_finance/admin/users/presentaion/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/utils/navigator_service.dart';
import '../presentation/home_page/bloc/home_bloc.dart';
import '../presentation/home_page/widgets/my_drawer_widget.dart';
import '../routes/app_routes.dart';
import 'history/bloc/history_cubit.dart';
import 'requests/requests.dart';
import 'add_user/cubit/add_user_cubit.dart';
import 'add_user/add_users.dart';
import 'history/presentation/orders_history.dart';

class AdminHomePage extends StatelessWidget {
  static Widget builder(BuildContext context) {
    return AdminHomePage();
  }

  AdminHomePage({super.key});

  final GlobalKey<ScaffoldState> _foldKey = GlobalKey<ScaffoldState>();

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      NavigatorService.pushNamedAndRemoveUntil(
          AppRoutes.loginPageTabContainerScreen);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<AdminRequestsCubit>().numberOfRequests();
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          key: _foldKey,
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            title:
                const Text("Admin Dashboard", style: TextStyle(fontSize: 20)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _foldKey.currentState?.openDrawer();
              },
            ),
          ),
          drawer: MyDrawer(
              name: state.userModel?.name ?? "",
              imageUrl: state.userModel?.image ?? '',
              parentContext: context),
          body: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 3 / 5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return DashboardCard(
                index: index,
                onTap: () => _navigateToPage(context, index),
                title: _getTitle(index),
                subtitle: _getSubtitle(index),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AdminRequestsCubit()..fetchMoreData(),
              child: AdminRequestsView(),
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => UsersCubit()..currentUserRole(),
                ),
              ],
              child: UsersPage(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => OrderHistoryCubit(),
              child: OrderHistoryView(),
            ),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AddUserCubit(),
              child: AddUsers(),
            ),
          ),
        );
        break;
    }
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

class DashboardCard extends StatelessWidget {
  final int index;
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  const DashboardCard({
    Key? key,
    required this.index,
    required this.onTap,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverDuration: const Duration(milliseconds: 100),
      splashColor: Colors.grey[200],
      highlightColor: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (index == 0) ...[
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.request_page, size: 50),
                    BlocBuilder<AdminRequestsCubit, AdminRequestsState>(
                      builder: (context, state) {
                        return SizedBox(
                          height: 40,
                          width: 35,
                          child: Badge(
                            backgroundColor: Colors.red.withOpacity(.8),
                            textColor: Colors.white,
                            label: (state.numberOfRequests >= 99)
                                ? const Text("99+",
                                    style: TextStyle(fontSize: 15))
                                : Text("${state.numberOfRequests}",
                                    style: const TextStyle(fontSize: 15)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ] else ...[
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_getIcon(index), size: 50),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
            ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Spacer(flex: 6),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.request_page;
      case 1:
        return Icons.person;
      case 2:
        return Icons.history;
      case 3:
        return Icons.person_add;
      default:
        return Icons.error;
    }
  }
}
