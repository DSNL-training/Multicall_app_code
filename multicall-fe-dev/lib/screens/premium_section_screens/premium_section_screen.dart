import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/profile_plan_details.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/menu_options.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class PremiumSectionScreen extends StatefulWidget {
  static const routeName = '/premium';

  const PremiumSectionScreen({super.key});

  @override
  State<PremiumSectionScreen> createState() => _PremiumSectionScreenState();
}

class _PremiumSectionScreenState extends State<PremiumSectionScreen> {
  void navigateToHomeScreen(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.onItemTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text(
          "Premium",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24.0,
          ),
        ),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.youtubeLogo,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              margin: 0,
              press: () {
                launchURL("https://youtube.com/watch?v=ZaZfWmd6vBc");
              },
            ),
            const SizedBox(
              width: 16,
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.note,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              margin: 0,
              press: () {
                launchURL("https://www.multicall.in/blog/");
              },
            ),
            const SizedBox(
              width: 16,
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.headset,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              margin: 0,
              press: () {
                launchURL("tel:04446741321");
              },
            ),
          ],
        ),
        showBackButton: false,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          navigateToHomeScreen(context);
          return;
        },
        child: Consumer<ProfileController>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Column(
                            children:
                                filterProfileByAccountType(provider.profiles, 4)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                              int idx = entry.key;
                              String option = entry.value.profileName;
                              return MenuOptions(
                                itemName: option,
                                padding: EdgeInsets.zero,
                                isLastItem: idx ==
                                    filterProfileByAccountType(
                                                provider.profiles, 4)
                                            .length -
                                        1,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProfilePlanDetailsScreen.routeName,
                                    arguments: {
                                      "title": option,
                                      "profileRefNo": entry.value.profileRefNo
                                    },
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Profiles help you segregate your spends between personal, work, social etc. You can select different plans, configure different email ID’s, mobiles numbers, and notifications for each of your profiles.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(110, 122, 132, 1),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
