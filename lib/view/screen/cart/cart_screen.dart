import 'package:bed3a_ecommerce/data/model/response/top_seller_model.dart';
import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/data/model/response/cart_model.dart';
import 'package:bed3a_ecommerce/helper/price_converter.dart';
import 'package:bed3a_ecommerce/localization/language_constrants.dart';
import 'package:bed3a_ecommerce/provider/auth_provider.dart';
import 'package:bed3a_ecommerce/provider/cart_provider.dart';
import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:bed3a_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:bed3a_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:bed3a_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:bed3a_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:bed3a_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:bed3a_ecommerce/view/screen/cart/widget/cart_widget.dart';
import 'package:bed3a_ecommerce/view/screen/checkout/checkout_screen.dart';
import 'package:bed3a_ecommerce/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../product/product_details_screen.dart';
import '../topSeller/top_seller_product_screen.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  CartScreen({this.fromCheckout = false, this.sellerId = 1});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _loadData() async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<CartProvider>(context, listen: false)
          .getCartDataAPI(context);
      Provider.of<CartProvider>(context, listen: false).setCartData();

      if (Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .shippingMethod !=
          'sellerwise_shipping') {
        Provider.of<CartProvider>(context, listen: false)
            .getAdminShippingMethodList(context);
      }
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      double amount = 0.0;
      double shippingAmount = 0.0;
      double discount = 0.0;
      double tax = 0.0;
      bool _onlyDigital = true;
      List<CartModel> cartList = [];
      cartList.addAll(cart.cartList);
      for (CartModel cart in cartList) {
        if (cart.productType == "physical") {
          _onlyDigital = false;
          print('is digital product only?====>$_onlyDigital');
        }
      }

      List<String?> orderTypeShipping = [];
      List<String?> sellerList = [];
      List<CartModel> sellerGroupList = [];
      List<List<CartModel>> cartProductList = [];
      List<List<int>> cartProductIndexList = [];
      for (CartModel cart in cartList) {
        if (!sellerList.contains(cart.cartGroupId)) {
          sellerList.add(cart.cartGroupId);
          sellerGroupList.add(cart);
        }
      }

      for (String? seller in sellerList) {
        List<CartModel> cartLists = [];
        List<int> indexList = [];
        for (CartModel cart in cartList) {
          if (seller == cart.cartGroupId) {
            cartLists.add(cart);
            indexList.add(cartList.indexOf(cart));
          }
        }
        cartProductList.add(cartLists);
        cartProductIndexList.add(indexList);
      }

      sellerGroupList.forEach((seller) {
        if (seller.shippingType == 'order_wise') {
          orderTypeShipping.add(seller.shippingType);
        }
      });

      if (cart.getData &&
          Provider.of<AuthProvider>(context, listen: false).isLoggedIn() &&
          Provider.of<SplashProvider>(context, listen: false)
                  .configModel!
                  .shippingMethod ==
              'sellerwise_shipping') {
        Provider.of<CartProvider>(context, listen: false)
            .getShippingMethod(context, cartProductList);
      }

      for (int i = 0; i < cart.cartList.length; i++) {
        amount += (cart.cartList[i].price! - cart.cartList[i].discount!) *
            cart.cartList[i].quantity!;
        discount += cart.cartList[i].discount! * cart.cartList[i].quantity!;
        print('====TaxModel == ${cart.cartList[i].taxModel}');
        if (cart.cartList[i].taxModel == "exclude") {
          tax += cart.cartList[i].tax! * cart.cartList[i].quantity!;
        }
      }
      for (int i = 0; i < cart.chosenShippingList.length; i++) {
        shippingAmount += cart.chosenShippingList[i].shippingCost!;
      }
      for (int j = 0; j < cartList.length; j++) {
        shippingAmount += cart.cartList[j].shippingCost ?? 0;
      }

      bool checkConditionForAllItems(List<CartModel> sellerGroupList) {
        for (int i = 0; i < sellerGroupList.length; i++) {
          if (!(sellerGroupList[i].quantity! >=
                  sellerGroupList[i].limitProduct!) ||
              !((sellerGroupList[i].price! * sellerGroupList[i].quantity!) >=
                  sellerGroupList[i].limitPrice!)) {
            return false;
          }
        }
        return true;
      }

      double calculateTotalCost(List<CartModel> cartProductLists) {
        double totalCosts = 0.0;
        for (var cart in cartProductLists) {
          double productTotalCost = (cart.price! * cart.quantity!);
          totalCosts += productTotalCost;
        }
        return totalCosts;
      }

      int calculateTotalCount(List<CartModel> cartProductLists) {
        int totalCount = 0;
        for (var cart in cartProductLists) {
          int productTotalCost = (cart.quantity!);
          totalCount += productTotalCost;
        }
        return totalCount;
      }

      return Scaffold(
        bottomNavigationBar: (!widget.fromCheckout && !cart.isLoading)
            ? Container(
                height: 80,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE,
                    vertical: Dimensions.PADDING_SIZE_DEFAULT),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                ),
                child: cartList.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                                child: Center(
                                    child: Column(
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${getTranslated('total_price', context)}',
                                        style: titilliumSemiBold.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT),
                                      ),
                                      Text(
                                        PriceConverter.convertPrice(
                                            context, amount + shippingAmount),
                                        style: titilliumSemiBold.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            decorationThickness: 1.5,
                                            decoration:
                                                cartList[0].hasDiscount != 0
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                            decorationColor: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${getTranslated('total_price_dis', context)}',
                                      style: titilliumSemiBold.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_DEFAULT),
                                    ),
                                    Text(
                                      PriceConverter.convertPrice(
                                          context, amount + shippingAmount,
                                          discount: double.parse(cartList[0]
                                              .discountPercent
                                              .toString()),
                                          discountType: 'percent'),
                                      style: titilliumSemiBold.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                            Builder(
                              builder: (context) => InkWell(
                                onTap: () {
                                  // if () {}
                                  if (Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .isLoggedIn()) {
                                    if (cart.cartList.length == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(getTranslated(
                                                'select_at_least_one_product',
                                                context) ??
                                            ''),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else if (cart.chosenShippingList.length <
                                            orderTypeShipping.length &&
                                        Provider.of<SplashProvider>(context,
                                                    listen: false)
                                                .configModel!
                                                .shippingMethod ==
                                            'sellerwise_shipping' &&
                                        !_onlyDigital) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(getTranslated(
                                                  'select_all_shipping_method',
                                                  context)!),
                                              backgroundColor: Colors.red));
                                    } else if (cart.chosenShippingList.length <
                                            1 &&
                                        Provider.of<SplashProvider>(context,
                                                    listen: false)
                                                .configModel!
                                                .shippingMethod !=
                                            'sellerwise_shipping' &&
                                        Provider.of<SplashProvider>(context,
                                                    listen: false)
                                                .configModel!
                                                .inHouseSelectedShippingType ==
                                            'order_wise' &&
                                        !_onlyDigital) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(getTranslated(
                                                  'select_all_shipping_method',
                                                  context)!),
                                              backgroundColor: Colors.red));
                                    } else {
                                      bool conditionMet =
                                          checkConditionForAllItems(
                                              sellerGroupList);
                                      if (conditionMet) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => CheckoutScreen(
                                                      cartList: cartList,
                                                      totalOrderAmount: amount,
                                                      shippingFee:
                                                          shippingAmount,
                                                      discount: double.parse(
                                                          cartList[0]
                                                              .discountPercent
                                                              .toString()),
                                                      tax: tax,
                                                      onlyDigital: _onlyDigital,
                                                    )));
                                      } else {
                                        //  Flutter
                                        showCustomSnackBar(
                                            isToaster: true,
                                            "من فضلك تخطي الحد الادني من كل تاجر",
                                            context);
                                      }
                                    }
                                  } else {
                                    showAnimatedDialog(context, GuestDialog(),
                                        isFlip: true);
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.PADDING_SIZE_SMALL),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL,
                                          vertical: Dimensions.FONT_SIZE_SMALL),
                                      child: Text(
                                          getTranslated('checkout', context)!,
                                          style: titilliumSemiBold.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            color: Theme.of(context).cardColor,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])
                    : SizedBox(),
              )
            : null,
        body: Column(children: [
          CustomAppBar(title: getTranslated('CART', context)),
          cart.isXyz
              ? Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              : sellerList.length != 0
                  ? Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  if (Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .isLoggedIn()) {
                                    await Provider.of<CartProvider>(context,
                                            listen: false)
                                        .getCartDataAPI(context);
                                  }
                                },
                                child: ListView.builder(
                                  itemCount: sellerList.length,
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            sellerGroupList[index]
                                                    .shopInfo!
                                                    .isNotEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          child: Text(
                                                              sellerGroupList[
                                                                      index]
                                                                  .shopInfo!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style:
                                                                  titilliumSemiBold
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .FONT_SIZE_LARGE,
                                                              )),
                                                        ),
                                                        MaterialButton(
                                                            color: Colors.blue,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) => TopSellerProductScreen(
                                                                          // topSellerId: cartList[index]
                                                                          //     .sellerId,
                                                                          topSeller: TopSellerModel(address: cartList[index].sellerInfo!.address, banner: cartList[index].sellerInfo!.banner, contact: cartList[index].sellerInfo!.contact, createdAt: cartList[index].sellerInfo!.createdAt, id: cartList[index].sellerInfo!.id, image: cartList[index].sellerInfo!.image, name: cartList[index].sellerInfo!.name, sellerId: cartList[index].sellerId, temporaryClose: cartList[index].sellerInfo!.temporaryClose, updatedAt: cartList[index].sellerInfo!.updatedAt, vacationEndDate: cartList[index].sellerInfo!.vacationEndDate, vacationStartDate: cartList[index].sellerInfo!.vacationStartDate, vacationStatus: cartList[index].sellerInfo!.vacationStatus))));
                                                            },
                                                            child: Text(
                                                              'إضافة منتج',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Card(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .highlightColor,
                                                ),
                                                child: Column(
                                                  children: [
                                                    ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      itemCount:
                                                          cartProductList[index]
                                                              .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return CartWidget(
                                                          cartModel:
                                                              cartProductList[
                                                                  index][i],
                                                          index:
                                                              cartProductIndexList[
                                                                  index][i],
                                                          fromCheckout: widget
                                                              .fromCheckout,
                                                        );
                                                      },
                                                    ),
                                                    Provider.of<SplashProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .configModel!
                                                                    .shippingMethod ==
                                                                'sellerwise_shipping' &&
                                                            sellerGroupList[
                                                                        index]
                                                                    .shippingType ==
                                                                'order_wise' &&
                                                            !_onlyDigital
                                                        ? Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .PADDING_SIZE_DEFAULT),
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (Provider.of<
                                                                            AuthProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .isLoggedIn()) {
                                                                  showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    builder: (context) => ShippingMethodBottomSheet(
                                                                        groupId:
                                                                            sellerGroupList[index]
                                                                                .cartGroupId,
                                                                        sellerIndex:
                                                                            index,
                                                                        sellerId:
                                                                            sellerGroupList[index].id),
                                                                  );
                                                                } else {
                                                                  showCustomSnackBar(
                                                                      'not_logged_in',
                                                                      context);
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            getTranslated('SHIPPING_PARTNER',
                                                                                context)!,
                                                                            style:
                                                                                titilliumRegular),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            (cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.length == 0 || cart.shippingList![index].shippingIndex == -1)
                                                                                ? ''
                                                                                : '${cart.shippingList![index].shippingMethodList![cart.shippingList![index].shippingIndex!].title.toString()}',
                                                                            style:
                                                                                titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                        Icon(
                                                                            Icons
                                                                                .keyboard_arrow_down,
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            44),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                            'الحد الادني: ${sellerGroupList[index].limitPrice}'),
                                                        Text(
                                                            'أقل عدد منتجات : ${sellerGroupList[index].limitProduct}'),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          'إجمال الطلب: ${calculateTotalCost(cartProductList[index])}',
                                                          style: TextStyle(
                                                              color: (calculateTotalCost(
                                                                          cartProductList[
                                                                              index]) <
                                                                      sellerGroupList[
                                                                              index]
                                                                          .limitPrice!)
                                                                  ? Colors.red
                                                                  : Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          ' عدد منتجات: ${sellerGroupList[index].quantity.toString()}',
                                                          style: TextStyle(
                                                              color: (calculateTotalCost(
                                                                          cartProductList[
                                                                              index]) <
                                                                      sellerGroupList[
                                                                              index]
                                                                          .limitPrice!)
                                                                  ? Colors.red
                                                                  : Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                          ]),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Provider.of<SplashProvider>(context, listen: false)
                                            .configModel!
                                            .shippingMethod !=
                                        'sellerwise_shipping' &&
                                    Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .configModel!
                                            .inHouseSelectedShippingType ==
                                        'order_wise'
                                ? InkWell(
                                    onTap: () {
                                      if (Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .isLoggedIn()) {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                ShippingMethodBottomSheet(
                                                    groupId: 'all_cart_group',
                                                    sellerIndex: 0,
                                                    sellerId: 1));
                                      } else {
                                        showCustomSnackBar(
                                            'not_logged_in', context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  getTranslated(
                                                      'SHIPPING_PARTNER',
                                                      context)!,
                                                  style: titilliumRegular),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      (cart.shippingList == null ||
                                                              cart.chosenShippingList
                                                                      .length ==
                                                                  0 ||
                                                              cart.shippingList!
                                                                      .length ==
                                                                  0 ||
                                                              cart
                                                                      .shippingList![
                                                                          0]
                                                                      .shippingMethodList ==
                                                                  null ||
                                                              cart.shippingList![0]
                                                                      .shippingIndex ==
                                                                  -1)
                                                          ? ''
                                                          : '${cart.shippingList![0].shippingMethodList![cart.shippingList![0].shippingIndex!].title.toString()}',
                                                      style: titilliumSemiBold
                                                          .copyWith(
                                                              color: ColorResources
                                                                  .getPrimary(
                                                                      context)),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                        width: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                    Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ]),
                                            ]),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: NoInternetOrDataScreen(isNoInternet: false)),
        ]),
      );
    });
  }
}
