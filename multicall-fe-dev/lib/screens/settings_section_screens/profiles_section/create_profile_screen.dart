import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/account_section_bottom_sheet.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class CreateProfileScreen extends StatefulWidget {
  static const routeName = '/create_profile_screen';

  const CreateProfileScreen({super.key});

  @override
  CreateProfileScreenState createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen> {
  Color nameFieldColor = const Color.fromRGBO(142, 152, 160, 1);
  final TextEditingController _namecontroller = TextEditingController();
  String email = "";
  String mobile = "";
  List<String> emails = [
    PreferenceHelper.get(PrefUtils.userEmail),
  ];
  List<String> mobileNumbers = [
    PreferenceHelper.get(PrefUtils.userPhoneNumber),
  ];

  @override
  void initState() {
    super.initState();
    AccountController accountController = Provider.of<AccountController>(
      context,
      listen: false,
    );
    emails.addAll(accountController.emails);
    mobileNumbers.addAll(accountController.userPhoneNumberList);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
          leading: const Text(
            "Create Profile",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
          ),
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
                    return const AccountSectionBottomSheet();
                  });
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomStyledContainer(
                  height: size.height - math.max(size.height * 0.28, 238),
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          NameInputField(
                            size: size,
                            label: "Enter your profile name",
                            controller: _namecontroller,
                            onChanged: (v) {
                              setState(() {});
                            },
                            color: nameFieldColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDropdownField(
                            size: size,
                            label: "Select Email ID",
                            items: emails,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDropdownField(
                            size: size,
                            label: "Select Mobile Number",
                            items: mobileNumbers,
                            onChanged: (value) {
                              setState(() {
                                mobile = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: TextButtonWithBG(
                  title: 'Create',
                  isDisabled: _namecontroller.text.isEmpty ||
                      email.isEmpty ||
                      mobile.isEmpty,
                  action: () async {
                    ProfileController profileController =
                        Provider.of<ProfileController>(
                      context,
                      listen: false,
                    );
                    RequestCreateRetailProfileSuccess response =
                        await profileController.createRetailProfile(
                      profileName: _namecontroller.text,
                      profileTelephone: mobile,
                      profileEmail: email,
                    );
                    if (response.status) {
                      showToast("Profile created successfully");
                      profileController.getProfiles();
                      Navigator.of(navigatorKey.currentContext!,
                              rootNavigator: true)
                          .popUntil((route) =>
                              route.settings.name == ProfilesScreen.routeName);
                    } else {
                      showToast(response.failReason);
                    }
                  },
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  // iconData: iconData,
                  iconColor: Colors.white,
                  width: size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
