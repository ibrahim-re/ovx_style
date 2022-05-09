import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';

class NoDataWidget extends StatefulWidget {
  final String iconName;
  final String text;
  final child;

  NoDataWidget({required this.text, required this.iconName, this.child});

  @override
  State<NoDataWidget> createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> with SingleTickerProviderStateMixin {
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
              height: 90,
              width: 90,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: MyColors.secondaryColor,
                ),
              ),
              const SizedBox(height: 8,),
              widget.child ?? Container(),
            ],
          ),
        ),
      ],
    );
  }
}
