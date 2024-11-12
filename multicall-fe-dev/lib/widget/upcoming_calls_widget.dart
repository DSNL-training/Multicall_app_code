import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/response_invitation_sync.dart';
import 'package:multicall_mobile/models/response_merged_schedule_calls_n_members.dart';
import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now_screen.dart';
import 'package:multicall_mobile/screens/schedule_dial_in_screen.dart';
import 'package:multicall_mobile/screens/scheduled_invitation_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/member_list_widget.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:provider/provider.dart';

class UpcomingCallsTab extends StatelessWidget {
  const UpcomingCallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CallsController>(
      builder: (context, callsController, child) {
        return Column(
          children: [
            /// Check for no calls and show empty state
            callsController.mergedScheduleCalls.isEmpty &&
                    callsController.invitations.isEmpty
                ?

                /// Empty State View
                Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/calender.png',
                          height: 104,
                          width: 170,
                        ),
                      ),
                      const GlobalText(
                        text:
                            "Our calendar is open for friendly conversations.",
                        fontWeight: FontWeight.w700,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RowWithTextButtons(
                        buttonWidth: 130,
                        callLaterAction: () {
                          final defaultProfile = Provider.of<ProfileController>(
                                  context,
                                  listen: false)
                              .defaultProfile;

                          if (defaultProfile?.facilityElement !=
                              AppConstants.allowScheduling) {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return const OnlyPaidDialogue();
                              },
                            );
                            return;
                          } else {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              showDragHandle: false,
                              context: context,
                              builder: (BuildContext context) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Provider.of<CallsController>(context,
                                          listen: false)
                                      .clearMembers();
                                });
                                return const CallDialTypeSelection();
                              },
                            );
                          }
                        },
                        callNowAction: () {
                          Provider.of<InstantCallProvider>(context,
                                  listen: false)
                              .memberList
                              .clear();
                          Navigator.of(context)
                              .pushNamed(CallNowScreen.routeName);
                          // showModalBottomSheet<void>(
                          //   isScrollControlled: true,
                          //   showDragHandle: true,
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return RatingBottomSheet(
                          //       closeFunc: () {
                          //         Navigator.pop(context);
                          //       },
                          //     );
                          //   },
                          // );
                        },
                      ),
                    ],
                  ))
                :

                /// Actual Content to be shown
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          callsController.invitations.isEmpty
                              ? const SizedBox.shrink()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: callsController.invitations.length,
                                  itemBuilder: (context, index) {
                                    final invitation =
                                        callsController.invitations[index];
                                    return InvitationListItem(
                                      data: invitation,
                                      onTap: () {
                                        /// set selected upcoming call position
                                        callsController
                                            .setSelectedUpcomingCallScheduleRefNo(
                                          invitation.scheduleRefNo,
                                        );

                                        /// navigate to schedule dial in screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScheduledInvitationScreen(
                                              scheduleRefNo:
                                                  invitation.scheduleRefNo,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                          callsController.mergedScheduleCalls.isNotEmpty
                              ? ListView.builder(
                                  itemCount: callsController
                                      .mergedScheduleCalls.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final scheduleCall = callsController
                                        .mergedScheduleCalls[index];
                                    return ScheduleCallListItem(
                                      data: scheduleCall,
                                      onTap: () {
                                        /// set selected upcoming call position
                                        callsController
                                            .setSelectedUpcomingCallPosition(
                                                index);

                                        /// navigate to schedule dial in screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScheduleDialInScreen(
                                                    currentIndex: index),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),
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

class InvitationListItem extends StatelessWidget {
  final ResponseInvitationSync data;
  final VoidCallback onTap;

  const InvitationListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(data.scheduleDateTime);
    String day = DateFormat("dd").format(dateTime);
    String month = DateFormat("MMM").format(dateTime);
    String time = DateFormat("HH:mm").format(dateTime);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day, // date
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  data.confName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto",
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatMemberNames(List<ScheduleCallMembers> members) {
    if (members.isEmpty) return "";

    // If there is only one member, return their name
    if (members.length == 1) {
      return members.first.name;
    }

    // If there are exactly two members, display them with " and " between
    if (members.length == 2) {
      return "${members.first.name} and ${members.last.name}";
    }

    // Initialize an empty list to store formatted names
    List<String> formattedNames = [];

    // Add the first member's name, truncated if necessary
    formattedNames.add(members[0].name.length <= 10
        ? members[0].name
        : "${members[0].name.substring(0, 10)}...");

    // Add the second member's full name
    formattedNames.add(members[1].name);

    // If there are more than two members, add ellipsis and remaining members
    if (members.length > 2) {
      formattedNames.add("...");
      formattedNames.addAll(members.skip(2).map((member) => member.name));
    }

    // Join formatted names with comma and add "and" before the last name
    String result = formattedNames.join(", ");
    int lastCommaIndex = result.lastIndexOf(", ");
    if (lastCommaIndex != -1) {
      result =
          "${result.substring(0, lastCommaIndex)} and${result.substring(lastCommaIndex + 1)}";
    }

    return result;
  }
}

class ScheduleCallListItem extends StatelessWidget {
  final MergedScheduleCallResponse data;
  final VoidCallback onTap;

  const ScheduleCallListItem(
      {super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm")
        .parse(data.scheduleDetail.scheduleDateTime);
    String day = DateFormat("dd").format(dateTime);
    String month = DateFormat("MMM").format(dateTime);
    String time = DateFormat("HH:mm").format(dateTime);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day, // date
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF101315),
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0XFF101315),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.scheduleDetail.chairpersonName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF101315),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    MembersList(
                      /// send name from members as a string array and text style here
                      members: data.members
                          .where(
                            (e) {
                              return e.phone !=
                                  PreferenceHelper.get(
                                      PrefUtils.userPhoneNumber);
                            },
                          )
                          .map((e) => e.name)
                          .toList(),
                      textStyle: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF6E7A84),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto",
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatMemberNames(List<ScheduleCallMembers> members) {
    if (members.isEmpty) return "";

    // If there is only one member, return their name
    if (members.length == 1) {
      return members.first.name;
    }

    // If there are exactly two members, display them with " and " between
    if (members.length == 2) {
      return "${members.first.name} and ${members.last.name}";
    }

    // Initialize an empty list to store formatted names
    List<String> formattedNames = [];

    // Add the first member's name, truncated if necessary
    formattedNames.add(members[0].name.length <= 10
        ? members[0].name
        : "${members[0].name.substring(0, 10)}...");

    // Add the second member's full name
    formattedNames.add(members[1].name);

    // If there are more than two members, add ellipsis and remaining members
    if (members.length > 2) {
      formattedNames.add("...");
      formattedNames.addAll(members.skip(2).map((member) => member.name));
    }

    // Join formatted names with comma and add "and" before the last name
    String result = formattedNames.join(", ");
    int lastCommaIndex = result.lastIndexOf(", ");
    if (lastCommaIndex != -1) {
      result =
          "${result.substring(0, lastCommaIndex)} and${result.substring(lastCommaIndex + 1)}";
    }

    return result;
  }
}

class CallItem {
  final String date;
  final String month;
  final String title;
  final String subtitle;
  final String time;

  CallItem(
      {required this.date,
      required this.month,
      required this.title,
      required this.subtitle,
      required this.time});
}
