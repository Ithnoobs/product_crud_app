import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SortDropdownRow extends StatelessWidget {
  final List<String> sortFields;
  final Map<String, List<String>> sortOrders;
  final String selectedSortField;
  final String selectedSortOrder;
  final ValueChanged<String> onSortFieldChanged;
  final ValueChanged<String> onSortOrderChanged;

  const SortDropdownRow({
    super.key,
    required this.sortFields,
    required this.sortOrders,
    required this.selectedSortField,
    required this.selectedSortOrder,
    required this.onSortFieldChanged,
    required this.onSortOrderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double firstDropdownWidth = 180;
    final Color borderColor = Theme.of(context).colorScheme.outlineVariant;
    final Color fillColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final Color iconColor = Theme.of(context).colorScheme.primary;
    final Color textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: firstDropdownWidth,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
              isExpanded: true,
              value: selectedSortField,
              items: sortFields
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) onSortFieldChanged(value);
              },
              buttonStyleData: ButtonStyleData(
                height: 44,
                width: firstDropdownWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                  ),
                  color: fillColor,
                ),
                elevation: 1,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 22,
                iconEnabledColor: iconColor,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 220,
                width: firstDropdownWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: fillColor,
                ),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(20),
                  thickness: WidgetStateProperty.all(5),
                  thumbVisibility: WidgetStateProperty.all(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: selectedSortOrder,
              items: (sortOrders[selectedSortField] ?? [])
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) onSortOrderChanged(value);
              },
              buttonStyleData: ButtonStyleData(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor,
                  ),
                  color: fillColor,
                ),
                elevation: 1,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 22,
                iconEnabledColor: iconColor,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: fillColor,
                ),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(20),
                  thickness: WidgetStateProperty.all(5),
                  thumbVisibility: WidgetStateProperty.all(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}