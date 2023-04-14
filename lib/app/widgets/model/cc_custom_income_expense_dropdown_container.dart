import "package:cash_flow/core/values/colors.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class CCCustomIncomeExpenseDropdownContainer extends StatelessWidget {
  final RxString dropdownValue;
  final List<String> list;
  final Function onChanged;

  const CCCustomIncomeExpenseDropdownContainer({
    Key? key,
    required this.dropdownValue,
    required this.list,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Obx(
        () => dropdownValue.value == "Receita"
            ? incomeContainer(
                dropdownItem(context, dropdownValue, list),
              )
            : expenseContainer(
                dropdownItem(context, dropdownValue, list),
              ),
      ),
    );
  }

  Widget dropdownItem(
    BuildContext context,
    RxString dropdownValue,
    List<String> list,
  ) {
    return DropdownButton<String>(
      isDense: true,
      style: Theme.of(context).textTheme.titleSmall,
      iconEnabledColor: dropdownValue.value == "Receita" ? success : error,
      value: dropdownValue.value,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: value == "Receita" ? success : error,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        dropdownValue.value = value!;
        onChanged(value);
      },
    );
  }

  Widget incomeContainer(Widget widget) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        right: 4,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: successContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: success,
        ),
      ),
      child: widget,
    );
  }

  Widget expenseContainer(Widget widget) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        right: 4,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: error,
        ),
      ),
      child: widget,
    );
  }
}
