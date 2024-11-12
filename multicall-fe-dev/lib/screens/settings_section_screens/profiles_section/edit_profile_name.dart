// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class EditProfileNameScreen extends StatefulWidget {
  static const routeName = '/edit-profile-name';

  const EditProfileNameScreen({super.key});

  @override
  EditProfileNameScreenState createState() => EditProfileNameScreenState();
}

class EditProfileNameScreenState extends State<EditProfileNameScreen> {
  Color nameFieldColor = const Color.fromRGBO(142, 152, 160, 1);
  final TextEditingController _nameController = TextEditingController();
  late int profileRefNo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      setState(() {
        profileRefNo = (args as Map)['profileRefNo'] ?? 1;
      });
      String profileName = (args as Map)['profileName'] ?? 1;
      _nameController.text = profileName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text(
          "Profile Name",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomStyledContainer(
              height: size.height * 0.72,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    NameInputField(
                      size: size,
                      label: "Enter your profile name",
                      controller: _nameController,
                      onChanged: (v) {},
                      color: nameFieldColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 12.0,
                bottom: 12.0 + MediaQuery.of(context).padding.bottom,
              ),
              child: TextButtonWithBG(
                title: 'Save',
                isDisabled: _nameController.text.isEmpty,
                action: () async {
                  ProfileController profileController =
                      Provider.of<ProfileController>(context, listen: false);
                  if (_nameController.text.isEmpty) {
                    showToast("Enter valid profile name");
                    return;
                  }

                  EditProfileSuccess response =
                      await profileController.editProfile(
                    profileRefNo: profileRefNo,
                    profileName: _nameController.text,
                  ) as EditProfileSuccess;
                  if (response.status) {
                    showToast("Profile Updated Successfully");

                    profileController.getProfiles();
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.of(navigatorKey.currentContext!,
                              rootNavigator: true)
                          .popUntil(
                        (route) =>
                            route.settings.name == ProfilesScreen.routeName,
                      );
                    });
                  } else {
                    showToast(response.failureReason);
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
    );
  }
}
