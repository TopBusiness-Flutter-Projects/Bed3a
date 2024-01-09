import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/helper/product_type.dart';

import 'package:bed3a_ecommerce/provider/theme_provider.dart';
import 'package:bed3a_ecommerce/utill/color_resources.dart';
import 'package:bed3a_ecommerce/utill/custom_themes.dart';
import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:bed3a_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

import '../../../provider/product_provider.dart';

class AllProductScreen extends StatefulWidget {
  final ProductType productType;
  AllProductScreen({required this.productType});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false)
        .getLatestProductList(1, context, reload: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? Colors.black
            : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5))),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, size: 20, color: ColorResources.WHITE),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            widget.productType == ProductType.FEATURED_PRODUCT
                ? 'Featured Product'
                : 'الاكثر مبيعاً',
            style: titilliumRegular.copyWith(
                fontSize: 20, color: ColorResources.WHITE)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<ProductProvider>(context, listen: false)
                .getLatestProductList(1, context, reload: true);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ProductView(
                      isHomePage: false,
                      productType: widget.productType,
                      scrollController: _scrollController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
