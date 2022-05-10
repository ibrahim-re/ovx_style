import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_events.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_states.dart';
import 'package:ovx_style/helper/basket_helper.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/product_property.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertiesSection extends StatefulWidget {
    const PropertiesSection({
        Key? key,
        required this.offerProperties,
        required this.productId,
        required this.discount,
        required this.productOwnerId,
        required this.title,
        required this.image,
        required this.vat,
    }) : super(key: key);

    final List<ProductProperty> offerProperties;
    final double discount;
    final String title, image, productId, productOwnerId;
    final double vat;

    @override
    State<PropertiesSection> createState() => _PropertiesSectionState();
}

class _PropertiesSectionState extends State<PropertiesSection> {
    int selectedPropertyIndex = 0;
    int selectedSizeIndex = 0;
    @override
    void initState(){
        super.initState();
    }


    @override
    Widget build(BuildContext context) {
        final properties = widget.offerProperties;
        final sizes = widget.offerProperties[selectedPropertyIndex].sizes;
        final currentItemPrice = properties[selectedPropertyIndex].sizes![selectedSizeIndex].price;

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                widget.discount == 0
                    ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        BlocListener<BasketBloc, BasketState>(
                            listener: (context, state) {
                                if (state is ItemAddedToBasket)
                                    EasyLoading.showToast('item added to basket'.tr(), dismissOnTap: true);
                            },
                            child: TextButton(
                                onPressed: () {
                                    //add item to basket
                                    context.read<BasketBloc>().add(
                                        AddItemToBasketEvent(
                                            widget.productId,
                                            widget.productOwnerId,
                                            widget.title,
                                            widget.image,
                                            properties[selectedPropertyIndex]
                                                .sizes![selectedSizeIndex]
                                                .size!,
                                            currentItemPrice!,
                                            properties[selectedPropertyIndex].color!,
                                            widget.vat,
                                            BasketHelper.tempShippingCost,
                                            BasketHelper.shipTo,
                                        ),
                                    );
                                },
                                child: Text(
                                    'add to basket'.tr(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.greenAccent,
                                    ),
                                ),
                            ),
                        ),
                        const SizedBox(
                            width: 8,
                        ),
                        Text(
                            '$currentItemPrice ${SharedPref.getCurrency()}',
                            style: Constants.TEXT_STYLE9,
                        ),
                    ],
                )
                    : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        BlocListener<BasketBloc, BasketState>(
                            listener: (context, state) {
                                if (state is ItemAddedToBasket)
                                    EasyLoading.showToast('item added to basket'.tr(), dismissOnTap: true);
                            },
                            child: TextButton(
                                onPressed: () {
                                    double priceAfterDiscount = Helper().priceAfterDiscount(
                                        currentItemPrice!, widget.discount);

                                    //add item to basket
                                    context.read<BasketBloc>().add(
                                        AddItemToBasketEvent(
                                            widget.productId,
                                            widget.productOwnerId,
                                            widget.title,
                                            widget.image,
                                            properties[selectedPropertyIndex]
                                                .sizes![selectedSizeIndex]
                                                .size!,
                                            priceAfterDiscount,
                                            properties[selectedPropertyIndex].color!,
                                            widget.vat,
                                            BasketHelper.tempShippingCost,
                                            BasketHelper.shipTo,
                                        ),
                                    );
                                },
                                child: Text(
                                    'add to basket'.tr(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.greenAccent,
                                    ),
                                ),
                            ),
                        ),
                        const SizedBox(
                            width: 8,
                        ),
                        Text(
                            '$currentItemPrice ${SharedPref.getCurrency()}',
                            style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                            ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                            '${Helper().priceAfterDiscount(currentItemPrice!, widget.discount)} ${SharedPref.getCurrency()}',
                            style: Constants.TEXT_STYLE9,
                        ),
                    ],
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                        children: [
                            Text(
                                'colors'.tr(),
                                style: Constants.TEXT_STYLE8,
                            ),
                            const SizedBox(width: 8,),
                            Wrap(
                                direction: Axis.horizontal,
                                children: properties
                                    .map(
                                        (property) => Container(
                                        padding: const EdgeInsets.all(2),
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                            border: selectedPropertyIndex ==
                                                properties.indexOf(property)
                                                ? Border.all(
                                                color: Colors.grey.shade500,
                                                style: BorderStyle.solid)
                                                : null,
                                            shape: BoxShape.circle,
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                                setState(() => selectedPropertyIndex =
                                                    properties.indexOf(property));

                                                //reset size index
                                                selectedSizeIndex = 0;
                                            },
                                            child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: property.color,
                                                    shape: BoxShape.circle,
                                                ),
                                            ),
                                        ),
                                    ),
                                )
                                    .toList(),
                            ),
                        ],
                    ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Wrap(
                        children: [
                            Text(
                                'sizes'.tr(),
                                style: Constants.TEXT_STYLE8,
                            ),
                            const SizedBox(width: 8,),
                            Wrap(
                                direction: Axis.horizontal,
                                children: sizes!
                                    .map(
                                        (size) => GestureDetector(
                                        onTap: () {
                                            setState(
                                                    () => selectedSizeIndex = sizes.indexOf(size));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(right: 6),
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: selectedSizeIndex == sizes.indexOf(size)
                                                    ? MyColors.secondaryColor
                                                    : MyColors.lightBlue.withOpacity(0.2),
                                            ),
                                            child: Text(size.size!,
                                                style: TextStyle(
                                                    color: selectedSizeIndex == sizes.indexOf(size)
                                                        ? Colors.white
                                                        : Colors.black,
                                                )),
                                        ),
                                    ),
                                )
                                    .toList(),
                            ),
                            // Icon(
                            //   Icons.info,
                            //   color: Colors.yellow,
                            // )
                        ],
                    ),
                ),
            ],
        );
    }
}
