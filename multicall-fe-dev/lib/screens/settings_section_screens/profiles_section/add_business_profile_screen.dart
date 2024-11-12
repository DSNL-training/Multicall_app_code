import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/add_business_profile_provider.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/add_profile_help.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class AddBusinessProfileScreen extends StatefulWidget {
  static const routeName = '/add_business_profile_screen';

  const AddBusinessProfileScreen({super.key});

  @override
  AddBusinessProfileScreenState createState() =>
      AddBusinessProfileScreenState();
}

class AddBusinessProfileScreenState extends State<AddBusinessProfileScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _multicallPinFocus = FocusNode();
  Color nameFieldColor = const Color.fromRGBO(142, 152, 160, 1);
  final TextEditingController _namecontroller = TextEditingController();
  int regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber);
  final WebSocketService webSocketService = WebSocketService();

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text(
          'Add Business Profile',
        ),
        trailing: DualToneIcon(
          iconSrc: PhosphorIconsDuotone.question,
          duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
          color: Colors.black,
          size: 16,
          padding: const Padding(padding: EdgeInsets.all(7)),
          press: () {
            Navigator.of(context).pushNamed(AddProfileHelpWidget.routeName);
          },
          margin: 0,
        ),
      ),
      body: Consumer<AddBusinessProfileProvider>(
        builder: (BuildContext context, AddBusinessProfileProvider provider,
            Widget? child) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    width: size.width,
                    height: size.height - math.max(size.height * 0.28, 200),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            NameInputField(
                              size: size,
                              label: "Enter your profile name",
                              controller: _namecontroller,
                              onChanged: (v) {},
                              color: nameFieldColor,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CustomDropdownField(
                              size: size,
                              label: "Select Email ID",
                              items: emails,
                              onChanged: (value) {
                                provider.setEmail(value);
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomDropdownField(
                              size: size,
                              label: "Select Mobile Number",
                              items: mobileNumbers,
                              onChanged: (value) {
                                provider.setPhone(value);
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            PhoneNumberInputField(
                              focusNode: _multicallPinFocus,
                              size: size,
                              label: "MultiCall Code (PIN)",
                              errorText: "",
                              controller: _pinController,
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
                    isLoading: provider.isLoading,
                    title: 'Create',
                    action: () async {
                      provider.setLoading(true);
                      ProfileController profileController =
                          Provider.of<ProfileController>(
                        context,
                        listen: false,
                      );

                      AddProfileSuccess response =
                          await profileController.createBusinessProfile(
                        regNum: regNum,
                        email: PreferenceHelper.get(PrefUtils.userEmail),
                        telephone:
                            PreferenceHelper.get(PrefUtils.userPhoneNumber),
                        profilePin: int.parse(_pinController.text),
                        profileName: _namecontroller.text,
                        profileTelephone: provider.phone,
                        profileEmail: provider.email,
                      ) as AddProfileSuccess;
                      if (response.status) {
                        await profileController.getProfiles();
                        Future.delayed(const Duration(seconds: 1), () {
                          showToast("Profile created successfully");
                          Navigator.of(
                            navigatorKey.currentContext!,
                            rootNavigator: true,
                          ).popUntil(
                            (route) =>
                                route.settings.name == ProfilesScreen.routeName,
                          );
                        });
                        provider.setLoading(false);
                      } else {
                        provider.setLoading(false);
                        showToast(response.failReason);
                      }
                    },
                    color: const Color.fromRGBO(98, 180, 20, 1),
                    textColor: Colors.white,
                    fontSize: 16,
                    iconColor: Colors.white,
                    width: size.width,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
