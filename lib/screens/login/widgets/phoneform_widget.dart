import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tevo/utils/theme_constants.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({
    Key? key,
    this.textColor,
    required this.onSubmit,
    required this.phoneNumberController,
  }) : super(key: key);

  final Color? textColor;
  final TextEditingController phoneNumberController;
  final Function() onSubmit;

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
    return Container(
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            // Palette.darkOrange.withOpacity(0.1),
            // Palette.darkOrange.withOpacity(0.1)
            Colors.transparent,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: Form(
        key: _formKey,
        child: IntlPhoneField(
          onSubmitted: (_) {
            widget.onSubmit();
          },
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: widget.textColor,
              ),
          dropdownIcon: Icon(
            Icons.arrow_drop_down,
            color: widget.textColor ?? Colors.black,
          ),
          cursorColor: Colors.black,
          showCountryFlag: widget.textColor == null,
          textAlignVertical: TextAlignVertical.center,
          dropdownTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: widget.textColor,
              ),
          initialCountryCode: 'IN',
          disableLengthCheck: true,
          controller: widget.phoneNumberController,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            border: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintText: "Phone Number",
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintStyle: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w300, color: widget.textColor),
          ),
          flagsButtonPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        ),
      ),
    );
  }
}
