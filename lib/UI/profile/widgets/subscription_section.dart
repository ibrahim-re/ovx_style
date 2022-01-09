import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue.shade100.withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Image(
                image: NetworkImage(
                    'https://image.freepik.com/free-vector/3d-tiger-characters-set_317810-3181.jpg'),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Text(
                'Subscription',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              )
            ],
          ),
          itemBuilder(
            text: 'Package is done, need to renew it ?',
            icon: null,
            clr: Colors.blue.shade100.withOpacity(0.3),
            textcolor: Colors.black,
          ),
          Row(
            children: [
              Expanded(
                  child: itemBuilder(
                      text: 'Renew',
                      icon: Icons.published_with_changes_sharp,
                      clr: Colors.amber,
                      textcolor: Colors.black)),
              const SizedBox(width: 10),
              Expanded(
                child: itemBuilder(
                  text: 'Update',
                  icon: Icons.update,
                  textcolor: Colors.white,
                  clr: Colors.indigo.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget itemBuilder({
  required String text,
  required IconData? icon,
  required Color clr,
  required Color textcolor,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: clr,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon == null
            ? Container()
            : Icon(
                icon,
                color: textcolor,
              ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: textcolor,
          ),
        ),
      ],
    ),
  );
}
