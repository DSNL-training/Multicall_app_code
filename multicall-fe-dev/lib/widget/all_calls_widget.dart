import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/response_restore_call_history.dart';
import 'package:multicall_mobile/providers/contact_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now_screen.dart';
import 'package:multicall_mobile/screens/instant_call_screen.dart';
import 'package:multicall_mobile/screens/instant_call_screen_call_now.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/member_list_widget.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:provider/provider.dart';

class AllCallsTab extends StatefulWidget {
  const AllCallsTab({
    super.key,
  });

  @override
  AllCallsTabState createState() => AllCallsTabState();
}

class AllCallsTabState extends State<AllCallsTab> {
  List<String> extractPhoneNumbers(List<Participant> data) {
    return data.map((item) => item.phoneNumber).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileController, CallsController, InstantCallProvider,
        ContactProvider>(
      builder: (context, profileController, provider, instantCallProvider,
          contactProvider, child) {
        return provider.isAllCallLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(98, 180, 20, 1),
                ),
              )
            : !(provider.allCallsHistory.isNotEmpty &&
                    profileController.profiles.isNotEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/telephone.png',
                          height: 104,
                          width: 170,
                        ),
                      ),
                      const GlobalText(
                        text: "Let's dial. Time to make those impactful calls!",
                        fontWeight: FontWeight.w700,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RowWithTextButtons(
                          buttonWidth: 130,
                          callLaterAction: () {
                            final defaultProfile =
                                Provider.of<ProfileController>(context,
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
                                  Provider.of<CallsController>(context,
                                          listen: false)
                                      .clearMembers();
                                  return const CallDialTypeSelection();
                                },
                              );
                            }
                          },
                          callNowAction: () {
                            //debugPrint("Call Now Button Tapped...");
                            instantCallProvider.memberList.clear();
                            Navigator.of(context)
                                .pushNamed(CallNowScreen.routeName);
                          },
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        /// Bulk Update - Active Call
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: instantCallProvider.bulkUpdateData != null
                              ? 1
                              : 0,
                          itemBuilder: (context, index) {
                            final bulkUpdateCall =
                                instantCallProvider.bulkUpdateData;
                            final profiles = profileController.defaultProfile;
                            List<String>? phoneNumbers = instantCallProvider
                                .bulkUpdateData?.conferences
                                .map((item) => item.phoneNumber)
                                .toList();
                            final profile = profileController.profiles
                                .firstWhere(
                                    (element) =>
                                        element.profileRefNo ==
                                        bulkUpdateCall!.profileRefNo,
                                    orElse: () {
                              return profiles!;
                            });
                            return InkWell(
                              onTap: () {
                                final selectedProfile =
                                    Provider.of<ProfileController>(context,
                                            listen: false)
                                        .profiles
                                        .firstWhere((element) =>
                                            element.profileRefNo ==
                                            bulkUpdateCall?.profileRefNo);

                                /// Navigate to instant call screen
                                Navigator.of(context).pushNamed(
                                  InstantCallScreenCallNow.routeName,
                                  arguments: {
                                    'selectedProfile': selectedProfile,
                                    'scheduleRefNumber':
                                        bulkUpdateCall?.scheduleRefNo,
                                    'conferenceRefNumber':
                                        bulkUpdateCall?.confRefNo,
                                  },
                                );

                                debugPrint(
                                    'Navigating to ongoing bulkUpdateCall screen for: ${bulkUpdateCall?.scheduleRefNo.toString()}');
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.lightGreen[100],
                                                  shape: BoxShape.circle,
                                                  // border: Border.all(color: Colors.green),
                                                ),
                                                child: const Icon(
                                                  Icons.call_received,
                                                  size: 10,
                                                  color: Color.fromRGBO(
                                                      98, 180, 20, 1),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      bulkUpdateCall
                                                                  ?.scheduleRefNo ==
                                                              1
                                                          ? 'Instant Call, ${profile.profileName}'
                                                          : 'Scheduled Call, ${profile.profileName}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    FutureBuilder(
                                                      future: contactProvider
                                                          .fetchMemberNames(
                                                        phoneNumbers!
                                                            .where((e) {
                                                              return e !=
                                                                  PreferenceHelper
                                                                      .get(PrefUtils
                                                                          .userPhoneNumber);
                                                            })
                                                            .map((e) => e)
                                                            .toList(),
                                                      ),
                                                      builder: (
                                                        BuildContext context,
                                                        AsyncSnapshot<
                                                                List<String>>
                                                            snapshot,
                                                      ) {
                                                        return Visibility(
                                                          visible: snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done,
                                                          maintainAnimation:
                                                              true,
                                                          maintainState: true,
                                                          maintainSize: true,
                                                          child: MembersList(
                                                            /// send name from members as a string array and text style here
                                                            members:
                                                                snapshot.data ??
                                                                    [],
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Active Call",
                                              style: TextStyle(
                                                color: Color(0xFF62B414),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.all(4),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        /// Call History
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.allCallsHistory.length,
                          itemBuilder: (context, index) {
                            final call = provider.allCallsHistory[index];
                            final profiles = profileController.defaultProfile;
                            List<String> phoneNumbers =
                                extractPhoneNumbers(call.participants);
                            final profile = profileController.profiles
                                .firstWhere(
                                    (element) =>
                                        element.profileRefNo ==
                                        call.profileRefNum, orElse: () {
                              return profiles!;
                            });
                            return InkWell(
                              onTap: () {
                                /// Set selected position
                                provider.selectedCallHistoryIndex = index;

                                /// Navigate to details screen
                                Navigator.of(context)
                                    .pushNamed(InstantCallScreen.routeName);

                                debugPrint(
                                    'Navigating to details for: ${call.scheduleRefNum}');
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.lightGreen[100],
                                                  shape: BoxShape.circle,
                                                  // border: Border.all(color: Colors.green),
                                                ),
                                                child: const Icon(
                                                  Icons.call_received,
                                                  size: 10,
                                                  color: Color.fromRGBO(
                                                      98, 180, 20, 1),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      call.scheduleRefNum == 1
                                                          ? 'Instant Call, ${profile.profileName}'
                                                          : 'Scheduled Call, ${profile.profileName}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    FutureBuilder(
                                                      future: contactProvider
                                                          .fetchMemberNames(
                                                        phoneNumbers
                                                            .where(
                                                              (e) {
                                                                return e !=
                                                                    PreferenceHelper.get(
                                                                        PrefUtils
                                                                            .userPhoneNumber);
                                                              },
                                                            )
                                                            .map((e) => e)
                                                            .toList(),
                                                      ),
                                                      builder: (
                                                        BuildContext context,
                                                        AsyncSnapshot<
                                                                List<String>>
                                                            snapshot,
                                                      ) {
                                                        return MembersList(
                                                          /// send name from members as a string array and text style here
                                                          members:
                                                              snapshot.data ??
                                                                  [],
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(height: 8),
                                                    if (call.recordedFileNumberByte !=
                                                        0)
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 2,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: const Text(
                                                          'Recorded',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              getTimeLabel(call.startTime),
                                              style: TextStyle(
                                                color: getTimeLabel(
                                                            call.startTime) ==
                                                        "Active Call"
                                                    ? const Color(0xFF62B414)
                                                    : Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.all(4),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
      },
    );
  }

  /// Determines the appropriate time label based on the provided start time.
  ///
  /// The function parses the input `startTime` string in the format `yyyyMMddHHmm`
  /// and compares it with the current date and time. It returns a label based on the
  /// following criteria:
  ///
  /// - Active Call" if the `startTime` is within an hour before the current time.
  /// - The time in `HH:mm` format if the `startTime` is today.
  /// - The day of the week if the `startTime` is within the current week.
  /// - The full date in `dd/MM/yyyy` format for any other cases.
  ///
  /// [startTime] is expected to be a string in the format `yyyyMMddHHmm`.
  ///
  /// Returns:
  /// A `String` representing the time label based on the provided `startTime`.
  ///
  /// Example usage:
  /// ```dart
  /// String startTime = "202305251411"; // Example start time
  /// print(getTimeLabel(startTime)); // Output will depend on the current date and time
  /// ```
  String getTimeLabel(String startTime) {
    // Define the formats
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateFormat dayFormat = DateFormat('EEEE');

    // Manually extract components from the startTime string
    int year = int.parse(startTime.substring(0, 4));
    int month = int.parse(startTime.substring(4, 6));
    int day = int.parse(startTime.substring(6, 8));
    int hour = int.parse(startTime.substring(8, 10));
    int minute = int.parse(startTime.substring(10, 12));

    // Create a DateTime object
    DateTime parsedTime = DateTime(year, month, day, hour, minute);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Check if the start time is today
    if (parsedTime.year == now.year &&
        parsedTime.month == now.month &&
        parsedTime.day == now.day) {
      return timeFormat.format(parsedTime);
    }

    // Check if the start time is within the same week
    if (parsedTime.isAfter(now.subtract(Duration(days: now.weekday - 1))) &&
        parsedTime.isBefore(
            now.add(Duration(days: DateTime.daysPerWeek - now.weekday)))) {
      return dayFormat.format(parsedTime);
    }

    // Otherwise, return the full date
    return dateFormat.format(parsedTime);
  }
}

class Call {
  String title;
  String participants;
  String dateTime;
  bool isRecorded;
  CallType callType;

  Call(this.title, this.participants, this.dateTime,
      {this.isRecorded = false, this.callType = CallType.incoming});
}

enum CallType { incoming, missed, active }

List<String> extractPhoneNumbers(List<Map<String, dynamic>> data) {
  // Create an empty list to store the phone numbers
  List<String> phoneNumbers = [];

  // Iterate through each map in the list
  for (var entry in data) {
    // Check if the key 'phoneNumber' exists in the map
    if (entry.containsKey('phoneNumber')) {
      // Add the value associated with 'phoneNumber' to the list
      phoneNumbers.add(entry['phoneNumber']);
    }
  }

  return phoneNumbers;
}
