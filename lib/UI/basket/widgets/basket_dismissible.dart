import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';

class basketDismissible extends StatelessWidget {
  const basketDismissible({
    Key? key,
    required this.imageUrl,
    required this.descreption,
    required this.price,
  }) : super(key: key);

  final String imageUrl, descreption, price;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red.withOpacity(.7),
        child: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/images/trash.svg',
            color: MyColors.primaryColor,
          ),
        ),
      ),
      key: ValueKey(descreption + DateTime.now().toString()),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          print('deleted');
        }
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image(
            image: NetworkImage(imageUrl),
            fit: BoxFit.fitWidth,
          ),
        ),
        title: Text(
          descreption,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          price + ' \$',
          style: TextStyle(
            color: MyColors.secondaryColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
