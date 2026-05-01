import 'package:flutter/material.dart';
import 'package:intl_phone_field_v2/intl_phone_field.dart';
import 'package:intl_phone_field_v2/country_picker_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_util.dart';

class PhoneInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String initialCountryCode;

  const PhoneInput({
    super.key,
    required this.onChanged,
    this.initialCountryCode = 'US',
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: 'Phone Number',
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.scaleFontSize(14),
          color: AppColors.silverPlaceholder,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColors.silverBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColors.silverBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        counterText: '',
        filled: true,
        fillColor: AppColors.silverGlass,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.scaleWidth(20),
          vertical: context.scaleHeight(18),
        ),
      ),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: context.scaleFontSize(14),
        color: AppColors.foreground,
      ),
      dropdownTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: context.scaleFontSize(14),
        color: AppColors.foreground,
      ),
      initialCountryCode: initialCountryCode,
      disableLengthCheck: false,
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: AppColors.card,
        countryCodeStyle: TextStyle(
          fontFamily: 'Newsreader',
          fontSize: context.scaleFontSize(14),
          color: AppColors.foreground,
        ),
        countryNameStyle: TextStyle(
          fontFamily: 'Newsreader',
          fontSize: context.scaleFontSize(16),
          fontWeight: FontWeight.w700,
          color: AppColors.foreground,
        ),
        listTileDivider: Divider(
          color: AppColors.silverBorder.withValues(alpha: 0.3),
          height: 1,
        ),
        searchFieldInputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(
            color: AppColors.silverPlaceholder,
            fontFamily: 'Newsreader',
            fontSize: context.scaleFontSize(16),
          ),
          suffixIcon: Icon(Icons.search, color: AppColors.silverPlaceholder),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.silverBorder),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.silverBorder),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.accentBlue),
          ),
          filled: false,
          contentPadding: EdgeInsets.symmetric(
            vertical: context.scaleHeight(16),
            horizontal: context.scaleWidth(16),
          ),
        ),
      ),
      onChanged: (phone) => onChanged(phone.completeNumber),
    );
  }
}
