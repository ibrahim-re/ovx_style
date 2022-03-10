import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/login_bloc/login_bloc.dart';
import 'package:ovx_style/bloc/login_bloc/login_states.dart';

class IntroScreen extends StatefulWidget {
	final navigator;

	const IntroScreen({this.navigator});

	@override
	_IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
	PageController _pageController = PageController(initialPage: 0);

	@override
	void dispose() {
		_pageController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final screenHeight = MediaQuery.of(context).size.height;
		return Scaffold(
			body: SafeArea(
				child: PageView.builder(
					physics: NeverScrollableScrollPhysics(),
					controller: _pageController,
					itemCount: 2,
					itemBuilder: (ctx, index) => Padding(
						padding: const EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 20),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								Container(
									height: screenHeight * 0.5,
									child: Image.asset('assets/images/circles.png'),
								),
								SizedBox(
									height: screenHeight * 0.025,
								),
								Center(child: Title(index: index)),
								SizedBox(
									height: screenHeight * 0.01,
								),
								Center(child: Description(index: index)),
								Spacer(),
								CustomElevatedButton(
									color: MyColors.secondaryColor,
									text: 'next'.tr(),
									function: () {
										if (index == 1)
											NamedNavigatorImpl()
													.push(NamedRoutes.AUTH_OPTIONS_SCREEN, replace: true);

										_pageController.nextPage(
												duration: Duration(milliseconds: 400),
												curve: Curves.linear);
									},
								),
								TextButton(
									onPressed: () {
										NamedNavigatorImpl()
												.push(NamedRoutes.AUTH_OPTIONS_SCREEN, replace: true);
									},
									child: Text(
										'skip'.tr(),
										style: Constants.TEXT_STYLE4,
									),
								),
							],
						),
					),
				),
			),
		);
	}
}

class Title extends StatelessWidget {
	final index;

	Title({@required this.index});

	@override
	Widget build(BuildContext context) {
		return index == 0
				? Text(
			'sell'.tr(),
			style: Constants.TEXT_STYLE2,
		)
				: Text(
			'buy'.tr(),
			style: Constants.TEXT_STYLE2,
		);
	}
}

class Description extends StatelessWidget {
	final index;

	Description({@required this.index});

	@override
	Widget build(BuildContext context) {
		return index == 0
				? Text(
			'intro desc'.tr(),
			textAlign: TextAlign.center,
			style: Constants.TEXT_STYLE3,
		)
				: Text(
			'intro desc'.tr(),
			textAlign: TextAlign.center,
			style: Constants.TEXT_STYLE3,
		);
	}
}
