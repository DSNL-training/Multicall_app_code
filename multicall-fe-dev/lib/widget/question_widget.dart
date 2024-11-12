import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final bool isLastQuestion;
  final VoidCallback? onPressed;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.isLastQuestion,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          trailing: (isLastQuestion)
              ? const SizedBox()
              : customIconButton(
                  iconData: PhosphorIcons.caretRight(),
                  onPressed: onPressed!,
                  size: 18,
                ),
          title: Text(
            question,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (!isLastQuestion)
          const Divider(
            color: Color.fromRGBO(221, 225, 228, 1),
            thickness: 1,
            endIndent: 0,
            indent: 0,
          ),
      ],
    );
  }
}
