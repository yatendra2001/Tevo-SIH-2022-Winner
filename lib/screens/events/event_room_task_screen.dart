import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/custom_appbar.dart';

class EventRoomTaskScreen extends StatefulWidget {
  static const routeName = '/eventroomtaskscreen';

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: const EventRoomTaskScreen(),
    );
  }

  const EventRoomTaskScreen({Key? key}) : super(key: key);

  @override
  State<EventRoomTaskScreen> createState() => _EventRoomTaskScreenState();
}

class _EventRoomTaskScreenState extends State<EventRoomTaskScreen> {
  List<Widget> ls = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_sharp)),
          title: Text(
            "Create Task",
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              _buildContainer(),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: kPrimaryWhiteColor,
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      "Upload Image",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Spacer(),
                    Icon(Icons.upload)
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    label: Text("Link"),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(primary: kPrimaryBlackColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text("Task"),
        ),
      ),
    );
  }
}
