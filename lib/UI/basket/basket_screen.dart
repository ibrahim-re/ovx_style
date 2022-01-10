import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/basket/widgets/basket_dismissible.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';

class basketScreen extends StatelessWidget {
  final navigator;

  basketScreen({Key? key, this.navigator}) : super(key: key);

  final List<Map<String, dynamic>> tempData = [
    {
      'image':
          "https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
      "price": 120,
      "descreption":
          " Lorem Ipsum has been the industry's standard dummy text ever since",
    },
    {
      'image':
          "https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
      "price": 120,
      "descreption":
          " Lorem Ipsum has been the industry's standard dummy text ever since",
    },
    {
      'image':
          "https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
      "price": 120,
      "descreption":
          " Lorem Ipsum has been the industry's standard dummy text ever since",
    },
    {
      'image':
          "https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
      "price": 120,
      "descreption":
          " Lorem Ipsum has been the industry's standard dummy text ever since",
    },
    {
      'image':
          "https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
      "price": 120,
      "descreption":
          " Lorem Ipsum has been the industry's standard dummy text ever since",
    },
    {
      'image':
          "https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg",
      "price": 120,
      "descreption":
          " Lorem Ipsum has been the industry's standard dummy text ever since",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'.tr()),
        leading: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              NamedNavigatorImpl().push(
                NamedRoutes.HOME_SCREEN,
                replace: true,
                clean: true,
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: MyColors.secondaryColor,
            )),
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Products'.tr(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                itemBuilder: (_, index) => basketDismissible(
                  imageUrl: tempData[index]['image'],
                  descreption: tempData[index]['descreption'],
                  price: tempData[index]['price'].toString(),
                ),
                separatorBuilder: (_, index) => const SizedBox(height: 0),
                itemCount: tempData.length,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Divider(
              color: MyColors.grey.withOpacity(0.3),
              thickness: 2,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: MyColors.grey.withOpacity(0.2),
            ),
            child: Row(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Text(
                  '300 \$',
                  style: TextStyle(
                    color: MyColors.secondaryColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              NamedNavigatorImpl()
                  .push(NamedRoutes.CheckOut, replace: true, clean: true);
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: MyColors.secondaryColor,
              ),
              child: Text(
                'CheckOut'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
