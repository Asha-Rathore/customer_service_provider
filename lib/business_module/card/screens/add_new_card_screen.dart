import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../utils/app_navigation.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_sizebox.dart';
import '../../../widgets/custom_textfield.dart';

class AddNewCardScreen extends StatefulWidget {
  AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _accountHolderCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  final _expiryDateCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();
  final _cardFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomAppTemplate(
      title: AppStrings.ADD_NEW_CARD,
      child: CustomPadding(
        child: Form(
          key: _cardFormKey,
          child: Column(
            children: [
              CustomSizeBox(),
              const CustomDivider(),
              CustomSizeBox(height: 15.h),
              _accountHolderTextField(),
              CustomSizeBox(),
              _accountNumberTextField(),
              CustomSizeBox(),
              _expiryAndCvcTextField(),
              const Spacer(),
              _button(context),
              CustomSizeBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountHolderTextField() {
    return CustomTextField(
      hint: AppStrings.ACCOUNT_HOLDER,
      prefxicon: AssetPath.PERSON_ICON,
      keyboardType: TextInputType.name,
      validator: (value) => value?.validateEmpty(AppStrings.ACCOUNT_HOLDER),
      controller: _accountHolderCtrl,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _accountNumberTextField() {
    return CustomTextField(
      hint: AppStrings.ACCOUNT_NUMBER,
      prefxicon: AssetPath.CARD_ICON,
      keyboardType: TextInputType.number,
      validator: (value) => value?.validateEmpty(AppStrings.ACCOUNT_NUMBER),
      controller: _accountNumberCtrl,
      inputFormatters: [Constants.MASK_TEXT_FORMATTER_CARD_NO],
    );
  }

  Widget _expiryDateTextField() {
    return Expanded(
      child: CustomTextField(
        hint: AppStrings.EXPIRY_DATE,
        readOnly: true,
        validator: (value) => value?.validateEmpty(AppStrings.EXPIRY_DATE),
        controller: _expiryDateCtrl,
        onTap: () async {
          final selected = await showMonthYearPicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(3000),
          );
          setState(() {
            String formattedDate = DateFormat('MM/yy').format(selected!);
            _expiryDateCtrl.text = formattedDate;
          });
        },
      ),
    );
  }

  Widget _cvcTextField() {
    return Expanded(
      child: CustomTextField(
        hint: AppStrings.CVC,
        keyboardType: TextInputType.number,
        validator: (value) => value?.validateEmpty(AppStrings.CVC),
        controller: _cvcCtrl,
        inputFormatters: [
          LengthLimitingTextInputFormatter(Constants.CVC_LENGTH),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _expiryAndCvcTextField() {
    return Row(
      children: [
        _expiryDateTextField(),
        SizedBox(width: 10.w),
        _cvcTextField(),
      ],
    );
  }

  Widget _button(context) {
    return CustomButton(
      onTap: () => _cardValidationMethod(context),
      text: AppStrings.ADD,
    );
  }

  void _cardValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_cardFormKey.currentState!.validate()) {
      AppNavigation.navigatorPop(context);
    }
  }
}
