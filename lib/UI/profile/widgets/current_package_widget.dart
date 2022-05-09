import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_bloc.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/model/package.dart';
import 'package:provider/src/provider.dart';

class CurrentPackageWidget extends StatelessWidget {
  final Package package;

  CurrentPackageWidget({required this.package});
  @override
  Widget build(BuildContext context) {
    //if it's free package
    if (package.packageName == 'Free Package')
      return Expanded(
        child: Column(
          children: [
            CurrentPackageText(
               text: 'current package is'.tr() + ':',
              packageName: package.packageName!,
            ),
            const SizedBox(
              height: 8,
            ),
            UpdatePackageButton(
              icon: SvgPicture.asset('assets/images/update.svg'),
              color: MyColors.secondaryColor,
              onTap: () async {
                bool isBack = await NamedNavigatorImpl().push(NamedRoutes.SUBSCRIPTION_SCREEN);
                if(isBack){
                  //get the current context to re fetch notifications
                  BuildContext ctx = NamedNavigatorImpl.navigatorState.currentContext!;
                  ctx.read<PackagesBloc>().add(GetCurrentPackage());
                }
              },
              text: 'update'.tr(),
            ),
          ],
        ),
      );

    //if package is expired
    else if (package.expires == 0)
      return Column(
        children: [
          CurrentPackageText(
            text: 'package is done'.tr(),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UpdatePackageButton(
                text: 'renew'.tr(),
                color: MyColors.yellow,
                icon: SvgPicture.asset('assets/images/renew.svg'),
                onTap: () async {
                  bool isBack = await NamedNavigatorImpl().push(NamedRoutes.SUBSCRIPTION_SCREEN);
                  if(isBack){
                    //get the current context to re fetch notifications
                    BuildContext ctx = NamedNavigatorImpl.navigatorState.currentContext!;
                    ctx.read<PackagesBloc>().add(GetCurrentPackage());
                  }
                },
              ),
              UpdatePackageButton(
                icon: SvgPicture.asset('assets/images/update.svg'),
                onTap: () async {
                  bool isBack = await NamedNavigatorImpl().push(NamedRoutes.SUBSCRIPTION_SCREEN);
                  if(isBack){
                    //get the current context to re fetch notifications
                    BuildContext ctx = NamedNavigatorImpl.navigatorState.currentContext!;
                    ctx.read<PackagesBloc>().add(GetCurrentPackage());
                  }
                  },
                color: MyColors.secondaryColor,
                text: 'update'.tr(),
              ),
            ],
          ),
        ],
      );

    //if package is active
    else
      return Column(
        children: [
          CurrentPackageText(
            text: 'current package is'.tr() + ':',
            packageName: package.packageName!,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'expires in'.tr() + ': ',
                style: Constants.TEXT_STYLE6,
              ),
              Text(
                '${package.expires} ' + 'days'.tr(),
                style: Constants.TEXT_STYLE9.copyWith(fontSize: 16),
              ),
            ],
          ),
          UpdatePackageButton(
            icon: SvgPicture.asset('assets/images/update.svg'),
            onTap: () async {
              bool isBack = await NamedNavigatorImpl().push(NamedRoutes.SUBSCRIPTION_SCREEN);
              if(isBack){
                //get the current context to re fetch notifications
                BuildContext ctx = NamedNavigatorImpl.navigatorState.currentContext!;
                ctx.read<PackagesBloc>().add(GetCurrentPackage());
              }
            },
            color: MyColors.secondaryColor,
            text: 'update'.tr(),
          ),
        ],
      );
  }
}

class CurrentPackageText extends StatelessWidget {
  final String text;
  final String packageName;

  CurrentPackageText({required this.text, this.packageName = ''});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.lightBlue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: Constants.TEXT_STYLE6.copyWith(color: MyColors.secondaryColor),
          ),
          const SizedBox(width: 4,),
          if(packageName.isNotEmpty)
            Text(
            packageName.tr(),
            style: Constants.TEXT_STYLE6,
          ),
        ],
      ),
    );
  }
}

class UpdatePackageButton extends StatelessWidget {
  final text;
  final icon;
  final onTap;
  final color;

  UpdatePackageButton(
      {required this.text, required this.icon, required this.onTap, required this.color});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: 125,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon,
            Text(
              text,
              style: Constants.TEXT_STYLE6.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
