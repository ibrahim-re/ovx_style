import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/UI/widgets/guest_sign_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_bloc.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_state.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'current_package_widget.dart';
import 'package:ovx_style/model/package.dart';
class SubscriptionSection extends StatefulWidget {
  const SubscriptionSection({Key? key}) : super(key: key);

  @override
  State<SubscriptionSection> createState() => _SubscriptionSectionState();
}

class _SubscriptionSectionState extends State<SubscriptionSection> {
  late final userType;
  @override
  void initState() {
    userType = SharedPref.getUser().userType;
    if (userType != UserType.Guest.toString())
      context.read<PackagesBloc>().add(GetCurrentPackage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: MyColors.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/images/subscription.svg'),
              const SizedBox(
                width: 8,
              ),
              Text(
                'subscription'.tr(),
                style: Constants.TEXT_STYLE4,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          userType != UserType.Guest.toString()
              ? BlocBuilder<PackagesBloc, PackagesState>(
                  builder: (ctx, state) {
                    if (state is GetCurrentPackageFailed)
                      return Center(
                        child: Text(
                          state.message,
                          style: Constants.TEXT_STYLE6,
                        ),
                      );
                    else if (state is GetCurrentPackageLoading || state is PackagesInitialState)
                      return Center(
                        child: RefreshProgressIndicator(
                          color: MyColors.secondaryColor,
                        ),
                      );
                    else {
                      Package? package = context.read<PackagesBloc>().currentPackage;
                      return package != null ? CurrentPackageWidget(
                        package: package,
                      ) : Container();
                    }
                  },
                )
              : Center(
                  child: Column(
                    children: [
                      Text(
                        'sign in to subscribe'.tr(),
                        style: Constants.TEXT_STYLE6,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GuestSignWidget(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
