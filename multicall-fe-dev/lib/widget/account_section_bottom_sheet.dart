import 'package:flutter/material.dart';
import 'package:multicall_mobile/screens/add_number_without_label.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_email_id_screen.dart';
import 'package:multicall_mobile/widget/bottom_sheet_option_with_icon.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountSectionBottomSheet extends StatelessWidget {
  const AccountSectionBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetOptionWithIcon(
                  iconSrc: PhosphorIconsDuotone.envelopeSimple,
                  title: "Add Email ID",
                  action: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(AddEmailIdScreen.routeName);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const HorizontalDivider(),
                const SizedBox(
                  height: 16,
                ),
                BottomSheetOptionWithIcon(
                  iconSrc: PhosphorIconsDuotone.deviceMobileCamera,
                  title: "Add Mobile Number",
                  action: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AddPhoneNumberWithoutLabelScreen(
                          headerText: "Add Mobile Number",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
