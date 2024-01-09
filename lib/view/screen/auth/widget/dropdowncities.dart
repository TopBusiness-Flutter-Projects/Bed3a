import 'package:bed3a_ecommerce/provider/splash_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/citiesmodel.dart';

class DropDownCities extends StatefulWidget {
  DropDownCities({required this.items, super.key});
  List<CitiesModel> items;
  @override
  State<DropDownCities> createState() => _DropDownCitiesState();
}

class _DropDownCitiesState extends State<DropDownCities> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<CitiesModel>(
              isExpanded: true,
              hint: Text(
                'اختر المدينه',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: widget.items
                  .map((CitiesModel item) => DropdownMenuItem<CitiesModel>(
                        value: item,
                        child: Text(
                          item.name ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: splash.selectedValue,
              onChanged: (CitiesModel? value) {
                setState(() {
                  splash.selectedValue = value;
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        );
      },
    );
  }
}
