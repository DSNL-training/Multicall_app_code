import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/add_profile_help.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class AddNewProfileScreen extends StatefulWidget {
  static const routeName = '/add-new-profile';

  const AddNewProfileScreen({super.key});

  @override
  State<AddNewProfileScreen> createState() => AddNewProfileScreenState();
}

class AddNewProfileScreenState extends State<AddNewProfileScreen> {
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _pinFocus = FocusNode();
  String email = "";
  String phoneNumber = "";

  // final FocusNode _emailFocus = FocusNode();
  int regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber);

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
            'Add Business Profile',
          ),
          trailing: DualToneIcon(
            press: () {
              Navigator.of(context).pushNamed(AddProfileHelpWidget.routeName);
            },
            margin: 0,
            iconSrc: PhosphorIconsDuotone.question,
            duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
            color: Colors.black,
            size: 16,
            padding: const Padding(padding: EdgeInsets.all(5)),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomStyledContainer(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          NameInputField(
                            size: size,
                            label: "Enter your profile name",
                            controller: _profileNameController,
                            focusNode: _nameFocus,
                            onChanged: (v) {
                              setState(() {});
                            },
                            onSubmit: (e) {
                              FocusScope.of(context).requestFocus(_mobileFocus);
                            },
                          ),
                          const SizedBox(
                            height: 16,
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
                            height: 24,
                          ),
                          CustomDropdownField(
                            size: size,
                            label: "Select Mobile Number",
                            items: mobileNumbers,
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          NameInputField(
                            size: size,
                            label: "MultiCall Code (PIN)",
                            controller: _pinController,
                            focusNode: _pinFocus,
                            onChanged: (v) {
                              setState(() {});
                            },
                            onSubmit: (v) {
                              // FocusScope.of(context).requestFocus(_emailFocus);
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
                  action: () async {
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
                      profileName: _profileNameController.text,
                      profileTelephone: phoneNumber,
                      profileEmail: email,
                    ) as AddProfileSuccess;

                    if (response.status) {
                      profileController.getProfiles();
                      Future.delayed(Duration.zero, () {
                        showToast("Profile created successfully");
                        Navigator.pop(context);
                      });
                    } else {
                      showToast(response.failReason);
                    }
                  },
                  isDisabled: _profileNameController.text.isEmpty ||
                      phoneNumber.isEmpty ||
                      _pinController.text.isEmpty,
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
