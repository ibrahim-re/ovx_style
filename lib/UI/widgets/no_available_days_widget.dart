import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/current_package_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';

class NoAvailableDaysWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'no available days'.tr(),
          style: Constants.TEXT_STYLE4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        UpdatePackageButton(
          text: 'update'.tr(),
          icon: SvgPicture.asset('assets/images/update.svg'),
          onTap: () {
            NamedNavigatorImpl().push(NamedRoutes.SUBSCRIPTION_SCREEN);
          },
          color: MyColors.secondaryColor,
        ),
      ],
    );
  }
}
