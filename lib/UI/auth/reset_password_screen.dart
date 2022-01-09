import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:ovx_style/bloc/reset_password_bloc/reset_password_events.dart';
import 'package:ovx_style/bloc/reset_password_bloc/reset_password_states.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class ResetPasswordScreen extends StatelessWidget {
  final navigator;

  const ResetPasswordScreen({this.navigator});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider<ResetPasswordBloc>(
      create: (context) => ResetPasswordBloc(),
      child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordLoading)
            EasyLoading.show(status: 'please wait'.tr());
          else if (state is ResetPasswordFailed)
            EasyLoading.showError(state.message);
          else if(state is ResetPasswordEmailSent){
            EasyLoading.showSuccess('email sent'.tr());
            NamedNavigatorImpl().pop();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 35, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/logo2.png'),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  EnterEmailWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnterEmailWidget extends StatefulWidget {
  @override
  _EnterEmailWidgetState createState() => _EnterEmailWidgetState();
}

class _EnterEmailWidgetState extends State<EnterEmailWidget> {
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ResetPasswordBloc>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'forget it'.tr(),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: MyColors.secondaryColor,
          ),
        ),
        Text(
          'forget desc'.tr(),
          style: Constants.TEXT_STYLE4,
        ),
        SizedBox(
          height: screenHeight * 0.06,
        ),
        CustomTextFormField(
          hint: 'email'.tr(),
          icon: 'person',
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          validateInput: (userInput) {},
          saveInput: (userInput) {
            print(userInput);
          },
        ),
        SizedBox(
          height: screenHeight * 0.03,
        ),
        CustomElevatedButton(
          color: MyColors.secondaryColor,
          text: 'send'.tr(),
          function: () {
            bool validEmail = AuthHelper.isEmailValid(_emailController.text);
            if (validEmail)
              bloc.add(RequestForResetPassword(_emailController.text));
            else
              EasyLoading.showError('enter email'.tr());
          },
        ),
      ],
    );
  }
}


