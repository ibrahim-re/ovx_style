import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/auth/widgets/gender_picker.dart';
import 'package:ovx_style/UI/intro/auth_options_screen.dart';
import 'package:ovx_style/UI/offers/widgets/add_offers_widgets/offer_type_widget.dart';
import 'package:ovx_style/UI/widgets/country_picker.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_redirect_widget.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/filters_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_bloc.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_events.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_bloc.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_events.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_states.dart';
import 'package:ovx_style/bloc/points_bloc/points_bloc.dart';
import 'package:ovx_style/bloc/points_bloc/points_events.dart';
import 'package:ovx_style/bloc/points_bloc/points_states.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:ovx_style/bloc/user_bloc/user_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:provider/src/provider.dart';
import 'constants.dart';
import 'enums.dart';
import 'dart:io';
import 'package:ovx_style/model/user.dart';

class ModalSheets {
  void showNoAvailableOffersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'no available offers'.tr(),
          style: Constants.TEXT_STYLE4,
        ),
        content: Text(
          'subscribe to package'.tr(),
          style: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              NamedNavigatorImpl().pop();
            },
            child: Text(
              'cancel'.tr(),
              style: Constants.TEXT_STYLE4.copyWith(color: MyColors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              NamedNavigatorImpl().pop();
              NamedNavigatorImpl().push(NamedRoutes.SUBSCRIPTION_SCREEN);
            },
            child: Text(
              'subscribe'.tr(),
              style: Constants.TEXT_STYLE4
                  .copyWith(color: MyColors.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void showOfferTypePicker(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'offer type'.tr(),
              style: Constants.TEXT_STYLE2.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OfferTypeWidget(
                  iconName: 'product',
                  title: 'product'.tr(),
                  offerType: OfferType.Product,
                ),
                OfferTypeWidget(
                  iconName: 'video',
                  title: 'video'.tr(),
                  offerType: OfferType.Video,
                ),
                OfferTypeWidget(
                  iconName: 'image',
                  title: 'image'.tr(),
                  offerType: OfferType.Image,
                ),
                OfferTypeWidget(
                  iconName: 'post',
                  title: 'post'.tr(),
                  offerType: OfferType.Post,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showFilters(context, UserType userType) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) => FiltersWidget(userType: userType),
    );
  }

  void showLanguagePicker(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: <Widget>[
            ListTile(
              title: Text(
                'english'.tr(),
                style: Constants.TEXT_STYLE3,
              ),
              trailing: translator.activeLanguageCode == 'en'
                  ? Icon(
                      Icons.done,
                      size: 20,
                      color: MyColors.secondaryColor,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.transparent,
                    ),
              onTap: () {
                translator.setNewLanguage(context, newLanguage: 'en');
              },
            ),
            ListTile(
              title: Text(
                'arabic'.tr(),
                style: Constants.TEXT_STYLE3,
              ),
              trailing: translator.activeLanguageCode == 'ar'
                  ? Icon(
                      Icons.done,
                      size: 20,
                      color: MyColors.secondaryColor,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.transparent,
                    ),
              onTap: () {
                translator.setNewLanguage(context, newLanguage: 'ar');
              },
            ),
          ],
        ),
      ),
    );
  }

  void showTermsAndConditions(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  'terms and conds'.tr(),
                  style: Constants.TEXT_STYLE1,
                ),
              ),
            ),
          );
        });
  }

  void showSendGift(context) {
    late User user;
    TextEditingController userCodeController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/images/gift.svg',
                      fit: BoxFit.scaleDown),
                  const SizedBox(width: 6),
                  Text(
                    'send gift'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: MyColors.secondaryColor,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'enter friend code'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
              ),
              CustomTextFormField(
                controller: userCodeController,
                hint: 'friend code'.tr(),
                validateInput: (p) {},
                saveInput: (p) {},
              ),
              const SizedBox(
                height: 8,
              ),
              BlocConsumer<PaymentBloc, PaymentState>(
                listener: (ctx, state) {
                  if (state is PaymentForGiftSuccess) {
                    EasyLoading.showInfo('Success');
                    final basketItems = ctx.read<BasketBloc>().basketItems;
                    ctx.read<GiftsBloc>().add(SendGift(
                          basketItems,
                          user,
                        ));
                  } else if (state is PaymentForGiftFailed)
                    EasyLoading.showError(state.message);
                },
                builder: (ctx, state) {
                  if (state is PaymentForGiftLoading)
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.secondaryColor,
                      ),
                    );
                  else
                    return CustomElevatedButton(
                      color: MyColors.secondaryColor,
                      text: 'send'.tr(),
                      function: () async {
                        try {
                          DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

                          user = await _databaseRepositoryImpl.getUserByUserCode(userCodeController.text);
                          if (user.id != null) {
                            bool receiveGifts = user.receiveGifts ?? false;
                            if(receiveGifts)
                              ctx.read<PaymentBloc>().add(PayForGift());
                            else
                              EasyLoading.showError('user do not receive gift'.tr());
                          } else {
                            EasyLoading.showError('no user found'.tr());
                          }
                        } catch (e) {
                          if (e == 'Bad state: No element')
                            EasyLoading.showError('no user found'.tr());
                          else {
                            EasyLoading.showError('error occurred'.tr());
                          }
                        }
                      },
                    );
                },
              ),
              //to left the screen up as much as the bottom keyboard takes, so we can scroll down
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom)),
            ],
          ),
        );
      },
    );
  }

  void showSendPoints(BuildContext context, TextEditingController amountController, TextEditingController codeController) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'send points'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.secondaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'to send points'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
              ),
              BlocBuilder<PointsBloc, PointsState>(
                builder: (ctx, state) => Text(
                  '${ctx.read<PointsBloc>().points}' +
                      ' ' +
                      'available points'.tr(),
                  style: Constants.TEXT_STYLE6
                      .copyWith(color: MyColors.secondaryColor),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: amountController,
                hint: 'points amount'.tr(),
                keyboardType: TextInputType.number,
                validateInput: (p) {},
                saveInput: (p) {},
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: codeController,
                hint: 'user code'.tr(),
                validateInput: (p) {},
                saveInput: (p) {},
              ),
              const SizedBox(
                height: 8,
              ),
              BlocConsumer<PointsBloc, PointsState>(
                listener: (ctx, state) {
                  if (state is SendPointsFailed)
                    EasyLoading.showError(state.message);
                  else if (state is SendPointsSucceed) {
                    EasyLoading.showSuccess('points send'.tr());
                    NamedNavigatorImpl().pop();
                  }
                },
                builder: (ctx, state) {
                  if (state is SendPointsLoading)
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.secondaryColor,
                      ),
                    );
                  else
                    return CustomElevatedButton(
                      color: MyColors.secondaryColor,
                      text: 'send'.tr(),
                      function: () {
                        if (amountController.text.isNotEmpty &&
                            codeController.text.isNotEmpty) {
                          ctx.read<PointsBloc>().add(
                                SendPoint(
                                  SharedPref.getUser().id!,
                                  codeController.text,
                                  int.parse(
                                    amountController.text,
                                  ),
                                ),
                              );
                        } else
                          EasyLoading.showToast('fill all info'.tr());
                      },
                    );
                },
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom)),
            ],
          ),
        );
      },
    );
  }

  void showStoryDescSheet(BuildContext context, TextEditingController con, List<File> pickedFiles) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          borderSide: BorderSide(color: MyColors.primaryColor),
        ),
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'story desc'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
                SizedBox(height: 12),
                CustomTextFormField(
                  controller: con,
                  hint: 'story desc'.tr(),
                  validateInput: (p) {},
                  saveInput: (p) {},
                ),
                SizedBox(height: 12),
                CustomElevatedButton(
                  color: MyColors.secondaryColor,
                  text: 'add story'.tr(),
                  function: () {
                    if (con.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      BlocProvider.of<StoriesBloc>(context).add(
                        AddStory(
                          pickedFiles,
                          con.text,
                        ),
                      );
                    }
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom)),
              ],
            ),
          );
        });
  }

  void showCreateGroupSheet(context) {
    TextEditingController groupNameController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'create group'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.secondaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'by creating group'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
              ),
              CustomTextFormField(
                controller: groupNameController,
                hint: 'group name'.tr(),
                validateInput: (p) {},
                saveInput: (p) {},
              ),
              const SizedBox(
                height: 8,
              ),
              BlocConsumer<PointsBloc, PointsState>(listener: (ctx, state) {
                if (state is GetPointsSucceed) {
                  int points = ctx.read<PointsBloc>().points;
                  if (points < 150)
                    EasyLoading.showError('no 150 points'.tr());
                  else {
                    //pop to close bottom sheet first
                    NamedNavigatorImpl().pop();
                    NamedNavigatorImpl()
                        .push(NamedRoutes.CREATE_GROUP_SCREEN, arguments: {
                      'groupName': groupNameController.text,
                    });
                  }
                }
              }, builder: (ctx, state) {
                if (state is GetPointsLoading)
                  return Center(
                    child: CircularProgressIndicator(
                      color: MyColors.secondaryColor,
                    ),
                  );
                else
                  return CustomElevatedButton(
                    color: MyColors.secondaryColor,
                    text: 'create'.tr(),
                    function: () {
                      if (groupNameController.text.isEmpty)
                        EasyLoading.showError('please enter group name'.tr());
                      else
                        ctx.read<PointsBloc>().add(GetPoints());
                    },
                  );
              }),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom)),
            ],
          ),
        );
      },
    );
  }

  void showBuyPointsSheet(context) {
    TextEditingController pointsController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'buy points'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.secondaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'each 1000 points'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
              ),
              CustomTextFormField(
                controller: pointsController,
                hint: 'points amount'.tr(),
                keyboardType: TextInputType.number,
                validateInput: (p) {},
                saveInput: (p) {},
              ),
              const SizedBox(
                height: 8,
              ),
              CustomElevatedButton(
                color: MyColors.secondaryColor,
                text: 'buy'.tr(),
                function: () {
                  if (pointsController.text.isEmpty)
                    EasyLoading.showError('please enter points amount'.tr());
                  else {
                    NamedNavigatorImpl().pop();
                    NamedNavigatorImpl()
                        .push(NamedRoutes.POINTS_CHECKOUT_SCREEN, arguments: {
                      'pointsAmount': int.parse(pointsController.text),
                    });
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom)),
            ],
          ),
        );
      },
    );
  }

  void showFilterCountriesSheet(BuildContext context, CountriesFor countriesFor) {
    List<String> countries = [];
    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setNewState) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'countries'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    color: MyColors.secondaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'pick countries to filter'.tr(),
                    style: Constants.TEXT_STYLE4,
                  ),
                ),
                CountryPicker(
                  saveCountry: (val) {
                    setNewState(() {
                      String country =
                          Helper().deleteCountryFlag(val.toString());
                      countries.add(country);
                    });
                  },
                  saveCity: (val) {},
                  showCities: false,
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: countries
                      .map(
                        (country) => Text(
                          '$country',
                          style: Constants.TEXT_STYLE4,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomElevatedButton(
                  color: MyColors.secondaryColor,
                  text: 'add'.tr(),
                  function: () {
                    if (countriesFor == CountriesFor.Story)
                      context.read<StoriesBloc>().filterCountries = countries;
                    else
                      context.read<ChatBloc>().filterCountries = countries;

                    NamedNavigatorImpl().pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showUserPolicySheet(BuildContext context, String userId, {controller}) {
    bool isMe = userId == SharedPref.getUser().id;
    print(isMe);
    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    isMe ? 'my policy'.tr() : 'user policy'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: MyColors.secondaryColor,
                    ),
                  ),
                  Spacer(),
                  if (isMe)
                    IconButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty)
                          //NamedNavigatorImpl().pop();
                          context.read<UserBloc>().add(
                              UpdateUserPrivacyPolicy(userId, controller.text));
                      },
                      icon: Icon(
                        Icons.save_outlined,
                        color: MyColors.secondaryColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              BlocConsumer<UserBloc, UserState>(
                builder: (ctx, state) {
                  if (state is GetUserPrivacyPolicyFailed)
                    return Center(
                      child: Text(
                        state.message,
                        style: Constants.TEXT_STYLE9,
                        textAlign: TextAlign.center,
                      ),
                    );
                  else if (state is GetUserPrivacyPolicyLoading)
                    return Center(
                      child: RefreshProgressIndicator(
                        color: MyColors.secondaryColor,
                      ),
                    );
                  else {
                    String policy = context.read<UserBloc>().policy ?? '';
                    if (isMe && controller != null) {
                      controller.text = policy;
                      return TextFormField(
                        controller: controller,
                        //initialValue: state.policy.isNotEmpty ? state.policy : null,
                        maxLines: 10,
                        style: Constants.TEXT_STYLE1,
                        decoration: InputDecoration(
                          hintText: 'enter your policy'.tr(),
                          hintStyle: Constants.TEXT_STYLE1,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      );
                    } else
                      return Container(
                        height: 400,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            policy,
                            style: Constants.TEXT_STYLE6,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      );
                  }
                },
                listener: (ctx, state) {
                  if (state is UpdateUserPrivacyPolicyLoading)
                    EasyLoading.show(status: 'please wait'.tr());
                  if (state is UpdateUserPrivacyPolicyDone) {
                    EasyLoading.dismiss();
                    NamedNavigatorImpl().pop();
                    EasyLoading.showSuccess('policy updated'.tr());
                  }
                  if (state is UpdateUserPrivacyPolicyFailed) {
                    EasyLoading.dismiss();
                    EasyLoading.showError(state.message);
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(ctx).viewInsets.bottom)),
            ],
          ),
        );
      },
    );
  }

  void showSignSheet(context) {
    showModalBottomSheet(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'sign in to continue'.tr(),
                style: Constants.TEXT_STYLE9,
              ),
              const SizedBox(
                height: 6,
              ),
              AuthOptionsWidget(),
            ],
          ),
        );
      },
    );
  }

  void showFilter(BuildContext context, CountriesFor countriesFor) {
    //data to filter
    RangeValues val = RangeValues(0, 100);

    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'filter'.tr(),
                    style: Constants.TEXT_STYLE9,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'age'.tr(),
                    style: Constants.TEXT_STYLE4,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RangeSlider(
                    labels: RangeLabels(
                        val.start.ceil().toString(), val.end.ceil().toString()),
                    divisions: 100,
                    activeColor: MyColors.secondaryColor,
                    inactiveColor: MyColors.lightGrey,
                    min: 0,
                    max: 100,
                    values: val,
                    onChanged: (rangeValues) {
                      setState(() {
                        val = rangeValues;
                      });
                      if (countriesFor == CountriesFor.Story) {
                        ctx.read<StoriesBloc>().minAge = rangeValues.start.ceil();
                        ctx.read<StoriesBloc>().maxAge = rangeValues.end.ceil();
                      } else {
                        ctx.read<ChatBloc>().minAge = rangeValues.start.ceil();
                        ctx.read<ChatBloc>().maxAge = rangeValues.end.ceil();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocListener<UserBloc, UserState>(
                    listener: (ctx, state) {
                      if (state is ChangeCountriesLoading)
                        EasyLoading.show(status: 'please wait'.tr());
                      else if (state is ChangeCountriesDone) {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess('success'.tr());
                        showFilterCountriesSheet(context, countriesFor);
                      } else if (state is ChangeCountriesFailed) {
                        EasyLoading.dismiss();
                        EasyLoading.showError(state.message);
                      }
                    },
                    child: GestureDetector(
                      onTap: () async {
                        //check if story countries is all countries
                        String countries = countriesFor == CountriesFor.Story
                            ? SharedPref.getStoryCountries()
                            : SharedPref.getChatCountries();
                        if (countries == 'All countries') {
                          showFilterCountriesSheet(context, countriesFor);
                        } else {
                          bool b = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text(
                                'note'.tr(),
                                style: Constants.TEXT_STYLE4,
                              ),
                              content: Text(
                                countriesFor == CountriesFor.Story
                                    ? 'default story countries'.tr()
                                    : 'default chat countries'.tr(),
                                style: Constants.TEXT_STYLE6
                                    .copyWith(color: MyColors.grey),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    NamedNavigatorImpl().pop(result: false);
                                  },
                                  child: Text(
                                    'cancel'.tr(),
                                    style: Constants.TEXT_STYLE4
                                        .copyWith(color: MyColors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    NamedNavigatorImpl().pop(result: true);
                                  },
                                  child: Text(
                                    'ok'.tr(),
                                    style: Constants.TEXT_STYLE4.copyWith(
                                        color: MyColors.secondaryColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (b)
                            context.read<UserBloc>().add(
                                ChangeCountries(countriesFor, 'All countries'));
                        }
                      },
                      child: CustomRedirectWidget(
                        title: 'countries'.tr(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GenderPicker(
                    onSaved: (c) {},
                    onChanged: (pickedGender) {
                      countriesFor == CountriesFor.Story
                          ? ctx.read<StoriesBloc>().gender = pickedGender
                          : ctx.read<ChatBloc>().gender = pickedGender;
                      ;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomElevatedButton(
                    color: MyColors.secondaryColor,
                    text: 'apply',
                    function: () {
                      NamedNavigatorImpl().pop();
                      countriesFor == CountriesFor.Story
                          ? ctx.read<StoriesBloc>().add(FilterStories())
                          : ctx.read<ChatBloc>().add(FilterChats());
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
