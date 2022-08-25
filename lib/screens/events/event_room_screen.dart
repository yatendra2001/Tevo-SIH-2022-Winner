import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/user_profile_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventRoomScreen extends StatefulWidget {
  EventRoomScreen({Key? key}) : super(key: key);

  static const routeName = 'eventRoomScreen';

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: EventRoomScreen(),
    );
  }

  @override
  State<EventRoomScreen> createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: _controller,
            clipBehavior: Clip.none,
            headerSliverBuilder: (_, __) {
              return [_buildAppBar()];
            },
            body: TabBarView(
              children: [
                _buildDashboardView(),
                _buildLeaderBoard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      backgroundColor: kPrimaryWhiteColor,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      pinned: true,
      elevation: 1,
      toolbarHeight: 8.h,
      title: Text(
        "120 Days of Coding! 👨‍💻",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: kFontFamily,
          fontSize: 14.sp,
        ),
      ),
      bottom: TabBar(indicatorColor: kPrimaryBlackColor, tabs: [
        Tab(
          child: Text(
            "DashBoard",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 13.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tab(
          child: Text(
            "LeaderBoard",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 13.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 28.0),
          child: Icon(FontAwesomeIcons.users),
        )
      ],
    );
  }

  _buildDashboardView() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, int) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                UserProfileImage(
                    radius: 12.sp,
                    profileImageUrl:
                        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
                    iconRadius: 48),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryBlackColor),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "• Do Codeforce Game Theory Question",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 9.sp),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "• Attend College coding round",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 9.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Closed ${timeago.format(DateTime.now())}",
                      style: TextStyle(
                          fontFamily: kFontFamily,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w300,
                          color: kPrimaryBlackColor.withOpacity(0.7)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _buildLeaderBoard() {
    return Container();
  }
}
