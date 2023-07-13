import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultipleRegionDropdown extends StatefulWidget {
  final List<String> selectedItems;
  final List<String> firstRegionList;
  final List<String> secondRegionList;
  final List<String> thirdRegionList;
  final String titleHeading;

  const MultipleRegionDropdown(
      {Key? key,
      required this.firstRegionList,
      required this.secondRegionList,
      required this.thirdRegionList,
      required this.selectedItems,
      required this.titleHeading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultipleRegionDropdownState();
}

class _MultipleRegionDropdownState extends State<MultipleRegionDropdown> {
  @override
  void initState() {
    for (var element in widget.selectedItems) {
      _selectedItems.add(element);
    }
    super.initState();
  }

  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.titleHeading,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.defaultSize * 2.3,
            fontFamily: kHelveticaRegular),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.defaultSize),
              child: Text(
                AppLocalizations.of(context).newTerritories,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.defaultSize * 2,
                    fontFamily: kHelveticaMedium),
              ),
            ),
            ListBody(
              children: widget.firstRegionList
                  .map((item) => CheckboxListTile(
                        value: _selectedItems.contains(item),
                        title: Text(
                          item,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.defaultSize * 2.1,
                              fontFamily: kHelveticaRegular),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) => _itemChange(item, isChecked!),
                        activeColor: const Color(0xFFA08875),
                      ))
                  .toList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.defaultSize),
              child: Text(
                AppLocalizations.of(context).kowloon,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.defaultSize * 2.2,
                    fontFamily: kHelveticaMedium),
              ),
            ),
            ListBody(
              children: widget.secondRegionList
                  .map((item) => CheckboxListTile(
                        value: _selectedItems.contains(item),
                        title: Text(
                          item,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.defaultSize * 2.1,
                              fontFamily: kHelveticaRegular),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) => _itemChange(item, isChecked!),
                        activeColor: const Color(0xFFA08875),
                      ))
                  .toList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.defaultSize),
              child: Text(
                AppLocalizations.of(context).hongKongIsland,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.defaultSize * 2.2,
                    fontFamily: kHelveticaMedium),
              ),
            ),
            ListBody(
              children: widget.thirdRegionList
                  .map((item) => CheckboxListTile(
                        value: _selectedItems.contains(item),
                        title: Text(
                          item,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.defaultSize * 2.1,
                              fontFamily: kHelveticaRegular),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) => _itemChange(item, isChecked!),
                        activeColor: const Color(0xFFA08875),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize,
                vertical: SizeConfig.defaultSize * 0.5),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: TextStyle(
                  color: const Color(0xFFA08875),
                  fontSize: SizeConfig.defaultSize * 2.1,
                  fontFamily: kHelveticaRegular),
            ),
          ),
        ),
        ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA08875),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.defaultSize,
                  vertical: SizeConfig.defaultSize * 0.5),
              child: Text(
                AppLocalizations.of(context).confirm,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.defaultSize * 2.1,
                    fontFamily: kHelveticaRegular),
              ),
            )),
      ],
    );
  }
}
