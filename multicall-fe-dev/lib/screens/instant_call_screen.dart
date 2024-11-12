import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/providers/contact_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/new_group_screen.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/call_container.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InstantCallScreen extends StatefulWidget {
  static const routeName = '/instant_call_screen';

  const InstantCallScreen({super.key});

  @override
  State<InstantCallScreen> createState() => _InstantCallScreenState();
}

class _InstantCallScreenState extends State<InstantCallScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer2<CallsController, ContactProvider>(
      builder: (context, provider, contactProvider, child) {
        final callHistory =
            provider.allCallsHistory[provider.selectedCallHistoryIndex];

        final profile = Provider.of<ProfileController>(context, listen: false)
            .profiles
            .firstWhere(
              (element) => element.profileRefNo == callHistory.profileRefNum,
              orElse: () =>
                  Provider.of<ProfileController>(context, listen: false)
                      .profiles[0],
            );

        // Define the formats
        DateFormat timeFormat = DateFormat('HH:mm');
        DateFormat dateFormat = DateFormat('dd MMM yyyy');

        // Manually extract components from the startTime string
        int year = int.parse(callHistory.startTime.substring(0, 4));
        int month = int.parse(callHistory.startTime.substring(4, 6));
        int day = int.parse(callHistory.startTime.substring(6, 8));
        int hour = int.parse(callHistory.startTime.substring(8, 10));
        int minute = int.parse(callHistory.startTime.substring(10, 12));

        // Create a DateTime object
        DateTime parsedTime = DateTime(year, month, day, hour, minute);

        // Format the DateTime object
        String formattedTime = timeFormat.format(parsedTime);
        String formattedDate = dateFormat.format(parsedTime);

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: CustomAppBar(
            leading: Text(
              callHistory.scheduleRefNum == 1
                  ? 'Instant Call'
                  : 'Scheduled Call',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
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
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Lato",
                                ),
                              ),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Lato",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(222, 246, 255, 1),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    buildGlobalText(
                                      'Call Duration',
                                      14,
                                      FontWeight.w700,
                                      TextAlign.center,
                                      const EdgeInsets.only(bottom: 6),
                                    ),
                                    buildGlobalText(
                                      '${(callHistory.confDuration / 60).round()} ${(callHistory.confDuration / 60).round() == 1 ? 'min' : 'mins'}',
                                      18,
                                      FontWeight.w700,
                                      TextAlign.center,
                                      const EdgeInsets.only(bottom: 6),
                                    ),
                                    buildGlobalText(
                                      'Rounded to the \nnearest minute',
                                      12,
                                      FontWeight.w400,
                                      TextAlign.center,
                                      const EdgeInsets.all(0),
                                    ),
                                  ],
                                ),
                                const VerticalDashedDivider(
                                  height: 110,
                                ),
                                Column(
                                  children: [
                                    buildGlobalText(
                                      'Call Cost',
                                      14,
                                      FontWeight.w700,
                                      TextAlign.center,
                                      const EdgeInsets.only(bottom: 6),
                                    ),
                                    buildGlobalText(
                                      '₹0.00',
                                      18,
                                      FontWeight.w700,
                                      TextAlign.center,
                                      const EdgeInsets.only(bottom: 6),
                                    ),
                                    buildGlobalText(
                                      'Include call \nsetup costs',
                                      12,
                                      FontWeight.w400,
                                      TextAlign.center,
                                      const EdgeInsets.all(0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible:
                                    callHistory.recordedFileNumberByte != 0,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const GlobalText(
                                          text: "Playback Options",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          textAlign: TextAlign.center,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.zero,
                                        ),
                                        CallToListenAction(
                                          clickAction: () async {
                                            /// Call to listen recorded call:

                                            final Uri url = Uri(
                                              scheme: "tel",
                                              path: "04471261607",
                                            );

                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            } else {
                                              showToast(
                                                  "Cannot make this call");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          recordingInfoBottomSheet(
                                            context,
                                            callHistory.did1.toString(),
                                            callHistory.did2.toString(),
                                            callHistory.did3.toString(),
                                            callHistory.recordedFileNumberByte
                                                .toString(),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              PhosphorIconsLight.info,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  const Text(
                                                    "File will available for playback for 1 day(s).",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  RichText(
                                                    text: const TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "How it Works?",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF0086b5),
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const GlobalText(
                                text: "Calling Profile",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              GlobalText(
                                text: profile.profileName,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(110, 122, 132, 1),
                                textAlign: TextAlign.center,
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),

                          /// Call Members Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GlobalText(
                                text:
                                    "Call Members - ${callHistory.participants.length}",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                textAlign: TextAlign.center,
                                alignment: Alignment.center,
                                padding: EdgeInsets.zero,
                              ),
                              TextButtonWithBG(
                                iconData: PhosphorIconsBold.usersFour,
                                iconColor: const Color.fromRGBO(0, 134, 181, 1),
                                size: 15,
                                title: "Create Group",
                                textColor: const Color.fromRGBO(0, 134, 181, 1),
                                fontSize: 12,
                                action: () async {
                                  final groupController =
                                      Provider.of<GroupController>(context,
                                          listen: false);

                                  groupController.newCreatingGroup ??= Group(
                                    groupId: 0,
                                    name: "New Group",
                                    profileRefNum: profile.profileRefNo,
                                    isFavorite: 0,
                                    members: [],
                                  );

                                  var temporaryGroupMembers = <GroupMembers>[];
                                  for (var element
                                      in callHistory.participants) {
                                    final contactMember = await Provider.of<
                                                ContactProvider>(context,
                                            listen: false)
                                        .getMappedMember(element.phoneNumber);
                                    var memberName = "Unknown";
                                    if (contactMember != null) {
                                      memberName =
                                          contactMember.name ?? "Unknown";
                                    }

                                    temporaryGroupMembers.add(GroupMembers(
                                      memberName: memberName,
                                      memberEmail: "",
                                      memberTelephone: element.phoneNumber,
                                    ));
                                  }

                                  groupController.newCreatingGroup?.members =
                                      temporaryGroupMembers;
                                  Navigator.of(context)
                                      .pushNamed(NewGroupScreen.routeName);
                                },
                                width: 120,
                                color: Colors.white,
                              ),
                            ],
                          ),

                          /// Call Members List
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: callHistory.participants.length,
                              itemBuilder: (context, index) {
                                final isMyNumber = PreferenceHelper.get(
                                        PrefUtils.userPhoneNumber) ==
                                    callHistory.participants[index].phoneNumber;

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          isMyNumber
                                              ? const Text(
                                                  "You",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0,
                                                  ),
                                                )
                                              : FutureBuilder(
                                                  future: contactProvider
                                                      .getMappedMember(
                                                          callHistory
                                                              .participants[
                                                                  index]
                                                              .phoneNumber),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              ContactMember?>
                                                          snapshot) {
                                                    return Visibility(
                                                      visible: snapshot
                                                              .connectionState ==
                                                          ConnectionState.done,
                                                      maintainAnimation: true,
                                                      maintainState: true,
                                                      maintainSize: true,
                                                      child: Text(
                                                        snapshot.data?.name ??
                                                            "Unknown",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                          Text(
                                            callHistory.participants[index]
                                                .phoneNumber,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.0,
                                                color: Color(0xFF6E7A84)),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// Divider between members list items
                                    if (index !=
                                        callHistory.participants.length - 1)
                                      const HorizontalDivider(
                                          color: Color(0xFFDDE1E4)),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 16,
                    bottom: 12 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: MultiCallOutLineButtonWidget(
                            text: "Call Later",
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            borderColor: const Color(0XFF62B414),
                            backgroundColor: const Color(0XFFDAEFC6),
                            textColor: const Color(0XFF62B414),
                            borderRadius: 8,
                            onTap: () async {
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
                                /// CALL LATER FUNCTIONALITY

                                /// Clear previous session
                                Provider.of<CallsController>(context,
                                        listen: false)
                                    .clearMembers();

                                final filteredCallMeOnList =
                                    Provider.of<CallMeOnController>(context,
                                            listen: false)
                                        .filteredCallMeOnList;

                                /// adding members to memberList excluding my number
                                for (var element in callHistory.participants) {
                                  if (!filteredCallMeOnList.any((e) =>
                                      e.callMeOn == element.phoneNumber)) {
                                    final contactMember = await Provider.of<
                                                ContactProvider>(context,
                                            listen: false)
                                        .getMappedMember(element.phoneNumber);
                                    var memberName = "Unknown";
                                    if (contactMember != null) {
                                      memberName =
                                          contactMember.name ?? "Unknown";
                                    }

                                    Provider.of<CallsController>(context,
                                            listen: false)
                                        .addMembers([
                                      ScheduleCallMember(
                                        memberName: memberName,
                                        memberTelephone: element.phoneNumber,
                                        memberEmail: "",
                                      )
                                    ]);
                                  }
                                }

                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  showDragHandle: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CallDialTypeSelection(
                                      isFromCallHistory: true,
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: MultiCallOutLineButtonWidget(
                            text: "Call Now",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            textColor: Colors.white,
                            borderRadius: 8,
                            backgroundColor: const Color(0XFF62B414),
                            borderColor: const Color(0XFF62B414),
                            iconData: PhosphorIconsLight.phoneCall,
                            iconSize: 20,
                            onTap: () async {
                              /// CALL NOW FUNCTIONALITY
                              Provider.of<InstantCallProvider>(context,
                                      listen: false)
                                  .memberList
                                  .clear();

                              final filteredCallMeOnList =
                                  Provider.of<CallMeOnController>(context,
                                          listen: false)
                                      .filteredCallMeOnList;

                              /// add members to memberList excluding my number
                              for (var element in callHistory.participants) {
                                if (!filteredCallMeOnList.any(
                                    (e) => e.callMeOn == element.phoneNumber)) {
                                  final contactMember =
                                      await Provider.of<ContactProvider>(
                                              context,
                                              listen: false)
                                          .getMappedMember(element.phoneNumber);
                                  var memberName = "Unknown";
                                  if (contactMember != null) {
                                    memberName =
                                        contactMember.name ?? "Unknown";
                                  }

                                  Provider.of<InstantCallProvider>(context,
                                          listen: false)
                                      .addMembers([
                                    MemberListModel(
                                        name: memberName,
                                        phoneNumber: element.phoneNumber)
                                  ]);
                                }
                              }

                              Navigator.of(context)
                                  .pushNamed(CallNowScreen.routeName);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void recordingInfoBottomSheet(
    BuildContext context,
    String did1,
    String did2,
    String did3,
    String recordedFileNumberByte,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/notch.svg',
                height: 50,
                width: 100,
              ),
              const GlobalText(
                text: "Listen to your call recording by dialing the numbers",
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              GlobalText(
                text: "$did1, $did2, $did3",
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              const GlobalText(
                text:
                    "Enter your MultiCall code and your recording file number to listen to the call recording.",
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              const GlobalText(
                text: "For eg., 044-2370 2370, 3567#, 12345#",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(110, 122, 132, 1),
              ),
              buildGlobalTextRow(
                "Dial-in number",
                did1,
                FontWeight.w400,
                14,
                const Color.fromRGBO(110, 122, 132, 1),
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              ),
              buildGlobalTextRow(
                "File number",
                recordedFileNumberByte,
                FontWeight.w400,
                14,
                const Color.fromRGBO(110, 122, 132, 1),
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextButtonWithBG(
                  size: 20,
                  title: "OK",
                  fontSize: 16,
                  action: () {
                    Navigator.pop(context);
                  },
                  width: double.infinity,
                  color: const Color.fromRGBO(0, 134, 181, 1),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildGlobalText(String text, double fontSize, FontWeight fontWeight,
      TextAlign textAlign, EdgeInsets padding) {
    return GlobalText(
      text: text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: const Color.fromRGBO(0, 134, 181, 1),
      textAlign: textAlign,
      padding: padding,
    );
  }
}

class CallToListenAction extends StatelessWidget {
  const CallToListenAction({
    super.key,
    required this.clickAction,
  });

  final VoidCallback clickAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickAction,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(
            0,
            134,
            181,
            1,
          ), // Set your desired color
          borderRadius: BorderRadius.circular(
            4,
          ), // Set border radius to 4
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsFill.playCircle,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Call to Listen",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget buildGlobalTextRow(
  String title,
  String value,
  FontWeight fontWeight,
  double fontSize,
  Color color,
  EdgeInsets padding,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GlobalText(
        text: title,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        padding: padding,
      ),
      GlobalText(
        text: value,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        padding: padding,
      ),
    ],
  );
}
