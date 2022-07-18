import 'package:flutter/material.dart';
import 'package:tevo/utils/theme_constants.dart';

customAppbar(String title) {
  return AppBar(
    title: Text(
      title,
    ),
    automaticallyImplyLeading: false,
    leading: BackButton(),
    elevation: 0,
    centerTitle: true,
  );
}

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      alignment: Alignment.center,
      icon: Icon(
        Icons.arrow_back_ios_new_outlined,
        size: 22,
      ),
    );
  }
}
