import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/data/model/response/category.dart';
import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:bed3a_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
class TopSellerCategoryWidget extends StatelessWidget {
  final Category category;
  const TopSellerCategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(text:category.name!,

    );
  }
}
