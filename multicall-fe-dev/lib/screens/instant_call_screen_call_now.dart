import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/models/instant_call/response_call_record.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response_bulk_update.dart';
import 'package:multicall_mobile/providers/contact_provider.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/providers/speaking_provider.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/group_list_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/rating_bottom_sheet.dart';
import 'package:multicall_mobile/widget/record_restrict_bottom_sheet.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class InstantCallScreenCallNow extends StatefulWidget {
  static const routeName = '/instant_call_screen_call_now';

  const InstantCallScreenCallNow({super.key});

  @override
  State<InstantCallScreenCallNow> createState() =>
      _InstantCallScreenCallNowState();
}

class _InstantCallScreenCallNowState extends State<InstantCallScreenCallNow> {
  bool isAllMute = false;
  Profile? selectedProfile;
  int selectedProfileSize = 0;
  int scheduleRefNumber = 0;
  int conferenceRefNumber = 0;

  Timer? _bulkUpdateTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      final Profile profile = (args as Map)['selectedProfile'] ?? '';

      selectedProfile = profile;
      scheduleRefNumber = (args)['scheduleRefNumber'] ?? 0;
      conferenceRefNumber = (args)['conferenceRefNumber'] ?? 0;

      selectedProfileSize = selectedProfile?.profileSize == 0
          ? 4
          : selectedProfile?.profileSize ?? 4;

      final instantProvider =
          Provider.of<InstantCallProvider>(context, listen: false);

      instantProvider.setProfile(selectedProfile);
      instantProvider.setConferenceReferenceNumber(conferenceRefNumber);
      instantProvider.setScheduleReferenceNumber(scheduleRefNumber);

      /// Start the timer to call the bulk update API every 3 seconds
      _startBulkUpdateTimer();

      setState(() {});
    });

    //callInstantPickupAPI();
  }

  void _startBulkUpdateTimer() {
    _bulkUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      Provider.of<InstantCallProvider>(context, listen: false)
          .requestBulkUpdate();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _bulkUpdateTimer?.cancel();
    super.dispose();
  }

  // Future<void> callInstantPickupAPI() async {
  //   var provider = Provider.of<InstantCallProvider>(context, listen: false);
  //   List<MemberListModel> memberList = provider.memberList;
  //
  //   final defaultProfile =
  //       Provider.of<ProfileController>(context, listen: false).defaultProfile;
  //
  //   provider.instantPickup(
  //       chairPersonPhoneNumber: defaultProfile?.profilePhone ?? "",
  //       profileRefNumber: 1,
  //       totalMembers: memberList.length);
  //
  //   for (var member in memberList) {
  //     provider.instantPickupMembers(
  //         chairPersonPhoneNumber: defaultProfile?.profilePhone ?? "",
  //         member: member);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: Text(
          scheduleRefNumber == 1 ? 'Instant Call' : 'Scheduled Call',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        trailing: Row(
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
          ],
        ),
      ),
      body: Consumer2<InstantCallProvider, ContactProvider>(
        builder: (context, provider, contactProvider, child) {
          if (provider.bulkUpdateData == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          List<ConferenceParticipant>? memberList =
              provider.bulkUpdateData?.conferences;
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () {
                    // Calling reconnect API
                    return Provider.of<CallsController>(context, listen: false)
                        .reconnect();
                  },
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(26, 16, 20, 0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Participants-${memberList?.length ?? 0}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              // check if any member is not joined the call then show redial all button
                              Visibility(
                                visible: (provider.bulkUpdateData?.conferences
                                        .any((element) =>
                                            element.callStatus !=
                                                CallStatus.joinedTheCall &&
                                            element.callStatus !=
                                                CallStatus.connected &&
                                            element.callStatus !=
                                                CallStatus.dialing &&
                                            element.callStatus !=
                                                CallStatus.retrying &&
                                            element.callStatus !=
                                                CallStatus.ringing) ??
                                    false),
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                child: MultiCallOutLineButtonWidget(
                                  text: "Redial All",
                                  textColor: Colors.white,
                                  borderColor: const Color(0XFF62B414),
                                  backgroundColor: const Color(0XFF62B414),
                                  onTap: () {
                                    redialCallForAll();
                                  },
                                ),
                              ),
                              DualToneIcon(
                                iconSrc: PhosphorIconsDuotone.plusCircle,
                                duotoneSecondaryColor:
                                    const Color.fromRGBO(0, 134, 181, 1),
                                color: Colors.black,
                                size: 16,
                                padding:
                                    const Padding(padding: EdgeInsets.all(7)),
                                press: () {
                                  if ((memberList?.length ?? 0) >=
                                      selectedProfileSize) {
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
                                  } else {
                                    showAddMemberBottomSheet();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: CustomStyledContainer(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 16, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Call Recording",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              DualToneIcon(
                                                margin: 0,
                                                iconSrc: (provider
                                                            .bulkUpdateData
                                                            ?.recordStatus ==
                                                        RecordStatus.recording)
                                                    ? PhosphorIconsDuotone.pause
                                                    : PhosphorIconsFill.circle,
                                                duotoneSecondaryColor:
                                                    const Color.fromRGBO(
                                                        0, 134, 181, 1),
                                                color: (provider.bulkUpdateData
                                                            ?.recordStatus ==
                                                        RecordStatus.recording)
                                                    ? Colors.black
                                                    : const Color.fromRGBO(
                                                        216, 82, 82, 1),
                                                size: 16,
                                                padding: const Padding(
                                                    padding: EdgeInsets.all(8)),
                                                fillColor: (provider
                                                            .bulkUpdateData
                                                            ?.recordStatus ==
                                                        RecordStatus.recording)
                                                    ? Colors.transparent
                                                    : const Color.fromRGBO(
                                                        255, 240, 240, 1),
                                                borderColor: (provider
                                                            .bulkUpdateData
                                                            ?.recordStatus ==
                                                        RecordStatus.recording)
                                                    ? null
                                                    : Colors.transparent,
                                                press: () async {
                                                  if (selectedProfile
                                                          ?.accountType ==
                                                      AppConstants
                                                          .retailPrepaid) {
                                                    showCRecordRestrictBottomSheet(
                                                        context,
                                                        selectedProfile);
                                                    return;
                                                  }
                                                  var response = await provider
                                                      .recordCallAction(
                                                    lastConnectedEpochTime: 1,
                                                    // static last connected epoch time for now
                                                    groupId: 1,
                                                    // static group id for now
                                                    recordAction: (provider
                                                                .bulkUpdateData
                                                                ?.recordStatus ==
                                                            RecordStatus
                                                                .recording)
                                                        ? 2
                                                        : 1,
                                                    // actionValue = 1 - Record On - 2 - Record Off
                                                  ) as ResponseCallRecord;

                                                  if (response.recordStatus ==
                                                      RecordStatus.recording) {
                                                    showToast(
                                                        "Recording started");
                                                  } else if (response
                                                          .recordStatus ==
                                                      RecordStatus.paused) {
                                                    showToast(
                                                        "Recording stopped");
                                                  } else {
                                                    showToast(
                                                        "Error in recording a call ${response.recordStatus.name}");
                                                  }
                                                },
                                              ),
                                              Column(
                                                children: [
                                                  DualToneIcon(
                                                    press: () async {
                                                      //var response = await
                                                      provider.muteAll(
                                                        scheduleRefNumber:
                                                            scheduleRefNumber,
                                                        // static schedule reference number for now
                                                        profileRefNumber:
                                                            selectedProfile
                                                                    ?.profileRefNo ??
                                                                1,
                                                        // static profile reference number for now
                                                        conferenceRefNumber:
                                                            conferenceRefNumber,
                                                        // static conference reference number for now
                                                        actionValue:
                                                            isAllMute ? 2 : 1,
                                                        // actionValue = 1-  Mute all / 2- Unmute all
                                                      );

                                                      setState(() {
                                                        isAllMute = !isAllMute;
                                                      });
                                                      // if (response.muteStatus ==
                                                      //     MuteStatus.muted) {
                                                      //   setState(() {
                                                      //     isAllMute = true;
                                                      //   });
                                                      //   showToast(
                                                      //       "All members muted");
                                                      // } else if (response
                                                      //         .muteStatus ==
                                                      //     MuteStatus.unMuted) {
                                                      //   setState(() {
                                                      //     isAllMute = false;
                                                      //   });
                                                      //   showToast(
                                                      //       "All members un-muted");
                                                      // } else {
                                                      //   showToast(
                                                      //       "Error in un-muting member");
                                                      // }
                                                    },
                                                    margin: 0,
                                                    iconSrc: isAllMute
                                                        ? PhosphorIconsDuotone
                                                            .microphoneSlash
                                                        : PhosphorIconsDuotone
                                                            .microphone,
                                                    duotoneSecondaryColor:
                                                        const Color.fromRGBO(
                                                            0, 134, 181, 1),
                                                    color: Colors.black,
                                                    size: 16,
                                                    padding: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8)),
                                                  ),
                                                  GlobalText(
                                                    text: isAllMute
                                                        ? "UnMute all"
                                                        : "Mute all",
                                                    fontSize: 10,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: Color.fromRGBO(221, 225, 228, 1),
                                      thickness: 1,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: memberList?.length,
                                          itemBuilder: (context, index) {
                                            return MemberListCell(
                                              member: memberList?[index],
                                              provider: provider,
                                              contactProvider: contactProvider,
                                              selectedProfile: selectedProfile,
                                              scheduleRefNumber:
                                                  scheduleRefNumber,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                    top: 24.0,
                    bottom: 12.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: TextButtonWithBG(
                    title: 'End Call',
                    action: () {
                      /// Call EndCallForAll API
                      provider.endCallForAll(
                        scheduleRefNumber: scheduleRefNumber,
                        profileRefNumber: selectedProfile?.profileRefNo ?? 0,
                      );

                      /// Clear Bulk Update Data and navigate to Home Screen
                      provider.setBulkUpdateData(null);

                      /// refresh home screen with all call history data
                      final callsController =
                          Provider.of<CallsController>(context, listen: false);
                      callsController.clearAllCallsHistory();
                      callsController.callHistoryRestore();

                      /// Show Rating Bottom Sheet
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        showDragHandle: true,
                        context: context,
                        builder: (BuildContext context) {
                          return RatingBottomSheet(
                            cancelFunc: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeScreen.routeName,
                                (Route<dynamic> route) => false,
                              );
                            },
                            okFunc: (rating) {
                              if (rating != null) {
                                /// Call Review Rate API
                                provider.callReviewRate(
                                  chairpersonPin:
                                      selectedProfile?.chairpersonPin ?? 0,
                                  callRate: rating,
                                );

                                /// Close Rating Bottom Sheet and navigates to Home Screen
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.routeName,
                                  (Route<dynamic> route) => false,
                                );

                                final homeProvider = Provider.of<HomeProvider>(
                                    context,
                                    listen: false);

                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () => homeProvider.onItemTapped(0),
                                );

                                /// Show Toast
                                showToast("Thank you for rating");
                              } else {
                                showToast("Please select rating");
                              }
                            },
                          );
                        },
                      );
                    },
                    color: const Color.fromRGBO(255, 102, 102, 1),
                    textColor: Colors.white,
                    fontSize: 16,
                    // iconData: iconData,
                    iconColor: Colors.white,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Widget memberListCell(
    ConferenceParticipant? member,
    InstantCallProvider provider,
    ContactProvider contactProvider,
  ) {
    final isMyNumber =
        PreferenceHelper.get(PrefUtils.userPhoneNumber) == member?.phoneNumber;
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isMyNumber
                    ? const MultiCallTextWidget(
                        text: "You",
                        textColor: Color(0XFF101315),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    : FutureBuilder(
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: snapshot.connectionState ==
                                ConnectionState.done,
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            child: MultiCallTextWidget(
                              text: snapshot.data?.name ?? "",
                              textColor: const Color(0XFF101315),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                        future: contactProvider
                            .getMappedMember(member?.phoneNumber ?? ""),
                      ),
                const SizedBox(
                  height: 4,
                ),
                MultiCallTextWidget(
                  text: member?.phoneNumber ?? "",
                  textColor: const Color(0XFF6E7A84),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 4,
                ),
                MultiCallTextWidget(
                  text: member?.callStatus.toReadableString() ?? "",
                  textColor: const Color(0XFF6E7A84),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<SpeakingProvider>(
                  builder: (context, speakingProvider, child) {
                    final isSpeaking =
                        speakingProvider.isSpeaking(member?.phoneNumber ?? "");
                    return (isSpeaking &&
                            member?.callStatus == CallStatus.joinedTheCall)
                        ? const DualToneIcon(
                            iconSrc: PhosphorIconsRegular.waveform,
                            size: 24,
                            margin: 0,
                            padding: Padding(padding: EdgeInsets.zero),
                            color: Color(0XFF0086B5),
                            borderColor: Colors.transparent,
                          )
                        : const SizedBox.shrink();
                  },
                ),
                member?.callStatus == CallStatus.joinedTheCall
                    ? Row(
                        children: [
                          DualToneIcon(
                            iconSrc: (member?.muteStatus == MuteStatus.muted)
                                ? PhosphorIconsDuotone.microphoneSlash
                                : PhosphorIconsDuotone.microphone,
                            duotoneSecondaryColor:
                                const Color.fromRGBO(0, 134, 181, 1),
                            color: Colors.black,
                            size: 16,
                            padding: const Padding(padding: EdgeInsets.all(10)),
                            margin: 16,
                            press: () async {
                              if (member?.muteStatus == MuteStatus.muted) {
                                //var response = await
                                provider.unMuteCall(
                                  scheduleRefNumber: scheduleRefNumber,
                                  participantPhoneNumber:
                                      member?.phoneNumber ?? "",
                                  profileRefNumber:
                                      selectedProfile?.profileRefNo ?? 0,
                                );

                                member?.let((m) {
                                  provider.unMuteMember(m);
                                });

                                // if (response.muteStatus == MuteStatus.unMuted) {
                                //   provider.unMuteMember(member);
                                // } else {
                                //   showToast("Error in un-muting member");
                                // }
                              } else {
                                //var response = await
                                provider.muteCall(
                                  scheduleRefNumber: scheduleRefNumber,
                                  participantPhoneNumber:
                                      member?.phoneNumber ?? "",
                                  profileRefNumber:
                                      selectedProfile?.profileRefNo ?? 0,
                                );

                                member?.let((m) {
                                  provider.muteMember(m);
                                });

                                // if (response.muteStatus == MuteStatus.muted) {
                                //   provider.muteMember(member);
                                // } else {
                                //   showToast("Error in muting member");
                                // }
                              }
                            },
                          ),
                          DualToneIcon(
                            iconSrc: PhosphorIconsLight.x,
                            duotoneSecondaryColor:
                                const Color.fromRGBO(0, 134, 181, 1),
                            color: Colors.black,
                            size: 16,
                            padding: const Padding(padding: EdgeInsets.all(10)),
                            margin: 0,
                            press: () {
                              member?.let((m) {
                                provider.updateMemberStatus(
                                    m, CallStatus.leftTheCall);
                              });

                              member?.phoneNumber.let((phoneNumber) {
                                provider.endCallForParticipant(
                                    participantPhoneNumber: phoneNumber);
                              });
                            },
                          ),
                        ],
                      )
                    : member?.callStatus == CallStatus.dialing
                        ? const SizedBox.shrink()
                        : MultiCallOutLineButtonWidget(
                            text: "Redial",
                            textColor: const Color(0XFF62B414),
                            borderColor: const Color(0XFF62B414),
                            onTap: () {
                              /// Change the status and Redial
                              member?.let((m) {
                                provider.updateMemberStatus(
                                    m, CallStatus.dialing);
                                redialCallForParticipant(m, context);
                              });
                            },
                          ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const Divider(
          color: Color(0XFFCDD3D7),
          height: 1,
        ),
      ],
    );
  }

  void showAddMemberBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 280,
          child: Padding(
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
                          builder: (context) => const ContactScreen(
                            isFromCurrentCallingScreen: true,
                          ),
                        ),
                      );
                    },
                    iconData: PhosphorIconsDuotone.addressBook,
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
                    title: "Add Groups",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupListScreen(
                            isFromCurrentCallingScreen: true,
                          ),
                        ),
                      );
                    },
                    iconData: PhosphorIconsDuotone.usersFour,
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
                    title: "Dial Number",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPhoneNumberScreen(
                                  isFromCurrentCallingScreen: true,
                                )),
                      );
                    },
                    iconData: PhosphorIconsDuotone.dotsSix,
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

  void redialCallForAll() {
    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    provider.redialAll(
      scheduleRefNumber: provider.scheduleRefNumber,
      profileRefNumber: provider.selectedProfile?.profileRefNo ?? 0,
    );
  }
}

// Call this function from ReDial button for particular member
void redialCallForParticipant(
    ConferenceParticipant member, BuildContext context) {
  var provider = Provider.of<InstantCallProvider>(context, listen: false);
  provider.redialParticipant(
    scheduleRefNumber: provider.scheduleRefNumber,
    participantPhoneNumber: member.phoneNumber,
    profileRefNumber: provider.selectedProfile?.profileRefNo ?? 0,
    // static value
  );
}

/// A widget that displays a list of member names in a single line.
/// The names are truncated with an ellipsis if they exceed the available width.
/// The widget also appends "You" or "and You" at the end of the names list.
///
/// Author: Darshak Kakkad
class MemberListCell extends StatefulWidget {
  /// The member whose info is to be displayed.
  final ConferenceParticipant? member;

  /// The provider which holds the state of the call.
  final InstantCallProvider provider;

  /// The provider which is responsible for fetching contact info.
  final ContactProvider contactProvider;

  /// The selected profile.
  final Profile? selectedProfile;

  /// The schedule reference number.
  final int scheduleRefNumber;

  /// Creates a cell that displays the member's info.
  const MemberListCell({
    super.key,
    required this.member,
    required this.provider,
    required this.contactProvider,
    required this.selectedProfile,
    required this.scheduleRefNumber,
  });

  @override
  MemberListCellState createState() => MemberListCellState();
}

class MemberListCellState extends State<MemberListCell> {
  Timer? _debounceTimer;
  String? _currentName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateName();
    });
  }

  void _updateName() async {
    final name = await widget.contactProvider
        .getMappedMember(widget.member?.phoneNumber ?? "");

    if (mounted && _currentName != name?.name) {
      setState(() {
        _currentName = name?.name;
      });
    }
  }

  @override
  void didUpdateWidget(covariant MemberListCell oldWidget) {
    super.didUpdateWidget(oldWidget);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), _updateName);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMyNumber = PreferenceHelper.get(PrefUtils.userPhoneNumber) ==
        widget.member?.phoneNumber;

    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isMyNumber
                    ? const MultiCallTextWidget(
                        text: "You",
                        textColor: Color(0XFF101315),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )
                    : MultiCallTextWidget(
                        text: _currentName ?? "Unknown",
                        textColor: const Color(0XFF101315),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                const SizedBox(height: 4),
                MultiCallTextWidget(
                  text: widget.member?.phoneNumber ?? "",
                  textColor: const Color(0XFF6E7A84),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 4),
                MultiCallTextWidget(
                  text: widget.member?.callStatus.toReadableString() ?? "",
                  textColor: const Color(0XFF6E7A84),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<SpeakingProvider>(
                  builder: (context, speakingProvider, child) {
                    final isSpeaking = speakingProvider
                        .isSpeaking(widget.member?.phoneNumber ?? "");
                    return (isSpeaking &&
                            widget.member?.callStatus ==
                                CallStatus.joinedTheCall)
                        ? const DualToneIcon(
                            iconSrc: PhosphorIconsRegular.waveform,
                            size: 24,
                            margin: 0,
                            padding: Padding(padding: EdgeInsets.zero),
                            color: Color(0XFF0086B5),
                            borderColor: Colors.transparent,
                          )
                        : const SizedBox.shrink();
                  },
                ),
                widget.member?.callStatus == CallStatus.joinedTheCall
                    ? Row(
                        children: [
                          DualToneIcon(
                            iconSrc:
                                (widget.member?.muteStatus == MuteStatus.muted)
                                    ? PhosphorIconsDuotone.microphoneSlash
                                    : PhosphorIconsDuotone.microphone,
                            duotoneSecondaryColor:
                                const Color.fromRGBO(0, 134, 181, 1),
                            color: Colors.black,
                            size: 16,
                            padding: const Padding(padding: EdgeInsets.all(10)),
                            margin: 16,
                            press: () async {
                              if (widget.member?.muteStatus ==
                                  MuteStatus.muted) {
                                //var response = await
                                widget.provider.unMuteCall(
                                  scheduleRefNumber: widget.scheduleRefNumber,
                                  participantPhoneNumber:
                                      widget.member?.phoneNumber ?? "",
                                  profileRefNumber:
                                      widget.selectedProfile?.profileRefNo ?? 0,
                                );

                                widget.member?.let((m) {
                                  widget.provider.unMuteMember(m);
                                });
                              } else {
                                //var response = await
                                widget.provider.muteCall(
                                  scheduleRefNumber: widget.scheduleRefNumber,
                                  participantPhoneNumber:
                                      widget.member?.phoneNumber ?? "",
                                  profileRefNumber:
                                      widget.selectedProfile?.profileRefNo ?? 0,
                                );

                                widget.member?.let((m) {
                                  widget.provider.muteMember(m);
                                });
                              }
                            },
                          ),
                          DualToneIcon(
                            iconSrc: PhosphorIconsLight.x,
                            duotoneSecondaryColor:
                                const Color.fromRGBO(0, 134, 181, 1),
                            color: Colors.black,
                            size: 16,
                            padding: const Padding(padding: EdgeInsets.all(10)),
                            margin: 0,
                            press: () {
                              widget.member?.let((m) {
                                widget.provider.updateMemberStatus(
                                    m, CallStatus.leftTheCall);
                              });

                              widget.member?.phoneNumber.let((phoneNumber) {
                                widget.provider.endCallForParticipant(
                                    participantPhoneNumber: phoneNumber);
                              });
                            },
                          ),
                        ],
                      )
                    : widget.member?.callStatus == CallStatus.dialing
                        ? const SizedBox.shrink()
                        : MultiCallOutLineButtonWidget(
                            text: "Redial",
                            textColor: const Color(0XFF62B414),
                            borderColor: const Color(0XFF62B414),
                            onTap: () {
                              /// Change the status and Redial
                              widget.member?.let((m) {
                                widget.provider
                                    .updateMemberStatus(m, CallStatus.dialing);
                                redialCallForParticipant(m, context);
                              });
                            },
                          ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(
          color: Color(0XFFCDD3D7),
          height: 1,
        ),
      ],
    );
  }
}
