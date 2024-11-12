import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/clickable_row_with_icon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OptionSelector extends StatelessWidget {
  const OptionSelector({
    super.key,
    required this.title,
    this.isSelected,
    required this.clickFunction,
    this.leftIconClick,
    required this.isLastItem,
    required this.isLeftIconReq,
    this.toolTipText,
  });

  final String title;
  final bool? isSelected;
  final bool isLastItem;
  final String? toolTipText;
  final bool isLeftIconReq;
  final VoidCallback clickFunction;
  final VoidCallback? leftIconClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClickableRowWithIcon(
          clickFunction: clickFunction,
          leftIconClickFunction: leftIconClick,
          leftIcon: isLeftIconReq ? PhosphorIconsRegular.info : null,
          toolTipText: toolTipText,
          rightIcon: isSelected == true ? PhosphorIconsRegular.check : null,
          title: title,
          iconColor: Colors.green,
        ),
        if (!isLastItem)
          const Divider(
            color: Color.fromRGBO(205, 211, 215, 1),
          ),
      ],
    );
  }
}
