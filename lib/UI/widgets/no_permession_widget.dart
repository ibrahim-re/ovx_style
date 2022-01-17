import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';

class NoPermissionWidget extends StatefulWidget {
  final String iconName;
  final String text;

  NoPermissionWidget({required this.text, required this.iconName});

  @override
  State<NoPermissionWidget> createState() => _NoPermissionWidgetState();
}

class _NoPermissionWidgetState extends State<NoPermissionWidget> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<Offset>? offsetAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,);

    offsetAnimation = Tween<Offset>(
      begin: Offset(-2.5,0),
      end: Offset(0,0),
    ).animate(animationController!);

    offsetAnimation = Tween<Offset>(
      begin: Offset(0,0),
      end: Offset(1.5,0),
    ).animate(animationController!);

    animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SlideTransition(
            position: offsetAnimation!,
            child: SvgPicture.asset(
              'assets/images/${widget.iconName}.svg',
              color: MyColors.secondaryColor,
              height: 100,
              width: 100,
            ),
          ),
        ),
        Expanded(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: MyColors.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
