import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/provider/theme_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? buttonText;
  final bool isBuy;
  final bool isBorder;
  final Color? backgroundColor;
  final double? radius;
  CustomButton(
      {this.onTap,
      required this.buttonText,
      this.isBuy = false,
      this.isBorder = false,
      this.backgroundColor,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap as void Function()?,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundColor != null
                ? backgroundColor
                : isBuy
                    ? Color(0xffFE961C)
                    : Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 1)), // changes position of shadow
            ],
            borderRadius: BorderRadius.circular(radius != null
                ? radius!
                : isBorder
                    ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                    : Dimensions.PADDING_SIZE_SMALL)),
        child: Text(buttonText!,
            style: titilliumSemiBold.copyWith(
              fontSize: 16,
              color: Theme.of(context).highlightColor,
            )),
      ),
    );
  }
}
