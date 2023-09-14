import 'package:bed3a_ecommerce/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/provider/category_provider.dart';
import 'package:bed3a_ecommerce/view/screen/home/widget/category_widget.dart';
import 'package:bed3a_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import 'category_shimmer.dart';
import 'category_widget.dart';

class TopSellerCategoryView extends StatefulWidget {
  final bool isHomePage;

  TopSellerCategoryView({required this.isHomePage});

  @override
  State<TopSellerCategoryView> createState() => _TopSellerCategoryViewState();
}

class _TopSellerCategoryViewState extends State<TopSellerCategoryView>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        _tabController = TabController(
            length: categoryProvider.categoryList.length,
            initialIndex: 0,
            vsync: this);

        return categoryProvider.categoryList.length != 0
            ? TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                isScrollable: true,
                indicatorWeight: 4,
                padding: EdgeInsetsDirectional.zero,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                labelColor: Colors.black,
                unselectedLabelColor: Theme.of(context).disabledColor,
                unselectedLabelStyle: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                labelStyle: TextStyle(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                    color: Theme.of(context).primaryColor),
                tabs: List.generate(
                    categoryProvider.categoryList.length,
                    (index) => TopSellerCategoryWidget(
                        category: categoryProvider.categoryList[index])))
            : CategoryShimmer();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: categoryProvider.categoryList.length, initialIndex: 0, vsync: this);
  }
}
