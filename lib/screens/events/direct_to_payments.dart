import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/screens/login/widgets/standard_elevated_button.dart';
import 'package:tevo/utils/theme_constants.dart';
import 'package:tevo/widgets/custom_appbar.dart';

class DirectToPayments extends StatefulWidget {
  static const routeName = 'directToPayments';

  DirectToPayments({Key? key}) : super(key: key);

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: DirectToPayments(),
    );
  }

  @override
  State<DirectToPayments> createState() => _DirectToPaymentsState();
}

class _DirectToPaymentsState extends State<DirectToPayments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar('Payments'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "UPI Payment",
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  color: kPrimaryWhiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: kPrimaryBlackColor,
                  )),
              child: TextField(
                decoration: InputDecoration(
                  label: Text("Enter  UPI ID"),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Verify'),
                style: ElevatedButton.styleFrom(primary: kPrimaryBlackColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
