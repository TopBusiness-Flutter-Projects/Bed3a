import 'package:bed3a_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/data/model/response/product_model.dart';
import 'package:bed3a_ecommerce/helper/price_converter.dart';
import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:bed3a_ecommerce/utill/images.dart';
import 'package:bed3a_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../../data/model/response/cart_model.dart';
import '../../localization/language_constrants.dart';
import '../../provider/auth_provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/seller_provider.dart';

class ProductWidget extends StatefulWidget {
  final Product productModel;
  final int index;

  ProductWidget({required this.productModel, required this.index});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).initData(
        widget.productModel, widget.productModel.minimumOrderQuantity, context);
  }

  @override
  Widget build(BuildContext context) {
    route(bool isRoute, String message) async {
      if (isRoute) {
        showCustomSnackBar(message, context, isError: false);
        // Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // showCustomSnackBar(message, context);
      }
    }

    String ratting = widget.productModel.rating != null &&
            widget.productModel.rating!.length != 0
        ? widget.productModel.rating![0].average!
        : "0";

    return Consumer<ProductProvider>(builder: (ctx, details, child) {
      int? selectedIndex = 0;

      Variation? _variation;
      String? _variantName = (widget.productModel.colors != null &&
              widget.productModel.colors!.length != 0)
          ? widget.productModel.colors![details.variantIndex!].name
          : null;
      List<String> _variationList = [];
      for (int index = 0;
          index < widget.productModel.choiceOptions!.length;
          index++) {
        _variationList.add(widget.productModel.choiceOptions![index]
            .options![details.variationIndex![index]]
            .trim());
      }
      String variationType = '';
      if (_variantName != null) {
        variationType = _variantName;
        _variationList.forEach(
            (variation) => variationType = '$variationType-$variation');
      } else {
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });
      }
      double? price = widget.productModel.unitPrice;
      int? _stock = widget.productModel.currentStock ?? 0;
      variationType = variationType.replaceAll(' ', '');
      for (Variation variation in widget.productModel.variation!) {
        if (variation.type == variationType) {
          price = variation.price;
          _variation = variation;
          _stock = variation.qty;
          break;
        }
      }
      if (details.variantIndex! >= widget.productModel.images!.length) {
        selectedIndex = details.variantIndex! -
            (widget.productModel.colors!.length -
                widget.productModel.images!.length);
      } else {
        selectedIndex = details.variantIndex;
      }

      print('bangla===>$selectedIndex/${widget.productModel.images!.length}');

      double priceWithDiscount = PriceConverter.convertWithDiscount(
          context,
          price,
          widget.productModel.discount,
          widget.productModel.discountType)!;
      double priceWithQuantity = priceWithDiscount * details.quantity!;

      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => ProductDetails(
                      productId: widget.productModel.id,
                      slug: widget.productModel.slug)));
        },
        child: Container(
          height: MediaQuery.of(context).size.width / 1.5,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).highlightColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Product Image
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: ColorResources.getIconBg(context),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        fit: BoxFit.cover,
                        // height: MediaQuery.of(context).size.width / 2.45,
                        image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${widget.productModel.thumbnail}',
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.placeholder_1x1,
                          fit: BoxFit.cover,
                          // height: MediaQuery.of(context).size.width / 2.45
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productModel.name ?? '',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hintColor),
                    maxLines: 2,
                  ),
                ),
                // Product Details
                Padding(
                  padding: EdgeInsets.only(
                      top: Dimensions.PADDING_SIZE_SMALL,
                      bottom: 5,
                      left: 5,
                      right: 5),
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // productModel.discount!= null && productModel.discount! > 0 ?
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8),
                                      child: Text(
                                          PriceConverter.convertPrice(context,
                                              widget.productModel.unitPrice,
                                              discount:
                                                  widget.productModel.discount,
                                              discountType: widget
                                                  .productModel.discountType),
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 12)),
                                    )),
                              ),
                              Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5),
                                    child: Text(
                                        widget.productModel.currentStock
                                                .toString() +
                                            'عبوة',
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 12)),
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

                          SizedBox(
                            height: 2,
                          ),
                          Visibility(
                            visible: widget.productModel.quantity == 0,
                            child: InkWell(
                              onTap:
                                  _stock! <
                                              widget.productModel
                                                  .minimumOrderQuantity! &&
                                          widget.productModel.productType ==
                                              "physical"
                                      ? null
                                      : () {
                                          if (_stock! >=
                                                  widget.productModel
                                                      .minimumOrderQuantity! ||
                                              widget.productModel.productType ==
                                                  "digital") {
                                            CartModel cart = CartModel(
                                                widget.productModel.hasDiscount,
                                                widget
                                                    .productModel.discountPercent,
                                                widget.productModel.sellerShop,
                                                widget.productModel.id,
                                                widget.productModel.id,
                                                widget.productModel.thumbnail,
                                                widget.productModel.name,
                                                widget.productModel.addedBy ==
                                                        'seller'
                                                    ? '${Provider.of<SellerProvider>(context, listen: false).sellerModel?.seller!.fName ?? ''} '
                                                        '${Provider.of<SellerProvider>(context, listen: false).sellerModel?.seller!.lName ?? ''}'
                                                    : 'admin',
                                                price,
                                                priceWithDiscount,
                                                details.quantity,
                                                _stock,
                                                (widget.productModel.colors != null && widget.productModel.colors!.length > 0)
                                                    ? widget
                                                        .productModel
                                                        .colors![details
                                                            .variantIndex!]
                                                        .name
                                                    : '',
                                                (widget.productModel.colors != null &&
                                                        widget.productModel.colors!.length >
                                                            0)
                                                    ? widget
                                                        .productModel
                                                        .colors![details
                                                            .variantIndex!]
                                                        .code
                                                    : '',
                                                _variation,
                                                widget.productModel.discount,
                                                widget
                                                    .productModel.discountType,
                                                widget.productModel.tax,
                                                widget.productModel.taxModel,
                                                widget.productModel.taxType,
                                                1,
                                                '',
                                                widget.productModel.userId,
                                                '',
                                                '',
                                                '',
                                                widget
                                                    .productModel.choiceOptions,
                                                Provider.of<ProductProvider>(context, listen: false)
                                                    .variationIndex,
                                                widget.productModel.isMultiPly == 1
                                                    ? widget.productModel.shippingCost! *
                                                        details.quantity!
                                                    : widget.productModel.shippingCost ?? 0,
                                                widget.productModel.minimumOrderQuantity,
                                                widget.productModel.productType,
                                                widget.productModel.slug,
                                                widget.productModel.limitPrice,
                                                widget.productModel.limitProduct,
                                                widget.productModel.totalPrice);

                                            // cart.variations = _variation;
                                            if (Provider.of<AuthProvider>(
                                                    context,
                                                    listen: false)
                                                .isLoggedIn()) {
                                              setState(() {
                                                widget.productModel
                                                    .quantityadd = 1;
                                              });
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .addToCartAPI(
                                                      cart,
                                                      route,
                                                      context,
                                                      widget.productModel
                                                          .choiceOptions,
                                                      Provider.of<ProductProvider>(
                                                              context,
                                                              listen: false)
                                                          .variationIndex);
                                            } else {
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .addToCart(cart);
                                              //   Navigator.pop(context);
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'added_to_cart', context),
                                                  context,
                                                  isError: false);
                                            }
                                          }
                                        },
                              child: Container(
                                height: 45,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorResources.getPrimary(context),
                                ),
                                child: Text(
                                  getTranslated('add_to_cart', context)!,
                                  style: titilliumSemiBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: Theme.of(context).highlightColor),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.productModel.quantity! > 0,
                            child: Container(
                              height: 45,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    child: QuantityButton(
                                      isIncrement: false,
                                      index: widget.index,
                                      quantity: widget.productModel.quantity,
                                      maxQty: widget.productModel.currentStock,
                                      productModel: widget.productModel,
                                      minimumOrderQuantity: widget
                                          .productModel.minimumOrderQuantity,
                                      digitalProduct:
                                          widget.productModel.productType ==
                                                  "digital"
                                              ? true
                                              : false,
                                    ),
                                  ),
                                  // Spacer(),

                                  // Padding(
                                  //   padding: EdgeInsets.zero,
                                  //   child: IconButton(
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (_) => CartScreen()));
                                  //     },
                                  //     icon: CircleAvatar(
                                  //       child: Icon(
                                  //         Icons.done_rounded,
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //     // icon: Stack(
                                  //     //     clipBehavior: Clip.none,
                                  //     //     children: [
                                  //     //       Image.asset(
                                  //     //         Images.cart_arrow_down_image,
                                  //     //         height:
                                  //     //             Dimensions.ICON_SIZE_DEFAULT,
                                  //     //         width:
                                  //     //             Dimensions.ICON_SIZE_DEFAULT,
                                  //     //         color: ColorResources.getPrimary(
                                  //     //             context),
                                  //     //       ),
                                  //     //       Positioned(
                                  //     //         top: -4,
                                  //     //         right: -4,
                                  //     //         child: Consumer<CartProvider>(
                                  //     //             builder:
                                  //     //                 (context, cart, child) {
                                  //     //           return CircleAvatar(
                                  //     //             radius: 7,
                                  //     //             backgroundColor:
                                  //     //                 ColorResources.RED,
                                  //     //             child: Text(
                                  //     //                 cart.cartList.length
                                  //     //                     .toString(),
                                  //     //                 style: titilliumSemiBold
                                  //     //                     .copyWith(
                                  //     //                   color: ColorResources
                                  //     //                       .WHITE,
                                  //     //                   fontSize: Dimensions
                                  //     //                       .FONT_SIZE_EXTRA_SMALL,
                                  //     //                 )),
                                  //     //           );
                                  //     //         }),
                                  //     //       ),
                                  //     //     ]),
                                  //   ),
                                  // ),

                                  Spacer(),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                        widget.productModel.quantity.toString(),
                                        style: titilliumSemiBold),
                                  ),
                                  //  Spacer(),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.PADDING_SIZE_SMALL),
                                    child: QuantityButton(
                                      index: widget.index,
                                      isIncrement: true,
                                      quantity: widget.productModel.quantity,
                                      maxQty: widget.productModel.currentStock,
                                      productModel: widget.productModel,
                                      minimumOrderQuantity: widget
                                          .productModel.minimumOrderQuantity,
                                      digitalProduct:
                                          widget.productModel.productType ==
                                                  "digital"
                                              ? true
                                              : false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      );
    });
  }
}

class QuantityButton extends StatelessWidget {
  final Product? productModel;
  final bool isIncrement;
  final int? quantity;
  final int index;
  final int? maxQty;
  final int? minimumOrderQuantity;
  final bool? digitalProduct;
  QuantityButton(
      {required this.isIncrement,
      required this.quantity,
      required this.index,
      required this.maxQty,
      this.minimumOrderQuantity,
      this.digitalProduct,
      this.productModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isIncrement && quantity! > minimumOrderQuantity!) {
          print('--q(-)q-->$quantity / $minimumOrderQuantity');
          Provider.of<CartProvider>(context, listen: false)
              .updateCartProductQuantity(
                  isPro: 1,
                  productModel!.id,
                  productModel!.quantity! - 1,
                  context)
              .then((value) {
            productModel!.quantityadd = productModel!.quantity! - 1;

            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   duration: Duration(milliseconds: 200),
            //   content: Text(value.message!),
            //   backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            // ));
          });
        } else if (isIncrement && quantity! < minimumOrderQuantity!) {
          print(
              '--q(+)q-->$quantity/$minimumOrderQuantity==bangla--------===>');
          Provider.of<CartProvider>(context, listen: false)
              .updateCartProductQuantity(
                  isPro: 1,
                  productModel!.id,
                  productModel!.quantity! + 1,
                  context)
              .then((value) {
            productModel!.quantityadd = productModel!.quantity! + 1;
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   duration: Duration(milliseconds: 200),
            //   content: Text(value.message!),
            //   backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            // ));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 300),
              content: Text(quantity! >= maxQty!
                  ? "لقد وصلت للحد الاقصي"
                  : "لقد وصلت للحد الادني"),
              backgroundColor: Colors.green));
        }

        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text(
        //           "value.message! isIncrement $isIncrement quantity $quantity index $index maxQty $maxQty minimumOrderQuantity $minimumOrderQuantity digitalProduct $digitalProduct"),
        //       backgroundColor: Colors.green));

        //   print(
        //       "value.message! isIncrement $isIncrement quantity $quantity index $index maxQty $maxQty minimumOrderQuantity $minimumOrderQuantity digitalProduct $digitalProduct");

        //  Provider.of<ProductProvider>(context, listen: false)
        //     .getLatestProductList(1, context);
        Provider.of<ProductProvider>(context, listen: false)
            .getLProductList("1", context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF1B7FED),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Icon(
            isIncrement
                ? Icons.add
                : quantity == 1
                    ? CupertinoIcons.minus
                    : Icons.remove,
            color: isIncrement
                ? quantity! >= maxQty! && !digitalProduct!
                    ? Colors.white
                    : Colors.white //ColorResources.getPrimary(context)
                : quantity! > 1
                    ? Colors.white //ColorResources.getPrimary(context)
                    : Colors.white,
            size: 30),
      ),
    );
  }
}
