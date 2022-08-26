import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'package:tevo/helpers/helpers.dart';
import 'package:tevo/repositories/repositories.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/custom_appbar.dart';

class EventRoomTaskScreenArgs {
  final String eventId;

  EventRoomTaskScreenArgs({
    required this.eventId,
  });
}

class EventRoomTaskScreen extends StatefulWidget {
  static const routeName = '/eventroomtaskscreen';
  final String eventId;

  static Route route({required EventRoomTaskScreenArgs args}) {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: EventRoomTaskScreen(eventId: args.eventId),
    );
  }

  const EventRoomTaskScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<EventRoomTaskScreen> createState() => _EventRoomTaskScreenState();
}

class _EventRoomTaskScreenState extends State<EventRoomTaskScreen> {
  String profileImageUrl = '';
  final taskController = TextEditingController();
  final linkController = TextEditingController();
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                _buildContainer(),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    _selectProfileImage(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: kPrimaryWhiteColor,
                    width: double.infinity,
                    child: profileImageUrl == ''
                        ? Row(
                            children: [
                              Text(
                                "Upload Image",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              Spacer(),
                              Icon(Icons.upload)
                            ],
                          )
                        : Image.network(profileImageUrl),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: linkController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      label: Text("Link"),
                      suffixIcon: Icon(
                        Icons.link,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("eventRoomFeed")
                        .doc(widget.eventId)
                        .collection("eventTasks")
                        .doc()
                        .set({
                      "task": taskController.text,
                      "link": linkController.text,
                      "image": profileImageUrl,
                      "userId": SessionHelper.uid,
                      "dateTime": DateTime.now(),
                      "senderName": SessionHelper.displayName,
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(primary: kPrimaryBlackColor),
                )
              ],
            ),
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
        controller: taskController,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text("Task"),
        ),
        minLines: 2,
        maxLines: 10,
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Profile Image',
    );
    if (pickedFile != null) {
      profileImageUrl =
          await context.read<StorageRepository>().uploadProfileImage(
                url: '',
                image: pickedFile,
              );
      setState(() {});
    }
  }
}
