import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/story/widgets/slider.dart';
import 'package:ovx_style/UI/story/widgets/story.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class StoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tempData = [
    {
      'storyImage':
          'https://image.freepik.com/free-photo/close-up-people-preparing-christmas-dinner_23-2149144980.jpg',
      'userName': 'Ali zamzam',
      'userImage':
          'https://image.freepik.com/free-photo/portrait-lovely-ethnic-woman-holds-modern-mobile-phone-uses-electronic-device-surfing-web-looks-positively-connected-wireless-internet-wears-casual-sweater-poses-indoor_273609-42443.jpg',
    },
    {
      'storyImage':
          'https://image.freepik.com/free-psd/merry-christmas-happy-new-year-with-3d-christmas-ornaments_106244-1813.jpg',
      'userName': 'yahia Zamzam',
      'userImage':
          'https://image.freepik.com/free-photo/portrait-lovely-ethnic-woman-holds-modern-mobile-phone-uses-electronic-device-surfing-web-looks-positively-connected-wireless-internet-wears-casual-sweater-poses-indoor_273609-42443.jpg',
    },
    {
      'storyImage':
          'https://image.freepik.com/free-photo/happy-new-year-2022-decoration-background-with-firework-rocket-clock_257995-799.jpg',
      'userName': 'youshaa Assad',
      'userImage':
          'https://image.freepik.com/free-photo/portrait-lovely-ethnic-woman-holds-modern-mobile-phone-uses-electronic-device-surfing-web-looks-positively-connected-wireless-internet-wears-casual-sweater-poses-indoor_273609-42443.jpg',
    },
    {
      'storyImage':
          'https://image.freepik.com/free-photo/girl-with-megaphone-jumping-shouting_8087-2707.jpg',
      'userName': 'Ahmad dali',
      'userImage':
          'https://image.freepik.com/free-photo/portrait-lovely-ethnic-woman-holds-modern-mobile-phone-uses-electronic-device-surfing-web-looks-positively-connected-wireless-internet-wears-casual-sweater-poses-indoor_273609-42443.jpg',
    },
    {
      'storyImage':
          'https://image.freepik.com/free-vector/merry-christmas-decorative-festival-wishes-greeting-design_1017-34907.jpg',
      'userName': 'Ashraf Dali',
      'userImage':
          'https://image.freepik.com/free-photo/portrait-lovely-ethnic-woman-holds-modern-mobile-phone-uses-electronic-device-surfing-web-looks-positively-connected-wireless-internet-wears-casual-sweater-poses-indoor_273609-42443.jpg',
    },
    {
      'storyImage':
          'https://image.freepik.com/free-photo/mother-with-her-baby-daughter-reading-book-by-christmas-tree_1303-29647.jpg',
      'userName': 'Ali Ibrahim',
      'userImage':
          'https://image.freepik.com/free-photo/portrait-lovely-ethnic-woman-holds-modern-mobile-phone-uses-electronic-device-surfing-web-looks-positively-connected-wireless-internet-wears-casual-sweater-poses-indoor_273609-42443.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    //no chat available for companies
    if (SharedPref.currentUser.userType == UserType.Company.toString())
      return NoPermissionWidget(
        text: 'Story is not available for companies',
        iconName: 'story',
      );
    else
      return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Stories'.tr(),
              style: TextStyle(
                color: MyColors.secondaryColor,
                fontSize: 20,
              ),
            ),
            titleSpacing: 14,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Badge(
                    badgeColor: Colors.blue.withOpacity(0.4),
                    badgeContent: Text(
                      '1',
                      style:
                          TextStyle(fontSize: 10, color: MyColors.primaryColor),
                    ),
                    padding: const EdgeInsets.all(6),
                    showBadge: true,
                    position: BadgePosition(
                      isCenter: false,
                      top: -10,
                      start: -4,
                    ),
                    child: Icon(
                      Icons.notifications,
                    ),
                  )),
              IconButton(
                  onPressed: () {
                    showFilterSheet(context: context);
                  },
                  icon: Icon(
                    Icons.filter_alt,
                  )),
            ],
          ),
          body: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.only(
              bottom: 24,
              left: 14,
              right: 14,
              top: 14,
            ),
            children: tempData.map((item) {
              return story(
                storyImage: item['storyImage'],
                userImage: item['userImage'],
                userName: item['userName'],
              );
            }).toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: MyColors.secondaryColor,
            mini: true,
            child: Icon(
              Icons.add,
              color: MyColors.primaryColor,
            ),
          ),
        ),
      );
  }
}

void showFilterSheet({required BuildContext context}) {
  showModalBottomSheet(
      context: context,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        borderSide: BorderSide(
          color: MyColors.primaryColor,
        ),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.secondaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Age'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              storySliderItem(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showCountriesSheet(context: context);
                },
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    hintText: 'Countries'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                enabled: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  prefixIcon: Icon(Icons.person),
                  enabled: true,
                  suffixIcon: PopupMenuButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    offset: Offset(-10, 40),
                    padding: const EdgeInsets.all(0),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          padding: const EdgeInsets.only(
                            left: 10,
                            bottom: 6,
                            right: 10,
                          ),
                          height: 4,
                          onTap: () {},
                          child: Text('Male'),
                        ),
                        PopupMenuItem(
                          padding: const EdgeInsets.only(
                            left: 10,
                            bottom: 6,
                            right: 10,
                          ),
                          height: 4,
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            child: Text('Female'),
                          ),
                        ),
                      ];
                    },
                  ),
                  hintText: 'Gender'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              applyButton(ontap: () {}),
            ],
          ),
        );
      });
}

void showCountriesSheet({required BuildContext context}) {
  showModalBottomSheet(
      context: context,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        borderSide: BorderSide(
          color: MyColors.primaryColor,
        ),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shipping Countries ',
                style: TextStyle(
                  color: MyColors.secondaryColor,
                ),
              ),
            ],
          ),
        );
      });
}

void showGenderList() {
  PopupMenuButton(itemBuilder: (_) {
    return [
      PopupMenuItem(child: Text('Male')),
      PopupMenuItem(child: Text('FeMale')),
    ];
  });
}

Widget applyButton({required Function ontap}) {
  return GestureDetector(
    onTap: () {
      ontap();
    },
    child: Container(
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.all(14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          'Apply'.toUpperCase().tr(),
          style: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 18,
          ),
        )),
  );
}
