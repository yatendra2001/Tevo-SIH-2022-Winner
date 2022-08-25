import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_stack/image_stack.dart';
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
      automaticallyImplyLeading: true,
      centerTitle: false,
      pinned: true,
      elevation: 1,
      toolbarHeight: 8.h,
      
      title: Text(
        "30 Days Of Clean Diet 🥗",
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
            "Assigned Tasks",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 12.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Members",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 12.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ]),
      
    );
  }


  List<String> images = [
    "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
    "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=487",
    "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg",
    "https://cxl.com/wp-content/uploads/2016/03/nate_munger.png"
  ];

  List<bool> isCompletedList =[false,false,false,false,false,false,false];

  _buildDashboardView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: ListView.separated(
        
        separatorBuilder: ((context, index) => 
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8),
           if(index!=0) Divider(),
            Text("${index+1} Aug 2022",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500),),
            SizedBox(height: 8)
          ],
        )),
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) {
          return  index!=0 ?
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                        "Closed ${timeago.format(DateTime(2022,8,5))}",
                        style: TextStyle(
                            fontFamily: kFontFamily,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w300,
                            color: kPrimaryBlackColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  ImageStack(
                    imageList: images,
                    totalCount: images.length,
                    imageRadius: 24.sp,
                    imageCount: 2,
                    imageBorderWidth: 0,
                  ),
                ],
              ),
            ): SizedBox.shrink();
          }),
    );
  }

  _buildLeaderBoard() {
    return Container();
  }
}
