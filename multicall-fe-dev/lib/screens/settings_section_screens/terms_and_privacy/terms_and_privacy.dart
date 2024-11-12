import 'package:flutter/material.dart';
import 'package:multicall_mobile/screens/settings_section_screens/terms_and_privacy/about_the_app.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/menu_options.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndPrivacy extends StatefulWidget {
  static const routeName = '/terms_and_privacy';

  const TermsAndPrivacy({super.key});

  @override
  State<TermsAndPrivacy> createState() => _TermsAndPrivacyState();
}

class _TermsAndPrivacyState extends State<TermsAndPrivacy> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text("Terms and Privacy"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28.0),
              child: CustomStyledContainer(
                height: double.infinity,
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MenuOptions(
                        itemName: "About the App",
                        isLastItem: false,
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AboutTheAppScreen.routeName);
                        },
                        diverStartIndent: 14,
                        diverEndIndent: 14,
                      ),
                      MenuOptions(
                        itemName: "Privacy Policy",
                        isLastItem: false,
                        onPressed: () async {
                          const url = 'https://multicall.in/privacy-policy/';
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
                        itemName: "Terms of Service",
                        isLastItem: true,
                        onPressed: () async {
                          const url = 'https://multicall.in/terms-conditions/';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        diverStartIndent: 14,
                        diverEndIndent: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
