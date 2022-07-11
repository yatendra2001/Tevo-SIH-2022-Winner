import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tevo/screens/login/login_cubit/login_cubit.dart';
import 'package:tevo/utils/theme_constants.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({
    Key? key,
    this.textColor,
    required this.textEditingController,
  }) : super(key: key);

  final Color? textColor;
  final TextEditingController textEditingController;

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    SmsAutoFill().listenForCode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: IntlPhoneField(
        controller: widget.textEditingController,
        focusNode: _focusNode,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: widget.textColor ?? kPrimaryBlackColor,
          fontWeight: FontWeight.w500,
        ),
        dropdownIcon: Icon(
          Icons.arrow_drop_down,
          color: widget.textColor ?? kPrimaryBlackColor,
        ),
        showCountryFlag: widget.textColor == null,
        dropdownTextStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: widget.textColor ?? kPrimaryBlackColor),
        initialCountryCode: 'IN',
        disableLengthCheck: true,
        invalidNumberMessage: "Please Check Your Number",
        validator: (val) {
          if (val == null || val.number.isEmpty) {
            return "Please enter phone number";
          } else if (val.number.length == 10) {
            context.read<LoginCubit>().phone = val.completeNumber;
          } else if (val.number.length > 10) {
            return "Please Check Your Number";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor ?? kPrimaryBlackColor,
              style: BorderStyle.solid,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor ?? kPrimaryBlackColor,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor ?? kPrimaryBlackColor,
              style: BorderStyle.solid,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor ?? kPrimaryBlackColor,
              style: BorderStyle.solid,
            ),
          ),
          filled: true,
          hintText: "Phone Number",
          errorStyle: TextStyle(
            color: Colors.black,
          ),
          hintStyle: TextStyle(
              fontSize: 12.sp,
              color: widget.textColor ?? kPrimaryBlackColor,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
