import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ovx_style/UI/auth/widgets/password_text_field.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/login_bloc/login_bloc.dart';
import 'package:ovx_style/bloc/login_bloc/login_events.dart';
import 'package:ovx_style/bloc/login_bloc/login_states.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading)
          EasyLoading.show(status: 'please wait'.tr());
        else if (state is LoginSucceed) {
          EasyLoading.dismiss();
          NamedNavigatorImpl().push(NamedRoutes.HOME_SCREEN, clean: true);
        } else if (state is LoginFailed) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.message);
        }
      },
      child: Form(
        key: _signInFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              controller: _emailController,
              hint: 'email'.tr(),
              icon: 'person',
              keyboardType: TextInputType.emailAddress,
              validateInput: (userInput) {
                bool validEmail = AuthHelper.isEmailValid(userInput);
                if (validEmail)
                  return null;
                else
                  return 'enter email'.tr();
              },
              saveInput: (userInput) {
                print(userInput);
              },
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            PasswordTextField(
              controller: _passwordController,
              validateInput: (userInput) {
                if (userInput == "")
                  return 'enter password'.tr();
                else if (userInput.toString().length < 6)
                  return 'password short'.tr();
                return null;
              },
              saveInput: (userInput) {
                print(userInput);
              },
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            CustomElevatedButton(
              color: MyColors.secondaryColor,
              text: 'login'.tr(),
              function: () {
                bool isSubmitted = AuthHelper.submitLoginForm(_signInFormKey);
                if (isSubmitted)
                  bloc.add(LoginButtonPressed(
                      _emailController.text, _passwordController.text));
              },
            ),
          ],
        ),
      ),
    );
  }
}
