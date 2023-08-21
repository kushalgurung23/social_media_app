import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomMultipleDropdown extends StatefulWidget {
  final List<String> selectedItems;
  final List<String> items;
  final String titleHeading;
  const CustomMultipleDropdown(
      {Key? key,
      required this.items,
      required this.selectedItems,
      required this.titleHeading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomMultipleDropdownState();
}

class _CustomMultipleDropdownState extends State<CustomMultipleDropdown> {
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
        child: ListBody(
          children: widget.items
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
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultSize,
              vertical: SizeConfig.defaultSize * 0.5),
          child: TextButton(
            onPressed: _cancel,
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
