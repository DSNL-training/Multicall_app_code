import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/screens/add_new_profile.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/row_option_selection.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class ChooseProfileScreen extends StatefulWidget {
  static const routeName = '/choose-profile-screen';

  const ChooseProfileScreen({super.key});

  @override
  State<ChooseProfileScreen> createState() => _ChooseProfileScreenState();
}

class _ChooseProfileScreenState extends State<ChooseProfileScreen> {
  Profile? selectedProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ModalRoute.of(context)!.settings.arguments;
      if (profile == null) {
        selectedProfile = Provider.of<ProfileController>(context, listen: false)
            .defaultProfile;
      } else {
        selectedProfile = (profile as Map)['selectedProfile'];
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ProfileController profileController = context.watch<ProfileController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text(
          "Choose Profile",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
        trailing: BorderTextButton(
          title: 'Done',
          action: () {
            Navigator.pop(context, selectedProfile);
          },
          borderColor: const Color.fromRGBO(98, 180, 20, 1),
          textColor: const Color.fromRGBO(98, 180, 20, 1),
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
                height: double.infinity,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children:
                        profileController.profiles.asMap().entries.map((entry) {
                      int idx = entry.key;
                      Profile profile = entry.value;
                      return OptionSelector(
                        title: profile.profileName,
                        isLeftIconReq: true,
                        isSelected: profile == selectedProfile,
                        leftIconClick: () {},
                        clickFunction: () {
                          debugPrint("Option ${profile.profileName} selected");
                          selectedProfile = profile;
                          setState(() {});
                        },
                        toolTipText:
                            "Call size is ${profile.profileSize == 0 ? 4 : profile.profileSize} of this profile",
                        isLastItem:
                            idx == profileController.profiles.length - 1,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: TextButtonWithBG(
                title: 'Add Profile',
                action: () {
                  Navigator.pushNamed(context, AddNewProfileScreen.routeName);
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
