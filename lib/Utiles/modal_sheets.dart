import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/add_offers_widgets/offer_type_widget.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/filters_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
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
import 'package:provider/src/provider.dart';
import 'constants.dart';
import 'enums.dart';
import 'dart:io';
import 'package:ovx_style/model/user.dart';

class ModalSheets {
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

  void showFilters(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) => FiltersWidget(),
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
        return BlocProvider<PaymentBloc>(
          create: (ctx) => PaymentBloc(),
          child: Container(
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
                            DatabaseRepositoryImpl _databaseRepositoryImpl =
                                DatabaseRepositoryImpl();

                            user = await _databaseRepositoryImpl
                                .getUserByUserCode(userCodeController.text);
                            print('user is ${user.toMap()}');
                            if (user.id != null) {
                              print(user.id! + 'hhh');
                              ctx.read<PaymentBloc>().add(PayForGift());
                            } else {
                              EasyLoading.showError('no user found'.tr());
                            }
                          } catch (e) {
                            if (e == 'Bad state: No element')
                              EasyLoading.showError('no user found'.tr());
                            else {
                              print('error us  ');
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
        return BlocProvider<PointsBloc>(
          create: (ctx) => PointsBloc()..add(GetPoints()),
          child: Container(
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
                BlocBuilder<PointsBloc, PointsState>(builder: (ctx, state) => Text(
                  '${ctx.read<PointsBloc>().points}' +
                      ' ' +
                      'available points'.tr(),
                  style: Constants.TEXT_STYLE6
                      .copyWith(color: MyColors.secondaryColor),
                ),),
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
          ),
        );
      },
    );
  }

  void showStoryDescSheet(
      BuildContext context, TextEditingController con, List<File> pickedFiles) {
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
        return BlocProvider(
          create: (ctx) => PointsBloc(),
          child: Container(
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
                BlocConsumer<PointsBloc, PointsState>(
                  listener: (ctx, state) {
                    if(state is GetPointsSucceed){
                      // int points = ctx.read<PointsBloc>().points;
                      // if(points < 150)
                      //   EasyLoading.showError('no 150 points'.tr());
                      // else {
                        //pop to close bottom sheet first
                        NamedNavigatorImpl().pop();
                        NamedNavigatorImpl().push(
                            NamedRoutes.CREATE_GROUP_SCREEN, arguments: {
                          'groupName': groupNameController.text,
                        });
                      //}
                    }
                  },
                  builder: (ctx, state) {
                  if(state is GetPointsLoading)
                    return Center(child: CircularProgressIndicator(color: MyColors.secondaryColor,),);
                  else
                    return CustomElevatedButton(
                      color: MyColors.secondaryColor,
                      text: 'create'.tr(),
                      function: () {
                        if(groupNameController.text.isEmpty)
                          EasyLoading.showError('please enter group name'.tr());
                        else
                          ctx.read<PointsBloc>().add(GetPoints());
                      },
                    );
                }),
                // BlocConsumer<PaymentBloc, PaymentState>(
                //   listener: (ctx, state) {
                //     if (state is PaymentForGiftSuccess) {
                //       EasyLoading.showInfo('Success');
                //       final basketItems = ctx.read<BasketBloc>().basketItems;
                //       ctx.read<GiftsBloc>().add(SendGift(
                //         basketItems,
                //         user,
                //       ));
                //     } else if (state is PaymentForGiftFailed)
                //       EasyLoading.showError(state.message);
                //   },
                //   builder: (ctx, state) {
                //     if (state is PaymentForGiftLoading)
                //       return Center(
                //         child: CircularProgressIndicator(
                //           color: MyColors.secondaryColor,
                //         ),
                //       );
                //     else
                //       return CustomElevatedButton(
                //         color: MyColors.secondaryColor,
                //         text: 'send'.tr(),
                //         function: () async {
                //           try {
                //             DatabaseRepositoryImpl _databaseRepositoryImpl =
                //             DatabaseRepositoryImpl();
                //
                //             user = await _databaseRepositoryImpl
                //                 .getUserByUserCode(userCodeController.text);
                //             print('user is ${user.toMap()}');
                //             if (user.id != null) {
                //               print(user.id! + 'hhh');
                //               ctx.read<PaymentBloc>().add(PayForGift());
                //             } else {
                //               EasyLoading.showError('no user found'.tr());
                //             }
                //           } catch (e) {
                //             if (e == 'Bad state: No element')
                //               EasyLoading.showError('no user found'.tr());
                //             else {
                //               print('error us  ');
                //               EasyLoading.showError('error occurred'.tr());
                //             }
                //           }
                //         },
                //       );
                //   },
                // ),
                //to left the screen up as much as the bottom keyboard takes, so we can scroll down
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom)),
              ],
            ),
          ),
        );
      },
    );
  }
}
