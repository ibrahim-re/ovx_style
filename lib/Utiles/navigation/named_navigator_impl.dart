import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/UI/auth/login_screen.dart';
import 'package:ovx_style/UI/auth/reset_password_screen.dart';
import 'package:ovx_style/UI/auth/signup_screen.dart';
import 'package:ovx_style/UI/basket/basket_screen.dart';
import 'package:ovx_style/UI/checkout/checkout_screen.dart';
import 'package:ovx_style/UI/google_maps_screen.dart';
import 'package:ovx_style/UI/home_screen.dart';
import 'package:ovx_style/UI/intro/auth_options_screen.dart';
import 'package:ovx_style/UI/offer_details/img_details_screen.dart';
import 'package:ovx_style/UI/offer_details/product_offer_details_screen.dart';
import 'package:ovx_style/UI/offers/add_offer_screen.dart';
import 'package:ovx_style/UI/offers/add_properties_screen.dart';
import 'package:ovx_style/UI/offers/add_shipping_cost_screen.dart';
import 'package:ovx_style/UI/payment/payment_screen.dart';
import 'package:ovx_style/UI/profile/other_user_profile.dart';
import 'package:ovx_style/UI/profile/user_profile_screen.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:page_transition/page_transition.dart';
import '../../UI/intro/intro_screen.dart';
import '../../UI/intro/splash_screen.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/model/user.dart';

class NamedNavigatorImpl implements NamedNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NamedRoutes.SPLASH_SCREEN:
        return PageTransition(
            child: SplashScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.INTRO_SCREEN:
        return PageTransition(
            child: IntroScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.AUTH_OPTIONS_SCREEN:
        return PageTransition(
            child: AuthOptionsScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.LOGIN_SCREEN:
        return PageTransition(
            child: LoginScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.SIGNUP_SCREEN:
        return PageTransition(
            child: SignupScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.GOOGLE_MAPS_SCREEN:
        return PageTransition(
            child: GoogleMapsScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.leftToRight,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.HOME_SCREEN:
        return PageTransition(
            child: HomeScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 500));
      case NamedRoutes.RESET_PASSWORD_SCREEN:
        return PageTransition(
            child: ResetPasswordScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.Product_Details:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final ProductOffer offer = data['offer'];

          return PageTransition(
              child: ProductDetails(
                navigator: navigatorState,
                offer: offer,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }
      case NamedRoutes.Post_Image_Details:
        {
        final data = settings.arguments as Map<String, dynamic>;
        final ImageOffer offer = data['offer'];
        return PageTransition(
            child: ImageDetailsScreen(
              navigator: navigatorState,
              offer: offer,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));
      }

      case NamedRoutes.ADD_OFFER_SCREEN:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final offerType = data['offerType'];

          return PageTransition(
              child: AddOfferScreen(
                navigator: navigatorState,
                offerType: offerType,
              ),
              type: PageTransitionType.bottomToTop,
              duration: const Duration(milliseconds: 500));
        }
      case NamedRoutes.ADD_PROPERTIES_SCREEN:
        return PageTransition(
            child: AddPropertiesScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.ADD_SHIPPING_COST_SCREEN:
        return PageTransition(
            child: AddShippingCostsScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.USER_PROFILE_SCREEN:
        return PageTransition(
            child: UserProfileScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.OTHER_USER_PROFILE:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final User user = data['user'];

          return PageTransition(
              child: OtherUserProfile(
                navigator: navigatorState,
                user: user,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.Basket:
        return PageTransition(
            child: basketScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.CheckOut:
        return PageTransition(
            child: checkOutScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.Payment:
        return PageTransition(
            child: paymentScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      default:
        return MaterialPageRoute(
            builder: (_) => SplashScreen(
                  navigator: navigatorState,
                ));
    }
  }

  @override
  void pop({dynamic result}) {
    if (navigatorState.currentState!.canPop()) {
      navigatorState.currentState!.pop(result);
    }
  }

  @override
  Future push(String routeName,
      {arguments, bool replace = false, bool clean = false}) {
    if (clean) {
      return navigatorState.currentState!.pushNamedAndRemoveUntil(
          routeName, (_) => false,
          arguments: arguments);
    }

    if (replace) {
      return navigatorState.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    }

    return navigatorState.currentState!
        .pushNamed(routeName, arguments: arguments);
  }
}
