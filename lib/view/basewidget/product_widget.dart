import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/data/model/response/product_model.dart';
import 'package:bed3a_ecommerce/helper/price_converter.dart';
import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:bed3a_ecommerce/utill/images.dart';
import 'package:bed3a_ecommerce/view/basewidget/rating_bar.dart';
import 'package:bed3a_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../localization/language_constrants.dart';
import '../screen/cart/widget/cart_widget.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  final int index;
  ProductWidget({required this.productModel, required this.index});

  @override
  Widget build(BuildContext context) {
    String ratting = productModel.rating != null && productModel.rating!.length != 0? productModel.rating![0].average! : "0";

    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1000),
          pageBuilder: (context, anim1, anim2) => ProductDetails(productId: productModel.id,slug: productModel.slug),
        ));
      },
      child: Container(
        // height: Dimensions.CARD_HEIGHT,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).highlightColor,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
        ),
        child: Stack(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            // Product Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: ColorResources.getIconBg(context),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder, fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width/2.45,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1,
                      fit: BoxFit.cover,height: MediaQuery.of(context).size.width/2.45),
                ),
              ),
            ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(productModel.name ?? '',
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                        fontWeight: FontWeight.w400,color: Theme.of(context).hintColor),
                    maxLines: 2,
                  ),
                ),
            // Product Details
            Padding(
              padding: EdgeInsets.only(top :Dimensions.PADDING_SIZE_SMALL,bottom: 5, left: 5,right: 5),
              child: Container(

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // productModel.discount!= null && productModel.discount! > 0 ?
                       Row(
                         children: [
                           Container(
                               decoration: BoxDecoration(
                                 color: Colors.grey[200],
                                 borderRadius: BorderRadius.all(Radius.circular(16))
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                                 child: Text(PriceConverter.convertPrice(context, productModel.unitPrice)),
                               )),
                           SizedBox(width: 4,),
                           Container(
                               decoration: BoxDecoration(
                                 color: Colors.grey[200],
                                 borderRadius: BorderRadius.all(Radius.circular(16))
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                 child: Text("24 عبوة "),
                               )),
                         ],
                       ),
                      //   style: titleRegular.copyWith(
                      //     color: ColorResources.getRed(context),
                      //     decoration: TextDecoration.lineThrough,
                      //
                      //     fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                      //   ),
                      // ) : SizedBox.shrink(),
                      // SizedBox(height: 2,),
                      //
                      //
                      // Text(PriceConverter.convertPrice(context,
                      //     productModel.unitPrice, discountType: productModel.discountType,
                      //     discount: productModel.discount),
                      //   style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                      // ),
                      //
                      // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      // Text(productModel.name ?? '',
                      //     style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                      //         fontWeight: FontWeight.w400,color: Theme.of(context).hintColor),
                      //     maxLines: 2,
                      //    ),
                      // Row(mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       RatingBar(
                      //         rating: double.parse(ratting),
                      //         size: 18,
                      //       ),
                      //
                      //
                      //   Text('(${productModel.reviewCount.toString() ?? 0})',
                      //       style: robotoRegular.copyWith(
                      //         fontSize: Dimensions.FONT_SIZE_SMALL,
                      //       )),
                      //
                      // ]),
                      // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),




                      InkWell(
                        onTap: () {
                          // if(vacationIsOn || temporaryClose ){
                          //   showCustomSnackBar(getTranslated('this_shop_is_close_now', context), context, isToaster: true);
                          // }else{
                          //   showModalBottomSheet(context: context, isScrollControlled: true,
                          //       backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
                          //       builder: (con) => CartBottomSheet(product: productModel, callback: (){
                          //         showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                          //       },));
                          // }

                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.getPrimary(context),
                          ),
                          child: Text(
                            getTranslated('add_to_cart', context)!,
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).highlightColor),
                          ),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      //       child: QuantityButton(isIncrement: false, index: index,
                      //         quantity: productModel.quantity,
                      //         maxQty: productModel.totalCurrentStock,
                      //         productModel: productModel, minimumOrderQuantity: productModel.minimumOrderQuantity,
                      //         digitalProduct: productModel!.productType == "digital"? true : false,
                      //
                      //       ),
                      //     ),
                      //     Text(productModel.quantity.toString(), style: titilliumSemiBold),
                      //
                      //     Padding(
                      //       padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                      //       child: QuantityButton(index: index, isIncrement: true,
                      //         quantity: productModel!.quantity,
                      //         maxQty: productModel.totalCurrentStock,
                      //         productModel: productModel, minimumOrderQuantity: productModel.minimumOrderQuantity,
                      //         digitalProduct: productModel!.productType == "digital"? true : false,
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ]),

          // Off

          // productModel.discount! > 0 ?
          // Positioned(top: 0, left: 0, child: Container(
          //     height: 20,
          //     padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //     decoration: BoxDecoration(
          //       color: ColorResources.getPrimary(context),
          //       borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          //     ),
          //
          //
          //     child: Center(
          //       child: Text(PriceConverter.percentageCalculation(context, productModel.unitPrice,
          //             productModel.discount, productModel.discountType),
          //         style: robotoRegular.copyWith(color: Theme.of(context).highlightColor,
          //             fontSize: Dimensions.FONT_SIZE_SMALL),
          //       ),
          //     ),
          //   ),
          // ) : SizedBox.shrink(),

        ]),
      ),
    );
  }
}
