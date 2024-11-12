import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/request_schedule_estimation_members.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_did_lists_for_dial_in.dart';
import 'package:multicall_mobile/providers/full_screen_ad_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_me_on_screen.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/screens/choose_profile_screen.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/group_list_screen.dart';
import 'package:multicall_mobile/screens/rename_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/multiple_click_handler.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/call_container.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/call_estimate_bottom_sheet.dart';
import 'package:multicall_mobile/widget/clickable_row_with_icon.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/dial_in_more_options.dart';
import 'package:multicall_mobile/widget/generic_bottomsheet_dialog.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_section_screens/add_phone_number_screen.dart';

class ScheduleCallScreen extends StatefulWidget {
  static const routeName = '/schedule_call_screen';

  const ScheduleCallScreen(
      {super.key, this.dialType = DialTypeSelection.default1});

  final DialTypeSelection dialType; // DialTypeSelection

  @override
  State<ScheduleCallScreen> createState() => _ScheduleCallScreenState();
}

class _ScheduleCallScreenState extends State<ScheduleCallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provider = Provider.of<CallsController>(context, listen: false);
      provider.retrieveWritableCalendars();
      provider.setCallName("New Call");

      var profileController =
          Provider.of<ProfileController>(context, listen: false);
      if (profileController.defaultProfile != null) {
        /// set default profile
        provider.setSelectedProfile = profileController.defaultProfile!;
      }

      if (widget.dialType == DialTypeSelection.dialIn) {
        provider.setTypeOfStart(2);
      }

      /// set call type
      provider.setCallType(widget.dialType == DialTypeSelection.dialIn ? 2 : 2);

      /// set dial in flag
      provider
          .setDialInFlag(widget.dialType == DialTypeSelection.dialIn ? 1 : 0);

      /// Initialize date time
      provider.initializeDateTime();
    });
  }

  Future<void> _createEvent(
      CallsController provider, FullScreenAdProvider adProvider) async {
    /// Validate members
    if (provider.getMembers().isEmpty) {
      showToast("Please add at least one participant.");
      return;
    }

    final defaultProfile = provider.selectedProfile;

    final filteredCallMeOnList =
        Provider.of<CallMeOnController>(context, listen: false)
            .filteredCallMeOnList;

    /// get profile member allow size
    var profileSize =
        defaultProfile?.profileSize == 0 ? 4 : defaultProfile?.profileSize ?? 4;

    if (provider.getMembers().length > profileSize) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return MaximumMemberAlertBottomSheet(
            onTapSeePlan: () {
              // GOTO PLAN SCREEN
              debugPrint("On Tap See Plans");
            },
          );
        },
      );
      return;
    }

    var didListForDialInResponse = await provider.requestDidListsForDialIn(
      appSocketId: 1,
      profileRefNum: defaultProfile?.profileRefNo ?? 0,
    ) as DidListsForDialInResponse;

    if (didListForDialInResponse.dialInDid.isNotEmpty) {
      if (defaultProfile?.accountType == AppConstants.retailPrepaid) {
        RequestScheduleEstimateSuccess? response;
        provider.scheduleEstimation(
          profileRefNumber: defaultProfile?.profileRefNo ?? 0,
          confDuration: provider.getConferenceDuration(),
          totalNumberOfMessages: (provider.getMembers().length / 2).ceil(),
          chairPersonPhoneNumber:
              filteredCallMeOnList[provider.getSelectedCallMeOn].callMeOn,
          dialType: provider.dialInFlag,
          otherFeatures: -1,
          typeOfStart: provider.getTypeOfStart(),
          totalMembers: provider.getMembers().length,
        );

        List<List<MemberEstimation>> pairs = [];

        // Group members into pairs
        for (int i = 0; i < provider.getMembers().length; i += 2) {
          if (i + 1 < provider.getMembers().length) {
            var temp1 = MemberEstimation(
              memberNumber: provider.getMembers()[i].memberTelephone,
              callType: provider.getCallType(),
            );
            var temp2 = MemberEstimation(
              memberNumber: provider.getMembers()[i + 1].memberTelephone,
              callType: provider.getCallType(),
            );

            pairs.add([temp1, temp2]);
          } else {
            var temp = MemberEstimation(
              memberNumber: provider.getMembers()[i].memberTelephone,
              callType: provider.getCallType(),
            );
            pairs.add([temp]);
          }
        }

        // Simulate API calls for each pair
        for (int i = 0; i < pairs.length; i++) {
          List<MemberEstimation> pair = pairs[i];
          // Perform API call with pair
          if (i != pairs.length - 1) {
            provider.scheduleEstimationMembers(
              profileRefNumber: defaultProfile?.profileRefNo ?? 0,
              members: pair,
            );
          } else {
            response = await provider.scheduleEstimationMembers(
              profileRefNumber: defaultProfile?.profileRefNo ?? 0,
              members: pair,
            ) as RequestScheduleEstimateSuccess;
            debugPrint(response.estimateAmount.toString());
          }
        }
        if (mounted) {
          // Show the bottom sheet and wait for the user's response
          bool continueExecution = await showCallEstimateBottomSheet(
            context,
            provider.getMembers().length.toString(),
            provider.getConferenceDuration().toString(),
            (response?.estimateAmount == null
                    ? 0
                    : response!.estimateAmount / 100)
                .toString(),
          );

          // If the user chooses not to continue, return early
          if (!continueExecution) {
            return;
          }
        }
      }

      //Call Action:106
      // In response, adStatus == 1 then show ad

      final instantCallProvider =
          Provider.of<InstantCallProvider>(context, listen: false);

      var response = await instantCallProvider.getAdvertiseRequirementDetails(
          provider.getMembers().length, defaultProfile?.profileRefNo ?? 0);

      if (response.adStatus == 1) {
        showModalBottomSheet<void>(
          context: navigatorKey.currentContext!,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return GenericBottomSheetDialog(
              title:
                  "Since you are on a free profile, you will be played an ad before the call is completed. Explore our paid profiles for an ad-free experience.",
              negativeButtonText: "",
              positiveButtonText: "Ok",
              isOnlyOneButton: true,
              onTap: () async {
                Navigator.pop(context);

                /// Display Interstitial Ad
                if (adProvider.isInterstitialAvailable) {
                  /// clear memberList
                  adProvider.scheduleCallMemberList.clear();

                  /// store memberList in adProvider and start call after ad gets closed
                  adProvider.scheduleCallMemberList = provider.getMembers();

                  await adProvider.showInterstitial();
                }
              },
            );
          },
        );
      } else {
        provider.scheduleCall(
          profileRefNumber: defaultProfile?.profileRefNo ?? 0,
          // Profile reference number
          totalIterations: (provider.getMembers().length / 2).ceil(),
          // Total iterations
          chairPersonPhoneNumber:
              filteredCallMeOnList[provider.getSelectedCallMeOn].callMeOn,
          // Profile Phone number
          callType: provider.getCallType(),
          // Call type: 2
          startType: provider.getTypeOfStart(),
          // Type of start: 1 = auto, 2 = user
          scheduleRefNumber: 1,
          // Schedule reference number
          scheduleName: provider.callName,
          // Schedule name
          totalMembersCount: provider.getMembers().length,
          // Total members count
          conferenceDuration: provider.getConferenceDuration(),
          // Conference duration in minutes
          scheduleStartDateTime: provider.getScheduleStartDateTime(),
          // Schedule start date-time format: 2024-06-27 16:56
          repeatType: provider.getRepeatType(),
          // Repeat type: 0 - Never, 1 - EveryDay, 2 - Every Week, 4 - Every Month
          repeatEndDate:
              DateFormat('yyyy-MM-dd').format(provider.repeatTillDate),
          // Repeat end date format: 2024-06-27
          dialinFlag: provider.dialInFlag,
          // Dialin flag: dialout = 0, dialin = 1
          dialinDid: didListForDialInResponse.dialInDid, // Dialin ID
        );

        List<List<ScheduleCallMember>> pairs = [];

        // Group members into pairs
        for (int i = 0; i < provider.getMembers().length; i += 2) {
          if (i + 1 < provider.getMembers().length) {
            pairs.add([provider.getMembers()[i], provider.getMembers()[i + 1]]);
          } else {
            pairs.add([provider.getMembers()[i]]);
          }
        }

        // Simulate API calls for each pair
        for (int i = 0; i < pairs.length; i++) {
          List<ScheduleCallMember> pair = pairs[i];
          // Perform API call with pair
          provider.scheduleMembers(
            chairPersonPhoneNumber:
                filteredCallMeOnList[provider.getSelectedCallMeOn].callMeOn,
            messageNumber: i + 1,
            members: pair,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text(
          'Schedule',
        ),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => FullScreenAdProvider(),
        child: Consumer<CallsController>(
          builder: (context, provider, child) {
            final filteredCallMeOnList =
                Provider.of<CallMeOnController>(context, listen: false)
                    .filteredCallMeOnList;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomStyledContainer(
                      width: double.infinity,
                      height: size.height - math.max(size.height * 0.28, 200),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        provider.callName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      DualToneIcon(
                                        iconSrc: PhosphorIconsDuotone
                                            .pencilSimpleLine,
                                        duotoneSecondaryColor:
                                            const Color.fromRGBO(
                                                0, 134, 181, 1),
                                        color: Colors.black,
                                        size: 16,
                                        padding: const Padding(
                                            padding: EdgeInsets.all(7)),
                                        margin: 0,
                                        press: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RenameScreen(
                                                initialName: provider.callName,
                                                appBarTitle: "Add a Call Name",
                                                inputFieldLabel:
                                                    "Enter call name",
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const CallContainer3(),
                                  const SizedBox(height: 24),
                                  ClickableRowWithIcon(
                                    clickFunction: () async {
                                      var profile = await Navigator.of(context)
                                          .pushNamed(
                                              ChooseProfileScreen.routeName,
                                              arguments: {
                                            "selectedProfile":
                                                provider.selectedProfile,
                                          });
                                      if (profile != null) {
                                        provider.setSelectedProfile =
                                            profile as Profile;
                                        setState(() {});
                                      }
                                    },
                                    leftIconClickFunction: () {},
                                    leftIcon: PhosphorIconsRegular.info,
                                    rightIcon: PhosphorIconsRegular.caretRight,
                                    title:
                                        provider.selectedProfile?.profileName ??
                                            "Default",
                                    subTitle: "(Profile)",
                                    toolTipText:
                                        "Call size is ${provider.selectedProfile?.profileSize == 0 ? 4 : provider.selectedProfile?.profileSize ?? 4} of this profile",
                                  ),
                                  const SizedBox(height: 5),
                                  ClickableRowWithIcon(
                                    clickFunction: () async {
                                      if (filteredCallMeOnList.isNotEmpty) {
                                        var result = await Navigator.of(context)
                                            .pushNamed(
                                          CallMeOnScreen.routeName,
                                          arguments: {
                                            "selectedCallMeOnIndex":
                                                provider.getSelectedCallMeOn,
                                          },
                                        );

                                        if (result != null) {
                                          setState(() {
                                            /// member list must not contain call-me-on number
                                            final memberIndex = provider
                                                .getMembers()
                                                .indexWhere((element) =>
                                                    element.memberTelephone ==
                                                    filteredCallMeOnList[
                                                            int.parse(result
                                                                .toString())]
                                                        .callMeOn);
                                            if (memberIndex == -1) {
                                              provider.setSelectedCallMeOn =
                                                  int.parse(result.toString());
                                            } else {
                                              showToast(
                                                  "This number is already added as a participant! Please choose a different number.");
                                            }
                                          });
                                        }
                                      }
                                    },
                                    rightIcon: PhosphorIconsRegular.caretRight,
                                    toolTipText:
                                        "Select your Call-me-on Number",
                                    title: filteredCallMeOnList[
                                            provider.getSelectedCallMeOn]
                                        .callMeOn,
                                    subTitle: "(Call-Me-On)",
                                  ),
                                ],
                              ),
                            ),
                            DialInRow(size: size, dialType: widget.dialType),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ClickableRowWithIcon(
                                    clickFunction: () {
                                      debugPrint("called");
                                      openAddMemberBottomSheet();
                                    },
                                    titleWeight: FontWeight.w600,
                                    title:
                                        'Members - ${provider.getMembers().length}',
                                    rightDualToneIcon:
                                        PhosphorIconsDuotone.plusCircle,
                                  ),
                                ],
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: provider
                                  .getMembers()
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                ScheduleCallMember member = entry.value;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Container(
                                            height: 32,
                                            width: 32,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              color: Color(0XFFEDF0F2),
                                            ),
                                            child: Center(
                                              child: MultiCallTextWidget(
                                                text: member.memberName
                                                    .characters.first,
                                                textColor:
                                                    const Color(0XFF101315),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: MultiCallTextWidget(
                                                  text: member.memberName,
                                                  textColor:
                                                      const Color(0XFF101315),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              SizedBox(
                                                height: 16,
                                                child: MultiCallTextWidget(
                                                  text: member.memberTelephone,
                                                  textColor:
                                                      const Color(0XFF6E7A84),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        customIconButton(
                                          iconData: PhosphorIcons.caretRight(),
                                          onPressed: () {
                                            showMemberOptionBottomSheet(
                                                member, provider);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 16.0),
                                      child: Divider(
                                        color: Color(0XFFCDD3D7),
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<FullScreenAdProvider>(
                  builder: (context, adProvider, child) {
                    return Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 12.0,
                          bottom: 12.0 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: TextButtonWithBG(
                          title: 'Schedule Call',
                          action: () {
                            MultipleClickHandler.checkClick(
                                key: 'scheduleCallButtonClick',
                                onClick: () {
                                  _createEvent(provider, adProvider);
                                });
                          },
                          // Make sure to add a Setting check to add event to calendar
                          color: const Color.fromRGBO(98, 180, 20, 1),
                          textColor: Colors.white,
                          fontSize: 16,
                          iconColor: Colors.white,
                          width: size.width,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void openAddMemberBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                  SizedBox(
                    height: 70,
                    child: NavigatorOption(
                      title: "Contacts",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ContactScreen(isFromScheduleScreen: true),
                          ),
                        );
                      },
                      iconData: PhosphorIconsDuotone.addressBook,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0XFFDDE1E4),
                  ),
                  SizedBox(
                    height: 70,
                    child: NavigatorOption(
                      title: "Add Groups",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);
                        gotoGroupSelectionScreen(context);
                      },
                      iconData: PhosphorIconsDuotone.usersFour,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0XFFDDE1E4),
                  ),
                  SizedBox(
                    height: 70,
                    child: NavigatorOption(
                      title: "Dial Number",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPhoneNumberScreen(
                                isFromScheduleScreen: true),
                          ),
                        );
                      },
                      iconData: PhosphorIconsDuotone.dotsSix,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void showMemberOptionBottomSheet(
      ScheduleCallMember member, CallsController provider) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  height: 16,
                ),
                MultiCallTextWidget(
                  text: member.memberName,
                  textColor: const Color(0XFF101315),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Call",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      //PERFORM PHONE CALL
                      makePhoneCall(member.memberTelephone);
                    },
                    iconData: PhosphorIconsDuotone.phoneCall,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Color(0XFFDDE1E4),
                ),
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Remove",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      provider.removeMember(member);
                    },
                    iconData: PhosphorIconsDuotone.trash,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(
      scheme: "tel",
      path: phoneNumber,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showToast("Cannot make this call");
    }
  }

  void gotoGroupSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GroupListScreen(
          isFromScheduleCall: true,
        ),
      ),
    );
  }
}

class DialInRow extends StatelessWidget {
  const DialInRow({
    super.key,
    required this.size,
    required this.dialType,
  });

  final Size size;

  // dialType
  final DialTypeSelection dialType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(237, 240, 242, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dialType == DialTypeSelection.dialIn ? "Dial-In" : "Dial-Out",
            style: TextStyle(
              fontFamily:
                  Theme.of(context).primaryTextTheme.titleLarge?.fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                showDragHandle: false,
                backgroundColor: Colors.white,
                context: context,
                builder: (BuildContext context) {
                  return DialInMoreOption(dialType: dialType);
                },
              );
            },
            child: Row(
              children: [
                Text(
                  "More options",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: Theme.of(context)
                        .primaryTextTheme
                        .titleLarge
                        ?.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                DualToneIcon(
                  press: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      showDragHandle: false,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return DialInMoreOption(dialType: dialType);
                      },
                    );
                  },
                  margin: 0,
                  iconSrc: PhosphorIconsDuotone.dotsThreeCircle,
                  duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                  color: Colors.black,
                  size: 14,
                  padding: const Padding(padding: EdgeInsets.all(5)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
