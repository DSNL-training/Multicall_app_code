import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/payments_section_screens/profile_plan_details.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/icon_with_border.dart';
import 'package:multicall_mobile/widget/profile_detail_row.dart';
import 'package:multicall_mobile/widget/profile_features_bottom_sheet.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/update_profile_info.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ProfileDetailsScreen extends StatefulWidget {
  static const routeName = '/profile-details-screen';

  const ProfileDetailsScreen({super.key});

  @override
  ProfileDetailsScreenState createState() => ProfileDetailsScreenState();
}

class ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  bool isDefaultProfile = false;
  int regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber);
  late int profileRefNumber;
  late Profile profile = Profile(
    profileRefNo: 0,
    profileName: 'Loading...',
    profileEmail: '',
    profilePhone: '',
    accountType: 1,
    profileStatus: 1,
    participantPin: 0,
    defaultProfileFlag: 0,
    chairpersonPin: 0,
    allowStatusISD: null,
  );
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      final bool isDefault = (args as Map)['isDefaultProfile'] ?? 1;
      final int profileRefNo = (args)['profileRefNo'] ?? 1;
      ProfileController profileController =
          Provider.of<ProfileController>(context, listen: false);
      profile = profileController.profiles
          .where((p) => p.profileRefNo == profileRefNo)
          .firstOrNull!;

      setState(() {
        isDefaultProfile = isDefault;
        profileRefNumber = profileRefNo;
        isLoading = false;
        profile = profileController.profiles
            .where((p) => p.profileRefNo == profileRefNo)
            .firstOrNull!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: Text(
          profile.profileName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconWithBorder(
              icon: isDefaultProfile
                  ? PhosphorIconsFill.heart
                  : PhosphorIconsDuotone.heart,
              onClick: () async {
                ProfileController profileController =
                    Provider.of<ProfileController>(
                  context,
                  listen: false,
                );
                await profileController.profileStatusCheck(
                  profileEmail: profile.profileEmail,
                  profileRefNum: profile.profileRefNo,
                  profileTelephone: profile.profilePhone,
                );
                final UpdateDefaultProfileSuccess response =
                    await profileController.updateDefaultProfile(
                  profileRefNo: profileRefNumber,
                );
                if (response.status) {
                  setState(() {
                    isDefaultProfile = true;
                  });
                }
              },
              color: isDefaultProfile ? Colors.red : Colors.black,
            ),
            const SizedBox(
              width: 8,
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.dotsThreeCircle,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              margin: 0,
              press: () {
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return UpdateProfileBottomSheet(
                      profileName: profile.profileName,
                      profileRefNo: profile.profileRefNo,
                      isDefaultProfile: profile.defaultProfileFlag == 1,
                      accountType: profile.accountType,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomStyledContainer(
                      height: double.infinity,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        child: Column(
                          children: [
                            ProfileDetailRow(
                              title: "Type",
                              subTitle: accountTypes[profile.accountType - 1],
                              rightIcon: PhosphorIconsLight.info,
                              clickFunction: () {
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProfileFeaturesBottomSheet(
                                      profile: profile,
                                      closeFunc: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                              isNotLast: true,
                            ),
                            ProfileDetailRow(
                              title: "Status",
                              subTitle:
                                  profileStatuses[profile.profileStatus - 1],
                              isNotLast: true,
                            ),
                            ProfileDetailRow(
                              title: "MultiCall Code (PIN)",
                              subTitle: profile.chairpersonPin.toString(),
                              isNotLast: true,
                            ),
                            ProfileDetailRow(
                              title: "Email ID",
                              subTitle: profile.profileEmail,
                              isNotLast: true,
                            ),
                            ProfileDetailRow(
                              title: "Phone Number",
                              subTitle: profile.profilePhone,
                              isNotLast: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                profile.accountType == AppConstants.retailPrepaid
                    ? Container(
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextButtonWithBG(
                            title: 'Manage Plans & Payments',
                            action: () {
                              Navigator.pushNamed(
                                context,
                                ProfilePlanDetailsScreen.routeName,
                                arguments: {
                                  "title": profile.profileName,
                                  "profileRefNo": profile.profileRefNo,
                                },
                              );
                            },
                            color: const Color.fromRGBO(98, 180, 20, 1),
                            textColor: Colors.white,
                            fontSize: 16,
                            // iconData: iconData,
                            iconColor: Colors.white,
                            width: size.width,
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 16,
                      ),
              ],
            ),
    );
  }
}
