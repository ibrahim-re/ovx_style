import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/package_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_bloc.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_state.dart';
import 'package:ovx_style/model/package.dart';
import 'package:provider/src/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  final navigator;

  const SubscriptionScreen({Key? key, this.navigator}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    context.read<PackagesBloc>().add(GetAllPackages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            NamedNavigatorImpl().pop(result: true);
          },
          color: MyColors.secondaryColor,
        ),
        title: Text('subscription'.tr()),
      ),
      body: BlocBuilder<PackagesBloc, PackagesState>(
        builder: (ctx, state) {
          if (state is GetAllPackagesFailed)
            return Center(
              child: Text(
                state.message,
                style: Constants.TEXT_STYLE4,
                textAlign: TextAlign.center,
              ),
            );
          else if (state is GetAllPackagesLoading ||
              state is PackagesInitialState)
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.secondaryColor,
              ),
            );
          else {
            List<Package> packages = context.read<PackagesBloc>().packages;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.separated(
                itemCount: packages.length,
                separatorBuilder: (ctx, index) => const SizedBox(
                  height: 12,
                ),
                itemBuilder: (ctx, index) => PackageWidget(
                  package: packages[index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
