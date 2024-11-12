import 'package:flutter/material.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/intro_provider.dart';
import 'package:multicall_mobile/screens/onboarding_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/faq_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/feedback_screen.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/menu_options.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSettingsScreen extends StatefulWidget {
  static const String routeName = '/help-settings-screen';

  const HelpSettingsScreen({super.key});

  @override
  State<HelpSettingsScreen> createState() => _HelpSettingsScreenState();
}

class _HelpSettingsScreenState extends State<HelpSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text(
          "Help",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: 24.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: CustomStyledContainer(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  MenuOptions(
                    itemName: "Tutorial",
                    isLastItem: false,
                    onPressed: () async {
                      // Reset the app tour intro state
                      Provider.of<IntroProvider>(context, listen: false)
                          .setWatchedIntro(false);

                      /// Set selected index of Multicall Tab
                      HomeProvider homeProvider =
                          Provider.of<HomeProvider>(context, listen: false);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        homeProvider.setSelectedIndex(0);
                        homeProvider.setTutorialShowing(false);
                      });

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName,
                        (Route<dynamic> route) => false,
                      );
                    },
                    diverStartIndent: 14,
                    diverEndIndent: 14,
                  ),
                  MenuOptions(
                    itemName: "Onboarding",
                    isLastItem: false,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        OnBoardingScreen.routeName,
                        arguments: {'isNavigatingForHelp': true},
                      );
                    },
                    diverStartIndent: 14,
                    diverEndIndent: 14,
                  ),
                  MenuOptions(
                    itemName: "FAQ's",
                    isLastItem: false,
                    onPressed: () {
                      Navigator.pushNamed(context, FAQScreen.routeName);
                    },
                    diverStartIndent: 14,
                    diverEndIndent: 14,
                  ),
                  MenuOptions(
                    itemName: "Feedback",
                    isLastItem: false,
                    onPressed: () {
                      Navigator.pushNamed(context, FeedbackScreen.routeName);
                    },
                    diverStartIndent: 14,
                    diverEndIndent: 14,
                  ),
                  MenuOptions(
                    itemName: "Blog",
                    isLastItem: false,
                    onPressed: () async {
                      const url = 'https://www.multicall.in/blog/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    diverStartIndent: 14,
                    diverEndIndent: 14,
                  ),
                  MenuOptions(
                    itemName: "How to use Multicall",
                    isLastItem: true,
                    onPressed: () async {
                      const url =
                          'https://youtu.be/ZaZfWmd6vBc?si=4qk_3OkwgD0wIDfw';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    diverStartIndent: 14,
                    diverEndIndent: 14,
                  ),
                  // MenuOptions(
                  //   itemName: "Customer Care",
                  //   isLastItem: true,
                  //   onPressed: () async {
                  //     var response = await Provider.of<AccountController>(
                  //             context,
                  //             listen: false)
                  //         .requestCustomerCareNumber();
                  //     makePhoneCall(response.customerCareNumber);
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
