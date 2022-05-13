import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tevo/enums/enums.dart';
import 'package:tevo/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:tevo/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Color(0xffE5E5E5),
              resizeToAvoidBottomInset: false,
              extendBody: true,
              body: Stack(
                children: items
                    .map((item, _) => MapEntry(
                          item,
                          _buildOffstageNavigator(
                            item,
                            item == state.selectedItem,
                          ),
                        ))
                    .values
                    .toList(),
              ),
              bottomNavigationBar: _customisedBottomNavBar(),
              //  BottomNavBar(
              //   items: items,
              //   selectedItem: state.selectedItem,
              //   onTap: (index) {
              //     final selectedItem = BottomNavItem.values[index];
              //     _selectBottomNavItem(
              //       context,
              //       selectedItem,
              //       selectedItem == state.selectedItem,
              //     );
              //   },
              // ),
            ),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
    bool isSameItem,
  ) {
    if (isSameItem) {
      navigatorKeys[selectedItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffstageNavigator(
    BottomNavItem currentItem,
    bool isSelected,
  ) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }

  _customisedBottomNavBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.home,
              size: 30,
              color: Color(0xffBBBBBB),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_box_rounded,
              size: 30,
              color: Color(0xff009688),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notification_add_outlined,
              size: 30,
              color: Color(0xffBBBBBB),
            ),
          )
        ],
      ),
    );
  }
}
