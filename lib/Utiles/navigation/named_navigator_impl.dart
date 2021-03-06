import 'package:flutter/material.dart';
import 'package:ovx_style/UI/auth/login_screen.dart';
import 'package:ovx_style/UI/auth/reset_password_screen.dart';
import 'package:ovx_style/UI/auth/signup_screen.dart';
import 'package:ovx_style/UI/basket/basket_screen.dart';
import 'package:ovx_style/UI/chat/create_chat_screen.dart';
import 'package:ovx_style/UI/chat/create_group_screen.dart';
import 'package:ovx_style/UI/chat/group_chat_screen.dart';
import 'package:ovx_style/UI/profile/points_checkout_screen.dart';
import 'package:ovx_style/UI/profile/subscription_checkout_screen.dart';
import 'package:ovx_style/UI/profile/subscription_screen.dart';
import '../../UI/full_screen_image.dart';
import 'package:ovx_style/model/group_model.dart';
import '../../UI/chat/chat_room_screen.dart';
import 'package:ovx_style/UI/checkout/checkout_screen.dart';
import 'package:ovx_style/UI/edit_profile/edit_profile_screen.dart';
import 'package:ovx_style/UI/google_maps_screen.dart';
import 'package:ovx_style/UI/home_screen.dart';
import 'package:ovx_style/UI/intro/auth_options_screen.dart';
import 'package:ovx_style/UI/notifications/notifications_screen.dart';
import 'package:ovx_style/UI/offer_details/img_details_screen.dart';
import 'package:ovx_style/UI/offer_details/post_details_screen.dart';
import 'package:ovx_style/UI/offer_details/product_offer_details_screen.dart';
import 'package:ovx_style/UI/offer_details/video_details_screen.dart';
import 'package:ovx_style/UI/offers/add_offer_screen.dart';
import 'package:ovx_style/UI/offers/add_properties_screen.dart';
import 'package:ovx_style/UI/offers/add_shipping_cost_screen.dart';
import 'package:ovx_style/UI/profile/help_screen.dart';
import 'package:ovx_style/UI/profile/my_bills_screen.dart';
import 'package:ovx_style/UI/profile/my_gifts_screen.dart';
import 'package:ovx_style/UI/profile/my_liked_offers_screen.dart';
import 'package:ovx_style/UI/profile/my_offers_screen.dart';
import 'package:ovx_style/UI/profile/other_user_profile.dart';
import 'package:ovx_style/UI/profile/user_profile_screen.dart';
import 'package:ovx_style/UI/story/story_details_screen.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:ovx_style/model/story_model.dart';
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
        {
          final data = settings.arguments as Map<String, dynamic>;
          final onSave = data['onSave'];

          return PageTransition(
              child: GoogleMapsScreen(
                onSave: onSave,
                navigator: navigatorState,
              ),
              type: PageTransitionType.leftToRight,
              duration: const Duration(milliseconds: 500));
        }

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

      case NamedRoutes.Post_Details:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final PostOffer post = data['post'];
          return PageTransition(
              child: postDetails(
                navigator: navigatorState,
                postOffer: post,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.Video_Details:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final VideoOffer video = data['video'];
          return PageTransition(
              child: videoDetails(
                navigator: navigatorState,
                video: video,
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

      case NamedRoutes.MY_OFFERS_SCREEN:
        return PageTransition(
            child: MyOffersScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.MY_BILLS_SCREEN:
        return PageTransition(
            child: MyBillsScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.NOTIFICATIONS_SCREEN:
        return PageTransition(
            child: NotificationsScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.MY_LIKED_OFFERS_SCREEN:
        return PageTransition(
            child: MyLikedOffersScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.bottomToTop,
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
            child: BasketScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.CheckOut:
        {
          final data = settings.arguments as Map<String, dynamic>;

          return PageTransition(
              child: checkOutScreen(
                navigator: navigatorState,
                subtotal: data['total'],
                vat: data['vat'],
                shippingCost: data['shipping cost'],
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.EDIT_PROFILE_SCREEN:
        return PageTransition(
            child: EditProfileScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.MY_GIFTS_SCREEN:
        return PageTransition(
            child: MyGiftsScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.HELP_SCREEN:
        return PageTransition(
            child: HelpScreen(
              navigator: navigatorState,
            ),
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 500));

      case NamedRoutes.StoryDetailsScreen:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final StoryModel story = data['oneStory'];
          return PageTransition(
              child: StoryDetails(
                navigator: navigatorState,
                model: story,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }
      case NamedRoutes.ChatRoomScreen:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final String anotherUserName = data['name'];
          final String anotherUserImage = data['image'];
          final String roomId = data['roomId'];
          final String userId = data['userId'];

          return PageTransition(
              child: ChatRoomScreen(
                anotherUserImage: anotherUserImage,
                anotherUserName: anotherUserName,
                navigator: navigatorState,
                roomId: roomId,
                userId: userId,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.GROUP_CHAT_SCREEN:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final GroupModel groupModel = data['groupModel'];

          return PageTransition(
              child: GroupChatScreen(
                groupModel: groupModel,
                navigator: navigatorState,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.CREATE_GROUP_SCREEN:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final String groupName = data['groupName'];

          return PageTransition(
              child: CreateGroupScreen(
                navigator: navigatorState,
                groupName: groupName,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.IMAGE_SCREEN:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final String heroTag = data['heroTag'];
          final String imageUrl = data['imageUrl'];

          return PageTransition(
              child: ImageScreen(
                navigator: navigatorState,
                heroTag: heroTag,
                imageUrl: imageUrl,
              ),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.CREATE_CHAT_SCREEN:
          return PageTransition(
              child: CreateChatScreen(
                navigator: navigatorState,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));

      case NamedRoutes.POINTS_CHECKOUT_SCREEN:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final pointsAmount = data['pointsAmount'];
          
          return PageTransition(
              child: PointsCheckoutScreen(
                navigator: navigatorState,
                pointsAmount: pointsAmount,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.SUBSCRIPTION_CHECKOUT_SCREEN:
        {
          final data = settings.arguments as Map<String, dynamic>;
          final package = data['package'];

          return PageTransition(
              child: SubscriptionCheckoutScreen(
                navigator: navigatorState,
                package: package,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500));
        }

      case NamedRoutes.SUBSCRIPTION_SCREEN:
        return PageTransition(
            child: SubscriptionScreen(
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
