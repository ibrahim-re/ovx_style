import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_states.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:ovx_style/helper/location_helper.dart';
import 'package:ovx_style/model/bill.dart';

class MyBillsScreen extends StatelessWidget {
  final navigator;

  const MyBillsScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my bills'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'ID'.tr(),
                        style:
                            Constants.TEXT_STYLE1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'value'.tr(),
                        style:
                            Constants.TEXT_STYLE1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'date'.tr(),
                        style:
                            Constants.TEXT_STYLE1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<BillsBloc, BillsState>(
                listener: (context, state){
                  if(state is BillRequestLoading)
                    EasyLoading.show(status: 'please wait'.tr());
                  else if(state is BillRequested)
                    EasyLoading.showSuccess('bill requested'.tr());
                  else if(state is BillRequestFailed)
                    EasyLoading.showSuccess(state.message);
                },
                builder: (context, state) {
                  if (state is FetchBillsLoading)
                    return CircularProgressIndicator(
                      color: MyColors.secondaryColor,
                    );
                  else if (state is FetchBillsFailed)
                    return Center(
                      child: Text(state.message),
                    );

                  else {
                    List<Bill> myBills = context.read<BillsBloc>().myBills;
                    return ListView.builder(
                      itemCount: myBills.length,
                      itemBuilder: (context, index) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: BillRow(
                              bill: myBills[index],
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

class BillRow extends StatefulWidget {
  final Bill bill;

  BillRow({required this.bill});

  @override
  _BillRowState createState() => _BillRowState();
}

class _BillRowState extends State<BillRow> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    print(widget.bill.buyerLatitude);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  widget.bill.id!,
                  style: Constants.TEXT_STYLE1,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '${widget.bill.amount!}',
                  style: Constants.TEXT_STYLE1,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  DateFormat('dd MMM yyyy').format(widget.bill.date!),
                  style: Constants.TEXT_STYLE1,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: MyColors.lightGrey,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ],
        ),
        if (isExpanded)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: MyColors.secondaryColor.withOpacity(0.2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: Text(
                          'product name'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text(
                          widget.bill.productName!,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(
                          'product price'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text(widget.bill.productPrice!.toString()),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: Text(
                          'product color'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: widget.bill.productColor!,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(
                          'product size'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text(widget.bill.productSize!.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Text(
                          'vat'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text('${widget.bill.vat!} %'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: Text(
                          'ship to'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text(
                          widget.bill.shipTo!,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(
                          'shipping costs'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text(widget.bill.shippingCost!.toString()),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    'buyer name'.tr(),
                    style: Constants.TEXT_STYLE6,
                  ),
                  subtitle: Text(
                    widget.bill.buyerName!,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ListTile(
                        title: Text(
                          'buyer email'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle: Text(
                          widget.bill.buyerEmail!,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(
                          'mobile'.tr(),
                          style: Constants.TEXT_STYLE6,
                        ),
                        subtitle:
                            Text(widget.bill.buyerPhoneNumber!.toString()),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.bill.buyerCountry!.isNotEmpty)
                      Expanded(
                        flex: 3,
                        child: ListTile(
                          title: Text(
                            'buyer country'.tr(),
                            style: Constants.TEXT_STYLE6,
                          ),
                          subtitle: Text(
                            widget.bill.buyerCountry!,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    if (widget.bill.buyerCity!.isNotEmpty)
                      Expanded(
                        flex: 2,
                        child: ListTile(
                          title: Text(
                            'buyer city'.tr(),
                            style: Constants.TEXT_STYLE6,
                          ),
                          subtitle: Text(widget.bill.buyerCity!.toString()),
                        ),
                      ),
                  ],
                ),
                if (widget.bill.buyerLongitude != 0 &&
                    widget.bill.buyerLatitude != 0)
                  AddressListTile(
                    latitude: widget.bill.buyerLatitude,
                    longitude: widget.bill.buyerLongitude,
                  ),
                TextButton(
                  onPressed: widget.bill.isRequested! ? null : () async {
                    bool b = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => AlertDialog(
                        title: Text('request bill'.tr(), style: Constants.TEXT_STYLE2.copyWith(fontSize: 18,),),
                        content: Text('are you sure bill'.tr(), style: Constants.TEXT_STYLE4,),
                        actions: [
                          TextButton(
                            onPressed: () {
                              NamedNavigatorImpl().pop(result: true);
                            },
                            child: Text(
                              'yes'.tr(),
                              style: Constants.TEXT_STYLE2.copyWith(fontSize: 16,),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              NamedNavigatorImpl().pop(result: false);
                            },
                            child: Text(
                              'no'.tr(),
                              style: Constants.TEXT_STYLE2.copyWith(fontSize: 16,),
                            ),
                          ),
                        ],
                      ),
                    );

                    if(b)
                      context.read<BillsBloc>().add(RequestBill(SharedPref.getUser().id!, widget.bill.id!));

                  },
                  child: Text(
                    'request bill'.tr(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class AddressListTile extends StatefulWidget {
  final latitude, longitude;

  AddressListTile({required this.longitude, required this.latitude});

  @override
  _AddressListTileState createState() => _AddressListTileState();
}

class _AddressListTileState extends State<AddressListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          LocationHelper().getUserAddress(widget.latitude, widget.longitude),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LinearProgressIndicator();
        else if (snapshot.hasData) {
          Placemark address = snapshot.data as Placemark;
          return ListTile(
            title: Text(
              'buyer address'.tr(),
              style: Constants.TEXT_STYLE6,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.name}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  'Country: ${address.country}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  'Area: ${address.administrativeArea}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  'SubArea: ${address.subAdministrativeArea}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  'Locality: ${address.locality}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  'Street: ${address.street}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  'Postal Code: ${address.postalCode}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          );
        } else
          return Text('');
      },
    );
  }
}
