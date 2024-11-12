import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/edit_profile_name.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/bottom_sheet_option_with_icon.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class UpdateProfileBottomSheet extends StatefulWidget {
  final String profileName;
  final int profileRefNo;
  final bool isDefaultProfile;
  final int accountType;
  const UpdateProfileBottomSheet({
    super.key,
    required this.profileName,
    required this.profileRefNo,
    required this.isDefaultProfile,
    required this.accountType,
  });

  @override
  State<UpdateProfileBottomSheet> createState() =>
      _UpdateProfileBottomSheetState();
}

class _UpdateProfileBottomSheetState extends State<UpdateProfileBottomSheet> {
  final WebSocketService webSocketService = WebSocketService();
  int regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BottomSheetOptionWithIcon(
                    iconSrc: PhosphorIconsDuotone.pencilSimple,
                    title: "Rename ${widget.profileName} Name",
                    action: () {
                      Navigator.of(context).pushNamed(
                          EditProfileNameScreen.routeName,
                          arguments: {
                            "profileName": widget.profileName,
                            "profileRefNo": widget.profileRefNo,
                          });
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const HorizontalDivider(),
                  const SizedBox(
                    height: 12,
                  ),
                  BottomSheetOptionWithIcon(
                    iconSrc: PhosphorIconsDuotone.trash,
                    title: "Delete",
                    action: () async {
                      Navigator.pop(context);
                      showDeleteProfileConfirmationBottomSheet();
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showDeleteProfileConfirmationBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              // height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                      child: Center(
                        child: Container(
                          height: 6,
                          width: 46,
                          decoration: const BoxDecoration(
                            color: Color(0XFFCDD3D7),
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Center(
                        child: MultiCallTextWidget(
                          text: widget.accountType == AppConstants.retailPrepaid
                              ? "Retail profile can't be deleted, need to contact customer care"
                              : widget.isDefaultProfile
                                  ? "You are deleting your default profile\nAre you sure?"
                                  : "All your schedules made using this profile will be cancelled. Are you sure to delete?",
                          textColor: const Color(0XFF101315),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0XFFDDE1E4),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        height: 40,
                        child: widget.accountType == AppConstants.retailPrepaid
                            ? MultiCallOutLineButtonWidget(
                                text: "Ok",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: Colors.white,
                                borderRadius: 8,
                                backgroundColor:
                                    const Color.fromRGBO(0, 134, 181, 1),
                                borderColor:
                                    const Color.fromRGBO(0, 134, 181, 1),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: MultiCallOutLineButtonWidget(
                                      text: "Cancel",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      borderColor: const Color(0XFFDDE1E4),
                                      textColor: const Color(0XFF101315),
                                      borderRadius: 8,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: MultiCallOutLineButtonWidget(
                                      text: "Delete",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textColor: Colors.white,
                                      borderRadius: 8,
                                      backgroundColor: const Color(0XFFFF6666),
                                      borderColor: const Color(0XFFFF6666),
                                      onTap:
                                          //Call Delete API Here:
                                          () async {
                                        ProfileController profileController =
                                            Provider.of<ProfileController>(
                                          context,
                                          listen: false,
                                        );
                                        DeleteProfileSuccess response =
                                            await profileController
                                                .deleteProfile(
                                          profileRefNo: widget.profileRefNo,
                                          profileName: widget.profileName,
                                          email: PreferenceHelper.get(
                                            PrefUtils.userEmail,
                                          ),
                                          telephone: PreferenceHelper.get(
                                            PrefUtils.userPhoneNumber,
                                          ),
                                        ) as DeleteProfileSuccess;
                                        if (response.status) {
                                          if (widget.isDefaultProfile) {
                                            profileController
                                                .updateRetailProfileToDefaultProfile();
                                          }
                                          showToast(
                                            "Profile Deleted Successfully",
                                          );
                                          await profileController
                                              .syncDeletedProfile();
                                          await profileController
                                              .acknowledgeProfileDeleteSync(
                                                  profileRefNum:
                                                      widget.profileRefNo);
                                          profileController.getProfiles();
                                          Navigator.of(
                                            navigatorKey.currentContext!,
                                            rootNavigator: true,
                                          ).popUntil(
                                            (route) =>
                                                route.settings.name ==
                                                ProfilesScreen.routeName,
                                          );
                                        } else {
                                          showToast(response.failureReason);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
