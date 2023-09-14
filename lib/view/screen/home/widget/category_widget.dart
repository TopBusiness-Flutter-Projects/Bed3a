import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/data/model/response/category.dart';
import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:bed3a_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
class CategoryWidget extends StatelessWidget {
  final Category category;
  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column( children: [
      Container(
        height: MediaQuery.of(context).size.width/6,
        width: MediaQuery.of(context).size.width/6,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.2)),
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).highlightColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: Images.placeholder,
            image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.categoryImageUrl}'
                '/${category.icon}',
            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover,),
          ),
        ),
      ),

      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      Container(
        child: Center(
          child: Text(category.name!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                color: ColorResources.getTextTitle(context)),
          ),
        ),
      ),

    ]);
  }
}
