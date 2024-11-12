import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profile_details_screen.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/profile_card.dart';
import 'package:multicall_mobile/widget/profiles_section_bottom_sheet.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ProfilesScreen extends StatefulWidget {
  static const routeName = '/profiles_screen';

  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  int selectedContainerIndex = 0;

  void _selectContainer(int index) {
    setState(() {
      selectedContainerIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    ProfileController profileController =
        Provider.of<ProfileController>(context, listen: false);
    profileController.syncProfiles();
  }

  Widget buildHeading(String title, IconData icon, int index, Size size) {
    return GestureDetector(
      onTap: () => _selectContainer(index),
      child: Container(
        width: (size.width * 0.5) - 40,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedContainerIndex == index
                  ? Colors.blue
                  : const Color.fromRGBO(173, 181, 187, 1),
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  selectedContainerIndex == index ? Colors.blue : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selectedContainerIndex == index
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: selectedContainerIndex == index
                    ? Colors.blue
                    : const Color.fromRGBO(173, 181, 187, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(int index) {
    ProfileController profileController =
        Provider.of<ProfileController>(context, listen: true);

    List<Profile> retailProfiles =
        filterProfileByAccountType(profileController.profiles, 4);
    List<Profile> premiumProfiles =
        filterByNonAccountType(profileController.profiles, 4);

    // Helper function to create ProfileCard widgets with the last item check
    List<Widget> createProfileCards(List<Profile> profiles) {
      return profiles.asMap().entries.map((entry) {
        int idx = entry.key;
        Profile profile = entry.value;

        return ProfileCard(
          itemName: profile.profileName,
          isLastItem: idx == profiles.length - 1,
          // Check if it's the last item
          isActive: true,
          isDefault: profile.defaultProfileFlag == 1,
          onPressed: () {
            Navigator.pushNamed(
              context,
              ProfileDetailsScreen.routeName,
              arguments: {
                'profileRefNo': profile.profileRefNo,
                'isDefaultProfile': profile.defaultProfileFlag == 1,
              },
            );
          },
        );
      }).toList();
    }

    // Create a list of widgets based on the index value
    List<Widget> widgets = index == 0
        ? createProfileCards(retailProfiles)
        : createProfileCards(premiumProfiles);

    return Visibility(
      visible: selectedContainerIndex == index,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets, // Use the list of widgets
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text("Profiles"),
        trailing: DualToneIcon(
          iconSrc: PhosphorIconsDuotone.dotsThreeCircle,
          duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
          color: Colors.black,
          size: 16,
          padding: const Padding(padding: EdgeInsets.all(7)),
          press: () {
            showModalBottomSheet<void>(
                isScrollControlled: true,
                showDragHandle: true,
                context: context,
                builder: (BuildContext context) {
                  return const ProfilesSectionBottomSheet();
                });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomStyledContainer(
                height: double.infinity,
                width: size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildHeading(
                          'Personal Profile',
                          PhosphorIconsRegular.userCircle,
                          0,
                          size,
                        ),
                        buildHeading(
                          'Business Profile',
                          PhosphorIconsRegular.briefcase,
                          1,
                          size,
                        ),
                      ],
                    ),
                    buildContainer(0),
                    buildContainer(1),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Profiles help you segregate your spends between personal, work, social etc. You can select different plans, configure different email ID’s, mobiles numbers, and notifications for each of your profiles.",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color.fromRGBO(110, 122, 132, 1)),
            ),
          ],
        ),
      ),
    );
  }
}

List<Profile> filterProfileByAccountType(
    List<Profile> profiles, int accountType) {
  return profiles
      .where((profile) => profile.accountType == accountType)
      .toList();
}

List<Profile> filterByNonAccountType(List<Profile> profiles, int accountType) {
  return profiles
      .where((profile) => profile.accountType != accountType)
      .toList();
}
