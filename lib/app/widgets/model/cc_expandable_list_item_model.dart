import "package:cash_flow/app/widgets/card/cc_card.dart";
import "package:cash_flow/app/widgets/dialog/cc_dialog.dart";
import "package:cash_flow/core/utils/date_manager_utils.dart";
import "package:cash_flow/core/values/colors.dart";
import "package:cash_flow/core/values/keys.dart";
import "package:cash_flow/data/model/cash_flow_model.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";

class CCExpandableListItemModel extends StatelessWidget {
  final CashFlowModel cashFlowItem;
  final Color titleColor;
  final Color subtitleColor;
  final IconData iconLeading;
  final Color iconLeadingColor;
  final Color backgroundColor;
  final Function(int) deleteIconOnPressed;
  final Function(CashFlowModel) updateIconOnPressed;

  const CCExpandableListItemModel.income({
    Key? key,
    required this.cashFlowItem,
    this.titleColor = onSuccessContainer,
    this.subtitleColor = onSuccessContainer,
    this.iconLeading = incomeIcon,
    this.iconLeadingColor = onSuccessContainer,
    this.backgroundColor = successContainer,
    required this.deleteIconOnPressed,
    required this.updateIconOnPressed,
  }) : super(key: key);

  const CCExpandableListItemModel.expense({
    Key? key,
    required this.cashFlowItem,
    this.titleColor = onErrorContainer,
    this.subtitleColor = onErrorContainer,
    this.iconLeading = expenseIcon,
    this.iconLeadingColor = onErrorContainer,
    this.backgroundColor = errorContainer,
    required this.deleteIconOnPressed,
    required this.updateIconOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CCDialog ccDialog = CCDialog();
    final RxBool expansionOpen = false.obs;
    return CCCard(
      widgets: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (value) => expansionOpen.value = value,
            leading: Icon(
              iconLeading,
              color: iconLeadingColor,
            ),
            trailing: Obx(
              () => Icon(
                expansionOpen.value ? chevronUpIcon : chevronDownIcon,
                color: iconLeadingColor,
                size: 16,
              ),
            ),
            title: Text(
              cashFlowItem.category,
              style: TextStyle(
                color: titleColor,
              ),
            ),
            // textColor: controller.getCashFlowItemTextColor(item.type).value,
            subtitle: Text(
              cashFlowItem.description,
              style: TextStyle(
                color: subtitleColor,
              ),
            ),
            expandedAlignment: Alignment.topLeft,
            children: <Widget>[
              cashFlowItem.settledIn != null
                  ? _defaultExpansionTile(context, cashFlowItem)
                  : _customExpansionTile(context, cashFlowItem),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: cashFlowItem.observation!.isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        ccDialog.dialogPositiveButton(
                          title: "Anotação",
                          contentText: "${cashFlowItem.observation}",
                          onPressedPositiveButton: Get.back,
                        );
                      },
                      icon: const Icon(
                        observationOutlineIcon,
                        color: secondary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ccDialog.dialogNeutralAndPositiveButton(
                        title: "Aviso",
                        contentText: "Tem certeza que deseja apagar este item?",
                        nameNeutralButton: "Cancelar",
                        namePositiveButton: "Apagar",
                        onPressedNeutralButton: Get.back,
                        onPressedPositiveButton: () =>
                            deleteIconOnPressed(cashFlowItem.id!),
                      );
                    },
                    icon: const Icon(
                      trashIcon,
                      color: secondary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ccDialog.dialogNeutralAndPositiveButton(
                        title: "Editar",
                        contentText:
                            "Deseja atualizar as informações do item selecionado?",
                        nameNeutralButton: "Cancelar",
                        namePositiveButton: "Editar",
                        onPressedNeutralButton: Get.back,
                        onPressedPositiveButton: () =>
                            updateIconOnPressed(cashFlowItem),
                      );
                    },
                    icon: const Icon(
                      editOutlineIcon,
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
      backgroundColor: backgroundColor,
    );
  }

  Widget _defaultExpansionTile(BuildContext context, CashFlowModel item) {
    final DateManagerUtils dateManagerUtils = DateManagerUtils();
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(text: "Conta liquidada no dia "),
          textSpanStyleBodyMedium(
            context,
            dateManagerUtils.formatDate("${item.settledIn!}"),
          ),
          const TextSpan(text: " no valor de "),
          textSpanStyleBodyMedium(
            context,
            "${NumberFormat.simpleCurrency(locale: "pt-br").format(item.value)}.",
          ),
        ],
      ),
    );
  }

  Widget _customExpansionTile(BuildContext context, CashFlowModel item) {
    final DateManagerUtils dateManagerUtils = DateManagerUtils();
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          const TextSpan(
            text: "Este item ainda não foi liquidado.\nData de vencimento: ",
          ),
          textSpanStyleBodyMedium(
            context,
            dateManagerUtils.formatDate("${item.dueDate}"),
          ),
          const TextSpan(text: " no valor de "),
          textSpanStyleBodyMedium(
            context,
            "${NumberFormat.simpleCurrency(locale: "pt-br").format(item.value)}.",
          ),
        ],
      ),
    );
  }

  TextSpan textSpanStyleBodyMedium(BuildContext context, String text) {
    return TextSpan(
      text: text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}
