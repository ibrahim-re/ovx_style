import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:ovx_style/bloc/user_bloc/user_states.dart';
import 'package:provider/src/provider.dart';

class PostsCountriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String countries = SharedPref.getPostsCountries();
    return BlocConsumer<UserBloc, UserState>(
      listener: (ctx, state) {
        if(state is ChangeCountriesLoading)
          EasyLoading.show(status: 'please wait'.tr());
        else if(state is ChangeCountriesFailed){
          EasyLoading.dismiss();
          EasyLoading.showError(state.message);
        }
        else if(state is ChangeCountriesDone){
          EasyLoading.dismiss();
          EasyLoading.showSuccess('success'.tr());
        }
      },
      builder: (ctx, state) {

        if(state is ChangeCountriesDone)
          countries = state.changeTo;

        return GestureDetector(
          onTap: () async {
            if (countries != 'All countries') {
              bool b = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text(
                    'note'.tr(),
                    style: Constants.TEXT_STYLE4,
                  ),
                  content: Text(
                    'default posts countries'.tr(),
                    style: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        NamedNavigatorImpl().pop(result: false);
                      },
                      child: Text(
                        'cancel'.tr(),
                        style:
                        Constants.TEXT_STYLE4.copyWith(color: MyColors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        NamedNavigatorImpl().pop(result: true);
                      },
                      child: Text(
                        'ok'.tr(),
                        style: Constants.TEXT_STYLE4
                            .copyWith(color: MyColors.secondaryColor),
                      ),
                    ),
                  ],
                ),
              );

              if (b)
                context.read<UserBloc>().add(ChangeCountries(CountriesFor.Posts, 'All countries'));
            }
          },
          child: Row(
            children: [
              Text(
                'countries'.tr(),
                style: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
              ),
              Spacer(),
              Text(
                countries,
                style: Constants.TEXT_STYLE6
                    .copyWith(color: MyColors.secondaryColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
