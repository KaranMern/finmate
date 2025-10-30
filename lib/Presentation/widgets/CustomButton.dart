import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonType { elevated, outlined }

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double borderRadius;
  final Color textColor;
  final double elevation;
  final FontWeight? fontWeight;
  final Color ButtonColor;
  final double width;
  final double height;
  final double FontSize;
  final ButtonType buttonType;
  final Color outlineColor;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.borderRadius = 10.0,
    this.textColor = Colors.white,
    this.elevation = 5.0,
    this.ButtonColor = const Color(0xFFff5758), // Fixed: Using constant color
    this.width = 120.0,
    this.height = 45.0,
    this.FontSize = 19,
    this.fontWeight,
    this.buttonType = ButtonType.elevated,
    this.outlineColor = const Color(0xFF6D0EB5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: buttonType == ButtonType.elevated
          ? BoxDecoration(
        color: ButtonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      )
          : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: buttonType == ButtonType.elevated ? 0 : elevation,
          backgroundColor: buttonType == ButtonType.elevated
              ? Colors.transparent
              : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: buttonType == ButtonType.outlined
                ? BorderSide(color: outlineColor, width: 2.0)
                : BorderSide.none,
          ),
          shadowColor: buttonType == ButtonType.elevated
              ? Colors.transparent
              : Colors.transparent,
        ),
        child: isLoading
            ? SizedBox(
          height: 20.h,
          width: 20.w,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        )
            : Text(
          text,
          style: TextStyle(
            color: buttonType == ButtonType.elevated
                ? textColor
                : Theme.of(context).hintColor,
            fontSize: FontSize.sp,
            fontWeight: fontWeight != null ? fontWeight : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
