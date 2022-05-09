import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/model/package.dart';

class PackageWidget extends StatelessWidget {
  final Package package;

  PackageWidget({required this.package});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final chatText = package.chatInDays == 999
        ? 'unlimited'.tr()
        : '${package.chatInDays} ' + 'days'.tr();
    final storyText = package.storyInDays == 999
        ? 'unlimited'.tr()
        : '${package.storyInDays} ' + 'days'.tr();
    return GestureDetector(
      onTap: () {
        NamedNavigatorImpl()
            .push(NamedRoutes.SUBSCRIPTION_CHECKOUT_SCREEN, arguments: {
          'package': package,
        });
      },
      child: Container(
        height: screenHeight * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyColors.lightBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  package.packageName!.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
                Spacer(),
                Text(
                  '${package.price} \$',
                  style: Constants.TEXT_STYLE9.copyWith(fontSize: 20),
                ),
              ],
            ),
            Expanded(
              child: IntroductionScreen(
                globalBackgroundColor: Colors.transparent,
                showDoneButton: false,
                showNextButton: false,
                dotsDecorator: DotsDecorator(
                  activeColor: MyColors.secondaryColor,
                  color: MyColors.lightGrey,
                ),
                pages: [
                  PageViewModel(
                    titleWidget: SvgPicture.asset('assets/images/crown.svg'),
                    bodyWidget: Text(
                      'expires in 30 days'.tr(),
                      style: Constants.TEXT_STYLE6,
                    ),
                    decoration: PageDecoration(
                      //bodyPadding: const EdgeInsets.all(0),
                      titlePadding: EdgeInsets.all(12),
                    ),
                  ),
                  PageViewModel(
                    titleWidget:
                    SvgPicture.asset('assets/images/crown.svg'),
                    bodyWidget: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text(
                            '${package.products} ' +
                                'products'.tr(),
                            style: Constants.TEXT_STYLE6,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${package.posts} ' +
                                'posts'.tr(),
                            style: Constants.TEXT_STYLE6,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${package.videos} ' +
                                'videos'.tr(),
                            style: Constants.TEXT_STYLE6,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${package.images} ' +
                                'images'.tr(),
                            style: Constants.TEXT_STYLE6,
                          ),
                        ],
                      ),
                    ),
                    decoration: PageDecoration(
                      titlePadding: EdgeInsets.all(12),
                    ),
                  ),
                  PageViewModel(
                    titleWidget: SvgPicture.asset('assets/images/crown.svg'),
                    bodyWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${package.storyCount} ' +'stories'.tr() + ' ' + storyText,
                          style: Constants.TEXT_STYLE6,
                        ),
                        Text(
                          'chat'.tr() + ' ' + chatText,
                          style: Constants.TEXT_STYLE6,
                        ),
                      ],
                    ),
                    decoration: PageDecoration(
                      //bodyPadding: const EdgeInsets.all(0),
                      titlePadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* */
