import 'package:flutter/material.dart';
import 'package:bed3a_ecommerce/helper/network_info.dart';
import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:bed3a_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:bed3a_ecommerce/localization/language_constrants.dart';
import 'package:bed3a_ecommerce/utill/images.dart';
import 'package:bed3a_ecommerce/view/screen/home/home_screens.dart';
import 'package:bed3a_ecommerce/view/screen/more/more_screen.dart';
import 'package:bed3a_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:bed3a_ecommerce/view/screen/order/order_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens ;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel!.businessMode == "single";


    _screens = [
      HomePage(),
     // singleVendor?OrderScreen(isBacButtonExist: false): InboxScreen(isBackButtonExist: false) ,
     OrderScreen(isBacButtonExist: false),
      NotificationScreen(isBacButtonExist: false),
     MoreScreen(),
    ];

    NetworkInfo.checkConnectivity(context);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textTheme.bodyLarge!.color,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: _getBottomWidget(singleVendor),
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(icon, color: index == _pageIndex ?
      Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
        height: 25, width: 25,
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> _list = [];

    if(!isSingleVendor){
      _list.add(_barItem(Images.home_image, getTranslated('home', context), 0));
      //_list.add(_barItem(Images.message_image, getTranslated('inbox', context), 1));
      _list.add(_barItem(Images.shopping_image, getTranslated('orders', context), 1));
      _list.add(_barItem(Images.notification, getTranslated('notification', context), 2));
      _list.add(_barItem(Images.more_image, getTranslated('more', context), 3));
    }else{
      _list.add(_barItem(Images.home_image, getTranslated('home', context), 0));
      _list.add(_barItem(Images.shopping_image, getTranslated('orders', context), 1));
      _list.add(_barItem(Images.notification, getTranslated('notification', context), 2));
      _list.add(_barItem(Images.more_image, getTranslated('more', context), 3));
    }

    return _list;
  }

}