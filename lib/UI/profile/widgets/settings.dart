import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_bloc.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_events.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_states.dart';

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
          // settingsItemBuilder(
          //   icon: '',
          //   text: 'mute noti'.tr(),
          //   child: Switch(
          //     value: true,
          //     activeColor: Colors.indigo,
          //     activeTrackColor: Colors.grey.shade200,
          //     onChanged: (bool val) {},
          //   ),
          // ),
          SettingsItemBuilder(
            toDo: (){
              ModalSheets().showLanguagePicker(context);
            },
            icon: '',
            text: 'language'.tr() + ': ${translator.activeLanguageCode.toUpperCase()}',
          ),
          SettingsItemBuilder(
            toDo: (){
              ModalSheets().showTermsAndConditions(context);
            },
            icon: 'privacy',
            text: 'policy and terms'.tr(),
          ),
          SettingsItemBuilder(
            toDo: (){
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
    required this.text, required this.icon, required this.toDo,
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
              : Colors.blue.shade100.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            icon.isEmpty
                ? Container()
                : SvgPicture.asset('assets/images/$icon.svg', fit: BoxFit.scaleDown,),
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
