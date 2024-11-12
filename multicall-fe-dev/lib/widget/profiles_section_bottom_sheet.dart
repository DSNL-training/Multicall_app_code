import 'package:flutter/material.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/add_business_profile_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/create_profile_screen.dart';
import 'package:multicall_mobile/widget/bottom_sheet_option_with_icon.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfilesSectionBottomSheet extends StatelessWidget {
  const ProfilesSectionBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomSheetOptionWithIcon(
                iconSrc: PhosphorIconsDuotone.userCircle,
                title: "Create New Profile",
                action: () {
                  Navigator.of(context)
                      .pushNamed(CreateProfileScreen.routeName);
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
                iconSrc: PhosphorIconsDuotone.briefcase,
                title: "Add Business Profile",
                action: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pushNamed(AddBusinessProfileScreen.routeName);
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
