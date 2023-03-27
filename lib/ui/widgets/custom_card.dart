import 'package:flutter/material.dart';

//CustomClickableCard for showing ripple effect on tap of a widget ( widgets with background color & border radius)

class CustomClickableCard extends Card {
  final Widget childWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? bgColor;
  final double? height;
  final double? width;
  final bool enableBoxShadow;

  const CustomClickableCard(
      {super.key,
      required this.childWidget,
      this.onTap,
      this.onLongPress,
      this.bgColor,
      this.height,
      this.width,
      this.enableBoxShadow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 111.57,
        //width of this tile is (fullScreenWidth - ((padding to the size(L&R) (18 * 3) ) + (padding between the tiles (10)))) / 2 (number of tiles in a row)
        width: width, //(MediaQuery.of(context).size.width - 55.06) / 3,

        //BoxDecoration Necessary for boxShadowEffect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: (enableBoxShadow)
              ? const [
                  BoxShadow(
                    color: Color(0X40000000),
                    spreadRadius: -1,
                    blurRadius: 4,
                    offset: Offset(0, 1), // changes position of shadow
                  )
                ]
              : null,
        ),
        child: Material(
          color: bgColor ?? Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: childWidget,
          ),
        ));
  }
}
