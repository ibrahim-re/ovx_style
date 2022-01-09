import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/UI/intro/intro_screen.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/login_bloc/login_bloc.dart';
import 'package:ovx_style/bloc/login_bloc/login_states.dart';
import 'package:ovx_style/helper/helper.dart';

class SplashScreen extends StatefulWidget {
  final navigator;

  const SplashScreen({this.navigator});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Helper.customizeEasyLoading();
    // Future.delayed(Duration(seconds: 3)).then((_) {
    //   NamedNavigatorImpl().push(NamedRoutes.INTRO_SCREEN, replace: true);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state){
        if(state is LoginSucceed){
          print('user logged in ${SharedPref.currentUser.userName}');
          Future.delayed(Duration(seconds: 3)).then((_) {
            NamedNavigatorImpl().push(NamedRoutes.HOME_SCREEN, replace: true);
          });
        } else {
          print('no user logged in');
          Future.delayed(Duration(seconds: 3)).then((_) {
            NamedNavigatorImpl().push(NamedRoutes.INTRO_SCREEN, replace: true);
          });
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.secondaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
