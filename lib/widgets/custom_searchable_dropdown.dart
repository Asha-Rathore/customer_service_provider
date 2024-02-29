import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_size.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_fonts.dart';

class CustomSearchableDropDown extends StatefulWidget {
  final String? dropdownValue;
  final String? hintText;
  final List<String>? dropDownData;
  final Function(List<String>?)? onChanged;
  final double? width, fontSize;
  final Color? borderColor;
  final double? horizontalPadding;
  final bool isMultiSelection;
  final Widget? prefix;
  final bool? showSearchField, showTags;
  final List<String>? selectedItems;
  final String? Function(String?)? singleValueValidator;
  final String? Function(List<String>?)? multiValueValidator;

  const CustomSearchableDropDown({
    Key? key,
    this.dropDownData,
    this.borderColor = Colors.red,
    this.dropdownValue,
    this.width,
    this.onChanged,
    this.fontSize = 15,
    this.hintText,
    this.singleValueValidator,
    this.isMultiSelection = false,
    this.multiValueValidator,
    this.prefix,
    this.horizontalPadding,
    this.selectedItems,
    this.showSearchField = true,
    this.showTags = true,
  }) : super(key: key);

  @override
  State<CustomSearchableDropDown> createState() =>
      _CustomSearchableDropDownState();
}

class _CustomSearchableDropDownState extends State<CustomSearchableDropDown> {
  // late String _value;

  @override
  void initState() {
    // _value = widget.dropdownValue ?? widget.dropDownData![0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _multiSelectionSearchDropDown();
  }

  Widget _multiSelectionSearchDropDown() {
    return DropdownSearch<String>.multiSelection(
      key: Key(Constants.getCurrentTimeStamp()),
      hintTextForMultipleSelection: widget.hintText ?? "",
      validator: widget.multiValueValidator,
      dropdownButtonProps: _dropDownButtonProps(),
      selectedItems: widget.selectedItems ?? [],
      popupProps: PopupPropsMultiSelection.dialog(
          showSearchBox: widget.showSearchField!,
          searchFieldProps: _searchTextfieldProps(),
          fit: FlexFit.loose),
      items: widget.dropDownData ?? [],
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: _dropDownSearchDecoration(),
      ),
      onChanged: widget.onChanged,
      textStyle: _textStyle(color: AppColors.THEME_COLOR_BLACK),
      buttonTextStyle: _buttonTextStyle(),
      showTags: widget.showTags,
      //selectedItem: widget.dropdownValue,
    );
  }

  DropdownButtonProps _dropDownButtonProps() {
    return DropdownButtonProps(
      color: const Color(0xff9D9FA2),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(AppSize.FULL_SCREEN_WIDTH, 20.h),
        ),
      ),
      // constraints: BoxConstraints(minHeight: 20.h, maxHeight: 20.h),
      icon: const Icon(
        Icons.expand_more_outlined,
      ),
    );
  }

  TextFieldProps _searchTextfieldProps() {
    return TextFieldProps(
      // padding: const EdgeInsets.all(0.0),
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: _textStyle(),
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  InputDecoration _dropDownSearchDecoration() {
    return InputDecoration(
      filled: true,
      errorStyle: _errorStyle(),
      prefix: widget.prefix,
      fillColor: AppColors.THEME_COLOR_OFF_WHITE,
      border: _outlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      hintText: widget.hintText ?? "",
      hintStyle: _textStyle(),
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.r),
      borderSide: const BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );
  }

  TextStyle _errorStyle() {
    return const TextStyle(
      color: Colors.red,
      height: 0.8,
    );
  }

  TextStyle _textStyle({Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      color: color ?? AppColors.THEME_COLOR_LIGHT_GREY,
      fontFamily: AppFonts.Jost_Medium,
    );
  }

  TextStyle _buttonTextStyle() {
    return TextStyle(
      fontSize: 14.sp,
      color: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Jost_Medium,
    );
  }
}
