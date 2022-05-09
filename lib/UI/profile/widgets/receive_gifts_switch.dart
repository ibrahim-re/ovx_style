import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:ovx_style/bloc/user_bloc/user_states.dart';
import 'package:provider/src/provider.dart';

class ReceiveGiftsSwitch extends StatefulWidget {
  @override
  _ReceiveGiftsSwitchState createState() => _ReceiveGiftsSwitchState();
}

class _ReceiveGiftsSwitchState extends State<ReceiveGiftsSwitch> {
  bool receiveGifts = false;

  @override
  void initState() {
    context.read<UserBloc>().add(GetReceiveGifts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'receive gifts'.tr(),
              style: Constants.TEXT_STYLE4,
            ),
            BlocConsumer<UserBloc, UserState>(
              builder: (ctx, state) {

                if (state is GetReceiveGiftsDone) {
                  receiveGifts = state.receiveGifts;
                  return Switch.adaptive(
                    value: receiveGifts,
                    activeColor: MyColors.secondaryColor,
                    onChanged: (receiveGifts) {
                      context.read<UserBloc>().add(ChangeReceiveGifts(receiveGifts));
                    },
                  );
                }

                else if (state is ChangeReceiveGiftsDone) {
                  receiveGifts = state.receiveGifts;
                  return Switch.adaptive(
                    value: receiveGifts,
                    activeColor: MyColors.secondaryColor,
                    onChanged: (receiveGifts) {
                      context.read<UserBloc>().add(ChangeReceiveGifts(receiveGifts));
                    },
                  );
                }

                else
                  return Switch.adaptive(
                    value: receiveGifts,
                    activeColor: MyColors.secondaryColor,
                    onChanged: (receiveGifts) {
                      context.read<UserBloc>().add(ChangeReceiveGifts(receiveGifts));
                    },
                  );
              },
              listener: (ctx, state) {
                if (state is ChangeReceiveGiftsFailed)
                  EasyLoading.showToast(state.message);
                else if (state is ChangeReceiveGiftsDone)
                  EasyLoading.showToast('success'.tr());
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/images/info.svg', fit: BoxFit.scaleDown, width: 15,),
            const SizedBox(width: 8,),
            Expanded(
              child: Text(
                'receive gifts note'.tr(),
                style: Constants.TEXT_STYLE6.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
