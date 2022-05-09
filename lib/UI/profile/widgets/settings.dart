import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_bloc.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_events.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_states.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:ovx_style/bloc/user_bloc/user_states.dart';

import 'currency_picker.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsItemBuilder(
            icon: 'settings',
            text: 'settings'.tr(),
            toDo: null,
          ),
          CurrencyPicker(),
          SettingsItemBuilder(
            toDo: () {
              ModalSheets().showLanguagePicker(context);
            },
            icon: '',
            text: 'language'.tr() + ': ${translator.activeLanguageCode.toUpperCase()}',
          ),
          BlocListener<UserBloc, UserState>(
            listener: (ctx, state) {
              if(state is ChangeUserLocationLoading)
                EasyLoading.show(status: 'please wait'.tr());
              else if(state is ChangeUserLocationDone){
                EasyLoading.dismiss();
                EasyLoading.showSuccess('success'.tr());
              }else if(state is ChangeUserLocationFailed){
                EasyLoading.dismiss();
                EasyLoading.showError(state.message);
              }
            },
            child: SettingsItemBuilder(
              toDo: (){
                NamedNavigatorImpl().push(NamedRoutes.GOOGLE_MAPS_SCREEN, arguments: {
                  'onSave': (latitude, longitude, country) {
                    context.read<UserBloc>().add(ChangeUserLocation(latitude, longitude, country));
                  },
                });
              },
              icon: 'location',
              text: 'location on map'.tr(),
            ),
          ),
          if (SharedPref.getUser().userType != UserType.Guest.toString())
            MyPrivacyPolicyWidget(),
          SettingsItemBuilder(
            toDo: () {
              NamedNavigatorImpl().push(NamedRoutes.HELP_SCREEN);
            },
            icon: 'help',
            text: 'help'.tr(),
          ),
          BlocProvider.value(
            value: BlocProvider.of<LogoutBloc>(context),
            child: BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutLoading)
                  EasyLoading.show();
                else if (state is LogoutSucceed) {
                  EasyLoading.dismiss();
                  NamedNavigatorImpl()
                      .push(NamedRoutes.AUTH_OPTIONS_SCREEN, clean: true);
                } else if (state is LogoutFailed)
                  EasyLoading.showError(state.message);
              },
              child: SettingsItemBuilder(
                toDo: () {
                  context.read<LogoutBloc>().add(LogoutButtonPressed());
                },
                icon: 'logout',
                text: 'logout'.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItemBuilder extends StatelessWidget {
  SettingsItemBuilder({
    required this.text,
    required this.icon,
    required this.toDo,
  });

  final String icon;
  final String text;
  final toDo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toDo,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: text == 'settings'.tr()
              ? Colors.white
              : MyColors.lightBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            icon.isEmpty
                ? Container()
                : SvgPicture.asset(
                    'assets/images/$icon.svg',
                    fit: BoxFit.scaleDown,
                    color: MyColors.secondaryColor,
                  ),
            const SizedBox(width: 10),
            Text(
              text,
              style: Constants.TEXT_STYLE4,
            ),
          ],
        ),
      ),
    );
  }
}

class MyPrivacyPolicyWidget extends StatefulWidget {
  @override
  _MyPrivacyPolicyWidgetState createState() => _MyPrivacyPolicyWidgetState();
}

class _MyPrivacyPolicyWidgetState extends State<MyPrivacyPolicyWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context
        .read<UserBloc>()
        .add(GetUserPrivacyPolicy(SharedPref.getUser().id!));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsItemBuilder(
      toDo: () {
        ModalSheets().showUserPolicySheet(context, SharedPref.getUser().id!,
            controller: controller);
      },
      icon: 'privacy',
      text: 'policy and terms'.tr(),
    );
  }
}
