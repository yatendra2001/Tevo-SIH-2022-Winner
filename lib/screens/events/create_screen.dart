import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/models/event_model.dart';
import 'package:tevo/repositories/event/event_repository.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/session_helper.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/widgets.dart';

class CreateEventScreen extends StatefulWidget {
  CreateEventScreen({Key? key}) : super(key: key);
  static const routeName = 'createEvent';

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.bottomToTop,
      child: CreateEventScreen(),
    );
  }

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  String code = "XXXXXX";
  final eventName = TextEditingController();
  final joiningAmount = TextEditingController(text: "1000");
  final description = TextEditingController();

  @override
  void initState() {
    randomNumberGenerator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () async => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: kPrimaryBlackColor, fontSize: 12.sp),
                        ),
                      ),
                      Spacer(),
                      Text("NEW EVENT",
                          style: TextStyle(
                              color: kPrimaryBlackColor, fontSize: 14.sp)),
                      Spacer(),
                      submitting == false
                          ? GestureDetector(
                              onTap: submit,
                              child: Text("Publish",
                                  style: TextStyle(
                                      color: kPrimaryBlackColor,
                                      fontSize: 12.sp)),
                            )
                          : CircularProgressIndicator()
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryWhiteColor,
                      border: Border.all(color: kPrimaryBlackColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          controller: eventName,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Event Name"),
                              labelStyle: TextStyle(
                                  color: kPrimaryBlackColor.withOpacity(0.65),
                                  fontWeight: FontWeight.w500),
                              hintStyle: TextStyle(color: kPrimaryBlackColor),
                              contentPadding: EdgeInsets.all(8)),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryWhiteColor,
                      border: Border.all(color: kPrimaryBlackColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _selectStartDate(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                "Start Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: kPrimaryBlackColor),
                              ),
                              Spacer(),
                              Text(
                                DateFormat().format(startDate),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: kPrimaryBlackColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: () {
                            _selectEndDate(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                "End Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: kPrimaryBlackColor),
                              ),
                              Spacer(),
                              Text(
                                DateFormat().format(endDate),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: kPrimaryBlackColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryWhiteColor,
                      border: Border.all(color: kPrimaryBlackColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.all(16),
                    child: Row(children: [
                      Text(
                        "Joining Amount",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                            color: kPrimaryBlackColor),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 10.w,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4), //only 6 digit
                          ],
                          controller: joiningAmount,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Image.network(
                        "https://cdn-icons-png.flaticon.com/512/1369/1369897.png",
                        scale: 20,
                      )
                    ]),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: kPrimaryWhiteColor,
                        border: Border.all(color: kPrimaryBlackColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        maxLines: 4,
                        minLines: 4,
                        controller: description,
                        decoration: InputDecoration(
                          label: Text("Description"),
                          labelStyle: TextStyle(
                              color: kPrimaryBlackColor.withOpacity(0.65),
                              fontWeight: FontWeight.w500),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(4),
                        ),
                      )),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimaryWhiteColor,
                      border: Border.all(color: kPrimaryBlackColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      code,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "*With this code other people will be able to join",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      )),
                  SizedBox(
                    height: 3.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool submitting = false;
  void submit() async {
    if (eventName.text.isEmpty ||
        joiningAmount.text.isEmpty ||
        description.text.isEmpty) {
      flutterToast(msg: "Please fill all the text fields");
    } else if (submitting == false) {
      setState(() {
        submitting = true;
      });
      await EventRepository()
          .createEvent(
            event: Event(
              memberIds: [SessionHelper.uid!],
              id: null,
              description: description.text,
              startDate: startDate,
              creatorId: SessionHelper.uid!,
              endDate: endDate,
              roomCode: code,
              joiningAmount: int.parse(joiningAmount.text),
            ),
          )
          .then((value) => flutterToast(msg: "Event Created"));
      setState(() {
        submitting = false;
      });
      Navigator.of(context).pop();
    }
  }

  void randomNumberGenerator() {
    var rnd = Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    code = next.toInt().toString();
    setState(() {});
  }

  Future _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      startDate = picked;
      if (endDate.difference(startDate).inDays < 1) {
        endDate = startDate.add(Duration(days: 1));
      }
      setState(() {});
    }
  }

  Future _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.add(Duration(days: 1)),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: startDate.add(Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      endDate = picked;
      setState(() {});
    }
  }
}
