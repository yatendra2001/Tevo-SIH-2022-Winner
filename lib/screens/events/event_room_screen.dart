import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:tevo/screens/events/event_room_task_screen.dart';
import 'package:tevo/utils/theme_constants.dart';

import '../../models/event_model.dart' as eve;

class EventRoomScreenArgs {
  final eve.Event event;

  const EventRoomScreenArgs({
    required this.event,
  });
}

class EventRoomScreen extends StatefulWidget {
  EventRoomScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  static const routeName = 'eventRoomScreen';
  final eve.Event event;

  static Route route({required EventRoomScreenArgs args}) {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: EventRoomScreen(
        event: args.event,
      ),
    );
  }

  @override
  State<EventRoomScreen> createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  final ScrollController _controller = ScrollController();
  List<Map<String, dynamic>> ls = [];

  @override
  void initState() {
    getDataOfEvent();
    super.initState();
  }

  getDataOfEvent() async {
    final snap = await FirebaseFirestore.instance
        .collection("eventRoomFeed")
        .doc(widget.event.id)
        .collection("eventTasks")
        .orderBy("dateTime", descending: true)
        .get();
    for (var element in snap.docs) {
      ls.add(element.data());
    }
    setState(() {});
  }

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              EventRoomTaskScreen.routeName,
              arguments: EventRoomTaskScreenArgs(
                eventId: widget.event.id!,
              ),
            );
          },
          backgroundColor: kPrimaryBlackColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      toolbarHeight: 8.h,
      title: Text(
        widget.event.eventName,
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

  List<bool> isCompletedList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  _buildDashboardView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 16),
      itemBuilder: (context, index) => Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  ls[index]["senderName"],
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "${ls[index]['task']}",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Image.network(ls[index]["image"]),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await launchURL(context, ls[index]["link"]);
                  },
                  child: Text(
                    ls[index]["link"],
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryBlackColor),
              color: kPrimaryWhiteColor,
            ),
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          Row(
            children: [
              true
                  ? const Icon(LineariconsFree.checkmark_cicle,
                      size: 16, color: kPrimaryBlackColor)
                  : const Icon(Entypo.hourglass, color: kPrimaryBlackColor),
              SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Icon(
                    Icons.arrow_circle_up,
                    size: 36,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text('4 Votes')
                ],
              ),
            ],
          ),
          Spacer()
        ],
      ),
      itemCount: ls.length,
    );
  }

  _buildLeaderBoard() {
    return Container();
  }
}
