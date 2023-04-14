import "package:cash_flow/app/widgets/button/cc_button.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:dropdown_search2/dropdown_search2.dart";
import "package:flutter/material.dart";

class CCDropdownWithSearch extends StatelessWidget {
  final String label;
  final IconData icon;
  final String selectedItem;
  final List<String> items;
  final String messageNotFound;
  final String? addButtonText;
  final Function(String) onChanged;
  final Function()? addButtonOnPressed;

  const CCDropdownWithSearch({
    Key? key,
    required this.label,
    required this.icon,
    required this.selectedItem,
    required this.items,
    required this.messageNotFound,
    this.addButtonText,
    required this.onChanged,
    this.addButtonOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      selectedItem: selectedItem,
      onChanged: (value) => onChanged(value!),
      showSearchBox: true,
      mode: Mode.BOTTOM_SHEET,
      dropdownSearchDecoration: InputDecoration(
        label: Text(label),
        iconColor: primary,
        icon: Icon(icon),
      ),
      searchFieldProps: TextFieldProps(
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          prefixIcon: Icon(searchIcon),
        ),
      ),
      emptyBuilder: (context, searchEntry) => Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(messageNotFound),
              const SizedBox(height: 16),
              if (addButtonText != null)
                CCButton.primaryContainer(
                  textButton: addButtonText!,
                  onPressed: addButtonOnPressed,
                ),
            ],
          ),
        ),
      ),
      items: items,
    );
  }
}
