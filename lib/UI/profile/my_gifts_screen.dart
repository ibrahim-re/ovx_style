import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/receive_gifts_switch.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_bloc.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_states.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/model/gift.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:ovx_style/model/user.dart';

class MyGiftsScreen extends StatelessWidget {
  final navigator;

  const MyGiftsScreen({Key? key, this.navigator}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'gifts'.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ReceiveGiftsSwitch(),
            const SizedBox(height: 8,),
            Expanded(
              child: BlocBuilder<GiftsBloc, GiftsState>(
                builder: (context, state) {
                  if (state is FetchGiftsLoading)
                    return CircularProgressIndicator(
                      color: MyColors.secondaryColor,
                    );
                  else if (state is FetchGiftsFailed)
                    return Center(
                      child: Text(state.message),
                    );
                  else {
                    List<Gift> myGifts = context.read<GiftsBloc>().myGifts;
                    return ListView.builder(
                      itemCount: myGifts.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GiftContainer(
                          gift: myGifts[index],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GiftContainer extends StatelessWidget {
  final Gift gift;

  GiftContainer({required this.gift});
  @override
  Widget build(BuildContext context) {
    final bool isReceived = SharedPref.getUser().id == gift.to;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MyColors.secondaryColor.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: translator.activeLanguageCode == 'en' ? Alignment.topRight : Alignment.topLeft,
            child: Text(
              DateFormat('dd MMM yyyy').format(gift.date!),
              style: Constants.TEXT_STYLE7
                  .copyWith(color: MyColors.secondaryColor),
            ),
          ),
          Row(
            children: [
              Text(
                '#ID',
                style: Constants.TEXT_STYLE4,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '${gift.id}',
                style: Constants.TEXT_STYLE2.copyWith(fontSize: 16),
              ),
            ],
          ),
          Wrap(
            children: gift.productNames!
                .map(
                  (name) => Text(
                    '$name ',
                    style: Constants.TEXT_STYLE4,
                  ),
                )
                .toList(),
          ),
          Row(
            children: [
              Text(
                'from'.tr(),
                style: Constants.TEXT_STYLE4,
              ),
              const SizedBox(
                width: 8,
              ),
              Name(userId: gift.from!),
            ],
          ),
          Row(
            children: [
              Text(
                'to'.tr(),
                style: Constants.TEXT_STYLE4,
              ),
              const SizedBox(
                width: 8,
              ),
              Name(userId: gift.to!),
            ],
          ),
          Align(
            alignment: translator.activeLanguageCode == 'en' ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Container(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isReceived ? Colors.green : MyColors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                  child: Text(
                isReceived ? 'received'.tr() : 'sent'.tr(),
                style: Constants.TEXT_STYLE6,
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class Name extends StatelessWidget {
  final String userId;

  Name({required this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthHelper.getUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SizedBox(
            width: 40,
            child: LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: MyColors.secondaryColor,
            ),
          );
        else if (snapshot.hasData) {
          User user = snapshot.data as User;
          return GestureDetector(
            onTap: () {
              //check if offer owner is the logged in user
              if(user.id == SharedPref.getUser().id)
                return;
              else
                NamedNavigatorImpl().push(NamedRoutes.OTHER_USER_PROFILE, arguments: {'user': user});
            },
            child: Text(
              '${user.userName}',
              style: Constants.TEXT_STYLE2.copyWith(fontSize: 16),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
