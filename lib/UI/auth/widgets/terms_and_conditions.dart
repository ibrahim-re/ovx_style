import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool _currentValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            activeColor: MyColors.secondaryColor.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: MyColors.lightGrey, width: 1),
            ),
            value: _currentValue,
            onChanged: (newVal) {
              setState(
                    () {
                  _currentValue = newVal ?? false;
                },
              );
              AuthHelper.agreedOnTerms = _currentValue;
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showTermsAndConditions(context);
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'i agree'.tr(),
                    style: Constants.TEXT_STYLE1.copyWith(fontSize: 17),
                  ),
                  TextSpan(
                    text: 'terms'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MyColors.secondaryColor,
                    ),
                  ),
                  TextSpan(
                    text: 'of using the app'.tr(),
                    style: Constants.TEXT_STYLE1.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showTermsAndConditions(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  'terms and conds'.tr(),
                  style: Constants.TEXT_STYLE1,
                ),
              ),
            ),
          );
        });
  }
}
