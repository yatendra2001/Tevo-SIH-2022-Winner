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

  final Map<BottomNavItem, dynamic> items = {
    BottomNavItem.feed: Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
          color: const Color(0xffD8F3F1),
          borderRadius: BorderRadius.circular(8)),
      child: const Icon(
        Icons.home_outlined,
        size: 23,
        color: Color(0xff009688),
      ),
    ),
    BottomNavItem.create: Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          color: Color(0xff009688), borderRadius: BorderRadius.circular(10)),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    ),
    BottomNavItem.notifications: Container(
      height: 38,
      width: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: const Color(0xffD8F3F1),
          borderRadius: BorderRadius.circular(8)),
      child: const Icon(
        Icons.notifications_none_outlined,
        size: 23,
        color: Color(0xff009688),
      ),
    )
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
              bottomNavigationBar: _customisedBottomNavBar(context, state),
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

  _customisedBottomNavBar(context, state) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items
            .map((item, icon) => MapEntry(
                item,
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                      highlightColor: Colors.grey,
                      onTap: () {
                        _selectBottomNavItem(
                            context, item, item == state.selectedItem);
                      },
                      child: icon),
                )))
            .values
            .toList(),
      ),
    );
  }
}
