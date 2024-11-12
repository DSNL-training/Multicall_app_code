import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/payment_profiles.dart';
import 'package:multicall_mobile/screens/settings_section_screens/account_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/call_me_on_setting_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/help_settings_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/terms_and_privacy/terms_and_privacy.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/delete_account_bottom_sheet.dart';
import 'package:multicall_mobile/widget/logout_bottom_sheet.dart';
import 'package:multicall_mobile/widget/menu_options.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/setting';

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  File? _image;
  String versionNumber = "";
  bool isDisplayAppUpdateOption = false;

  Future<void> getVersionNumber() async {
    final info = await PackageInfo.fromPlatform();
    versionNumber = info.version;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getVersionNumber();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final photoKey =
          "ProfilePhoto-${PreferenceHelper.get(PrefUtils.userRegistrationNumber)}";

      if (PreferenceHelper.get(photoKey) != null) {
        _image = File(PreferenceHelper.get(photoKey));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ProfileController profileController = context.watch<ProfileController>();
    Profile? defaultProfile = profileController.defaultProfile;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text("Settings"),
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
              press: () {
                launchURL("https://youtube.com/watch?v=ZaZfWmd6vBc");
              },
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.note,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              press: () {
                launchURL("https://www.multicall.in/blog/");
              },
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.headset,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              press: () {
                launchURL("tel:04446741321");
              },
            ),
          ],
        ),
        showBackButton: false,
      ),
      body: Consumer<HomeProvider>(builder: (context, homeProvider, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (value) {
            homeProvider.onItemTapped(0);
            return;
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: _image != null
                                    ? FileImage(_image!)
                                    : const AssetImage(
                                            'assets/images/default_image.png')
                                        as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 10,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                final pickedFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    _image = File(pickedFile.path);
                                    final photoKey =
                                        "ProfilePhoto-${PreferenceHelper.get(PrefUtils.userRegistrationNumber)}";
                                    PreferenceHelper.set(
                                        photoKey, pickedFile.path);
                                  });
                                }
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    PhosphorIconsFill.camera,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: size.width,
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                        color: const Color.fromRGBO(221, 225, 228, 1),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            defaultProfile?.profileName ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomStyledContainer(
                          width: size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MenuOptions(
                                  itemName: "Accounts",
                                  isLastItem: false,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AccountScreen.routeName);
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Profiles",
                                  isLastItem: false,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ProfilesScreen.routeName);
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Payments",
                                  isLastItem: false,
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        PaymentChooseProfileScreen.routeName);
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Call-Me-On",
                                  isLastItem: false,
                                  onPressed: () {
                                    final defaultProfile =
                                        Provider.of<ProfileController>(context,
                                                listen: false)
                                            .defaultProfile;

                                    if (defaultProfile?.accountType ==
                                        AppConstants.retailPrepaid) {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const OnlyPaidDialogue();
                                        },
                                      );
                                      return;
                                    } else {
                                      Navigator.pushNamed(
                                          context,
                                          CallMeOnScreenSettingsScreen
                                              .routeName);
                                    }
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Help",
                                  isLastItem: false,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, HelpSettingsScreen.routeName);
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Terms and Privacy",
                                  isLastItem: false,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, TermsAndPrivacy.routeName);
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Logout",
                                  isLastItem: false,
                                  textColor: const Color(0XFFD85252),
                                  onPressed: () {
                                    showLogoutConfirmationBottomSheet(context);
                                  },
                                ),
                                MenuOptions(
                                  itemName: "Delete Account",
                                  isLastItem: true,
                                  textColor: const Color(0XFFD85252),
                                  onPressed: () {
                                    showDeleteAccountConfirmationBottomSheet(
                                        context);
                                    //PERFORM DELETE ACCOUNT API
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isDisplayAppUpdateOption
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const PhosphorIcon(
                                duotoneSecondaryColor: Colors.white,
                                PhosphorIconsDuotone.deviceMobileCamera
                                    as IconData,
                                size: 32,
                                color: Color(0XFF0086B5),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                    child: MultiCallTextWidget(
                                      text: "Version 2.0",
                                      textColor: Color(0XFF6E7A84),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                    child: MultiCallTextWidget(
                                      text: "App Update Available",
                                      textColor: Color(0XFF101315),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              MultiCallOutLineButtonWidget(
                                text: "Update",
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                borderColor: const Color(0XFF62B414),
                                textColor: const Color(0XFF62B414),
                                backgroundColor: const Color(0XFFDAEFC6),
                                borderRadius: 8,
                                onTap: () {
                                  setState(() {
                                    isDisplayAppUpdateOption = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 8,
              ),
              MultiCallTextWidget(
                text: "Version $versionNumber",
                textColor: const Color(0XFF6E7A84),
                textAlign: TextAlign.center,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        );
      }),
    );
  }
}
