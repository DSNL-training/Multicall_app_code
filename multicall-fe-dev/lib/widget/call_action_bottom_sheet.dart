import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/bottom_sheet_option_with_icon.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CallActionBottomSheet extends StatelessWidget {
  const CallActionBottomSheet({
    super.key,
    required this.name,
    required this.contactNumber,
  });

  final String name;
  final String contactNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetOptionWithIcon(
                  iconSrc: PhosphorIconsDuotone.phoneCall,
                  title: "Call",
                  action: () {},
                ),
                const SizedBox(
                  height: 16,
                ),
                const HorizontalDivider(),
                const SizedBox(
                  height: 16,
                ),
                BottomSheetOptionWithIcon(
                  iconSrc: PhosphorIconsDuotone.trash,
                  title: "Remove",
                  action: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
