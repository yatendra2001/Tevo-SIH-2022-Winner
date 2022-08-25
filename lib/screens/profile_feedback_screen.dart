import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tevo/repositories/post/post_repository.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:timelines/timelines.dart';

import '../utils/theme_constants.dart';

class ProflileFeedbackScreen extends StatefulWidget {
  static const routeName = "profilefeedbackscreen";

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: ProflileFeedbackScreen(),
    );
  }

  ProflileFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<ProflileFeedbackScreen> createState() => _ProflileFeedbackScreenState();
}

class _ProflileFeedbackScreenState extends State<ProflileFeedbackScreen> {
  List<Map<String, dynamic>> ls = [];

  @override
  void initState() {
    getAllFeedback();
    super.initState();
  }

  getAllFeedback() async {
    ls = await context
        .read<PostRepository>()
        .getAllFeedback(userId: SessionHelper.uid!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Timeline.tileBuilder(
              theme: TimelineThemeData(
                  connectorTheme: ConnectorThemeData(
                indent: 1,
                thickness: 3,
              )),
              shrinkWrap: true,
              builder: TimelineTileBuilder.connected(
                itemCount: 3,
                contentsBuilder: (context, index) => Container(
                  child: Text(DateTime.now().toString()),
                ),
                oppositeContentsBuilder: (context, index) => Container(
                  child: Text("Ruchir OP"),
                ),
                indicatorBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getCompletionRateColor(30),
                      )),
                  child: Text("30%"),
                ),
                connectionDirection: ConnectionDirection.before,
                connectorBuilder: (context, index, type) => SolidLineConnector(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  _getCompletionRateColor(double completionRate) {
    return completionRate >= 100
        ? kPrimaryVioletColor
        : completionRate >= 78
            ? kPrimaryTealColor
            : (completionRate < 20 ? kPrimaryRedColor : kSecondaryYellowColor);
  }
}
