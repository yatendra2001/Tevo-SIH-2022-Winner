import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/utils/theme_constants.dart';

Future<dynamic> customBottomSheet(BuildContext context, Widget child,
    {String? key}) async {
  return showModalBottomSheet(
      backgroundColor: kPrimaryWhiteColor,
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (ctx) {
        return CustomBottomSheetWidget(
          key: GlobalObjectKey(key ?? 'custom-bottom-sheet'),
          child: child,
        );
      });
}

class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 75.0.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 5,
          ),
          child,
        ],
      ),
    );
  }
}
