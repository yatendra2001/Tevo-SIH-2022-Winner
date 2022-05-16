import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({
    Key? key,
    this.textColor,
    required this.phoneNumberController,
  }) : super(key: key);

  final Color? textColor;
  final TextEditingController phoneNumberController;

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: IntlPhoneField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: widget.textColor ?? Colors.black),
        dropdownIcon: Icon(
          Icons.arrow_drop_down,
          color: widget.textColor ?? Colors.black,
        ),
        showCountryFlag: widget.textColor == null,
        dropdownTextStyle:
            TextStyle(fontSize: 15, color: widget.textColor ?? Colors.black),
        initialCountryCode: 'IN',
        disableLengthCheck: true,
        onChanged: (value) {
          if (value.number.length == 10) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
          setState(() {
            widget.phoneNumberController.text = value.completeNumber;
          });
        },
        validator: (val) {
          if (val == null || val.number.isEmpty) {
            return "Please enter your phone number";
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor ?? Colors.black,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.textColor ?? Colors.black,
              style: BorderStyle.solid,
            ),
          ),
          filled: true,
          hintText: "Phone Number",
          hintStyle: TextStyle(
              fontSize: 15.0, color: widget.textColor ?? Colors.black),
        ),
      ),
    );
  }
}
