import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/widgets/press_scale_animation.dart';

class CountryDropdown extends StatelessWidget {
  final Country? selectedCountry;
  final ValueChanged<Country> onSelected;

  const CountryDropdown({
    super.key,
    this.selectedCountry,
    required this.onSelected,
  });

  void _showPicker(BuildContext context) {
    final countries = CountryService().getAll();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: context.scaleHeight(600)),
          child: _CustomCountryPickerDialog(
            countries: countries,
            onCountrySelected: onSelected,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: () => _showPicker(context),
      child: Container(
        height: context.scaleHeight(56),
        padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.silverBorder, width: 1.185),
        ),
        child: Row(
          children: [
            Text(
              selectedCountry != null
                  ? "${selectedCountry!.flagEmoji}  ${selectedCountry!.name}"
                  : "Select Country",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.scaleFontSize(14),
                color: selectedCountry != null
                    ? AppColors.foreground
                    : AppColors.silverPlaceholder,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.expand_more,
              color: AppColors.silverPlaceholder,
              size: context.scaleWidth(20),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomCountryPickerDialog extends StatefulWidget {
  final List<Country> countries;
  final ValueChanged<Country> onCountrySelected;

  const _CustomCountryPickerDialog({
    required this.countries,
    required this.onCountrySelected,
  });

  @override
  State<_CustomCountryPickerDialog> createState() =>
      _CustomCountryPickerDialogState();
}

class _CustomCountryPickerDialogState
    extends State<_CustomCountryPickerDialog> {
  late List<Country> _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries.where((c) {
          return c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.phoneCode.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleWidth(16),
            vertical: context.scaleHeight(16),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _filter,
            style: TextStyle(
              color: AppColors.foreground,
              fontFamily: 'Newsreader',
              fontSize: context.scaleFontSize(16),
            ),
            decoration: InputDecoration(
              hintText: 'Search country',
              hintStyle: TextStyle(
                color: AppColors.silverPlaceholder,
                fontFamily: 'Newsreader',
                fontSize: context.scaleFontSize(16),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: AppColors.silverPlaceholder,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.silverBorder),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.silverBorder),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accentBlue),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _filteredCountries.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.silverBorder.withValues(alpha: 0.3),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final country = _filteredCountries[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.scaleWidth(24),
                ),
                leading: Text(
                  country.flagEmoji,
                  style: TextStyle(fontSize: context.scaleFontSize(24)),
                ),
                title: Text(
                  country.name,
                  style: TextStyle(
                    fontFamily: 'Newsreader',
                    fontSize: context.scaleFontSize(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                onTap: () {
                  widget.onCountrySelected(country);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
