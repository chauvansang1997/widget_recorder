import 'package:flutter/material.dart';


///Xây dựng giao diện nhấn nút sẵn
class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.onPressed,
    this.borderColor,
    required this.child,
    this.padding =
        const EdgeInsets.only(top: 13, bottom: 16, left: 10, right: 10),
    this.height = 52,
    this.borderRadius = 8,
    this.backgroundColor,
    this.width = double.infinity,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget child;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: FlatButton(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                  color: borderColor ?? Colors.transparent, width: 1)),
          padding: padding,
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
