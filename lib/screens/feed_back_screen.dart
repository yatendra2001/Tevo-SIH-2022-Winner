import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

class FeedBackScreen extends StatefulWidget {
  FeedBackScreen({Key? key}) : super(key: key);
  static const routeName = 'feedbackScreen';

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: FeedBackScreen(),
    );
  }

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Feedback",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Spacer(),
                    Icon(Icons.send)
                  ],
                ),
                Divider(thickness: 2),
                TextField(
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kPrimaryBlackColor.withOpacity(0.2),
                      ),
                      hintText: "What do you feel about the task today"),
                ),
                Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                      _buildCard("It went well"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildCard(String text) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryBlackColor),
        color: Colors.grey[300],
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.sp),
      ),
    );
  }
}
