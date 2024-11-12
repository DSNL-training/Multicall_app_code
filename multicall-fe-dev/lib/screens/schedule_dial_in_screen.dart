import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/request_schedule_estimation_members.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_change_conferee_list.dart';
import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/models/response_restore_schedule_start.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/group_list_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/multiple_click_handler.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/call_container.dart';
import 'package:multicall_mobile/widget/call_estimate_bottom_sheet.dart';
import 'package:multicall_mobile/widget/clickable_row_with_icon.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_calendar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/custom_time_picker.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleDialInScreen extends StatefulWidget {
  static const routeName = '/schedule_dial_in_screen';

  final int currentIndex;

  const ScheduleDialInScreen({super.key, this.currentIndex = 0});

  @override
  State<ScheduleDialInScreen> createState() => _ScheduleDialInScreenState();
}

class _ScheduleDialInScreenState extends State<ScheduleDialInScreen> {
  bool isChecked = false;
  bool isEditMode = false;
  bool isSwitched = false;

  late DateTime updatedDate;
  late TimeOfDay updatedTime;
  late DateTime updatedEndDateTime;
  late TimeOfDay updatedEndTime;
  String combinedDateTime = "";

  late ScheduleDetail scheduleDetail;
  late List<ScheduleCallMembers> members;
  late DateTime scheduledDateTime;

  @override
  void initState() {
    var provider = Provider.of<CallsController>(context, listen: false);
    scheduleDetail =
        provider.mergedScheduleCalls[widget.currentIndex].scheduleDetail;
    members = provider.mergedScheduleCalls[widget.currentIndex].members;

    scheduledDateTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(scheduleDetail.scheduleDateTime);

    updatedDate = scheduledDateTime;
    updatedTime = TimeOfDay.fromDateTime(scheduledDateTime);
    updatedEndDateTime =
        updatedDate.add(Duration(minutes: scheduleDetail.confDuration));
    updatedEndTime = TimeOfDay.fromDateTime(updatedEndDateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CallsController>(
      builder: (context, provider, child) {
        final selectedProfile =
            Provider.of<ProfileController>(context, listen: false)
                .profiles
                .firstWhere((element) =>
                    element.profileRefNo == scheduleDetail.profileRefNum);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: CustomAppBar(
            leading: Text(
              scheduleDetail.dialinFlag == 1
                  ? 'Scheduled Dial-In'
                  : 'Scheduled Dial-Out',
            ),
            trailing: (isEditMode ||
                    (scheduledDateTime.difference(DateTime.now()).inMinutes <=
                        5))
                ? const SizedBox.shrink()
                : DualToneIcon(
                    margin: 0,
                    press: () {
                      setState(() {
                        isEditMode = true;
                      });
                    },
                    iconSrc: PhosphorIconsDuotone.pencilSimpleLine,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 16,
                    padding: const Padding(
                      padding: EdgeInsets.all(6),
                    ),
                  ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    height: size.height - math.max(size.height * 0.27, 200),
                    width: size.width,
                    verticalPadding: 16,
                    horizontalPadding: 16,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GlobalText(
                                text: scheduleDetail.chairpersonName,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(222, 246, 255, 1),
                            ),
                            child: AbsorbPointer(
                              absorbing: !isEditMode,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double maxWidth = constraints.maxWidth;

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            showCalendarDialog(context);
                                          },
                                          child: buildInfoColumn(
                                            'Call Date',
                                            DateFormat("dd-MM-yyyy")
                                                .format(updatedDate),
                                            maxWidth,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: VerticalDashedDivider(),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            showTimeDialog(context);
                                          },
                                          child: buildInfoColumn(
                                            'Call Start Time',
                                            '${updatedTime.hourOfPeriod.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')} ${updatedTime.period == DayPeriod.am ? "AM" : "PM"}',
                                            maxWidth,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: VerticalDashedDivider(),
                                      ),
                                      Flexible(
                                        child: buildInfoColumn(
                                          'Call End Time',
                                          '${updatedEndTime.hourOfPeriod.toString().padLeft(2, '0')}:${updatedEndTime.minute.toString().padLeft(2, '0')} ${updatedEndTime.period == DayPeriod.am ? "AM" : "PM"}',
                                          maxWidth,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          scheduleDetail.dialinFlag == 1
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Column(
                                        children: [
                                          const GlobalText(
                                            text: "Host",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            textAlign: TextAlign.center,
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.zero,
                                          ),
                                          Row(
                                            children: [
                                              GlobalText(
                                                text:
                                                    "Dial ${scheduleDetail.dialinDID}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromRGBO(
                                                    110, 122, 132, 1),
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.zero,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              GlobalText(
                                                text:
                                                    "Pin ${selectedProfile.chairpersonPin}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromRGBO(
                                                    110, 122, 132, 1),
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.zero,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const HorizontalDivider(
                                      color: Color.fromRGBO(221, 225, 228, 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const GlobalText(
                                                text: "Participants",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.zero,
                                              ),
                                              Row(
                                                children: [
                                                  DualToneIcon(
                                                    margin: 8,
                                                    iconSrc:
                                                        PhosphorIconsDuotone
                                                            .copySimple,
                                                    duotoneSecondaryColor:
                                                        const Color.fromRGBO(
                                                            0, 134, 181, 1),
                                                    color: Colors.black,
                                                    size: 12,
                                                    padding: const Padding(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                    ),
                                                    press: () async {
                                                      String message =
                                                          "${PreferenceHelper.get(PrefUtils.userName)} has scheduled a MultiCall on ${DateFormat("dd-MM-yyyy").format(updatedDate)} at ${updatedTime.hourOfPeriod.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')} ${updatedTime.period == DayPeriod.am ? "AM" : "PM"}. Dial ${scheduleDetail.dialinDID} followed by pin ${selectedProfile.participantPin} to join the conference.";

                                                      await Clipboard.setData(
                                                          ClipboardData(
                                                              text: message));
                                                      showToast(
                                                          "Message copied!");
                                                    },
                                                  ),
                                                  DualToneIcon(
                                                    iconSrc:
                                                        PhosphorIconsDuotone
                                                            .shareFat,
                                                    duotoneSecondaryColor:
                                                        const Color.fromRGBO(
                                                            0, 134, 181, 1),
                                                    color: Colors.black,
                                                    size: 12,
                                                    padding: const Padding(
                                                      padding:
                                                          EdgeInsets.all(6),
                                                    ),
                                                    margin: 0,
                                                    press: () {
                                                      String message =
                                                          "${PreferenceHelper.get(PrefUtils.userName)} has scheduled a MultiCall on ${DateFormat("dd-MM-yyyy").format(updatedDate)} at ${updatedTime.hourOfPeriod.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')} ${updatedTime.period == DayPeriod.am ? "AM" : "PM"}. Dial ${scheduleDetail.dialinDID} followed by pin ${selectedProfile.participantPin} to join the conference.";
                                                      Share.share(message);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GlobalText(
                                                text:
                                                    "Dial ${scheduleDetail.dialinDID}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromRGBO(
                                                    110, 122, 132, 1),
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.zero,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              GlobalText(
                                                text:
                                                    "Pin ${selectedProfile.participantPin}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromRGBO(
                                                    110, 122, 132, 1),
                                                textAlign: TextAlign.center,
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.zero,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const HorizontalDivider(
                                      color: Color.fromRGBO(221, 225, 228, 1),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              scheduleDetail.chairpersonPhone,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            const Text(
                                              "(Call-Me-On)",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    111, 122, 131, 1),
                                              ),
                                            ),
                                          ],
                                        )),
                                    const HorizontalDivider(
                                      color: Color.fromRGBO(221, 225, 228, 1),
                                    ),
                                  ],
                                ),
                          AbsorbPointer(
                            absorbing: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const GlobalText(
                                  text: "Add to Calender",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  textAlign: TextAlign.center,
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.zero,
                                ),
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  activeColor: Colors.green,
                                )
                              ],
                            ),
                          ),
                          const HorizontalDivider(
                            color: Color.fromRGBO(221, 225, 228, 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: GlobalText(
                              text:
                                  "Repeat - ${RepeatModel.getDefaultRepeats().firstWhere((element) => element.repeat == scheduleDetail.repeatType).repeatText}",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const HorizontalDivider(
                            color: Color.fromRGBO(221, 225, 228, 1),
                          ),
                          scheduleDetail.dialinFlag == 1
                              ? const SizedBox.shrink()
                              : AbsorbPointer(
                                  absorbing: true,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const GlobalText(
                                              text: "Auto-Initiate Call",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              textAlign: TextAlign.center,
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.zero,
                                            ),
                                            Switch(
                                              trackOutlineColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              activeTrackColor:
                                                  const Color(0XFF62B414),
                                              inactiveThumbColor: Colors.white,
                                              inactiveTrackColor:
                                                  const Color(0XFFDDE1E4),
                                              thumbColor: MaterialStateColor
                                                  .resolveWith(
                                                      (states) => Colors.white),
                                              trackOutlineWidth:
                                                  MaterialStateProperty.all(
                                                      0.0),
                                              value:
                                                  scheduleDetail.typeOfStart ==
                                                      1,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched = value;
                                                });
                                              },
                                              activeColor: const Color.fromRGBO(
                                                  98, 180, 20, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const HorizontalDivider(
                                        color: Color.fromRGBO(221, 225, 228, 1),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(
                            height: 16,
                          ),
                          ClickableRowWithIcon(
                            clickFunction: () {
                              if (isEditMode) {
                                openAddMemberBottomSheet();
                              }
                            },
                            titleWeight: FontWeight.w600,
                            title: 'Members-${members.length}',
                            rightDualToneIcon: isEditMode
                                ? PhosphorIconsDuotone.plusCircle
                                : null,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                              text:
                                                  member.name.characters.first,
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
                                                text: member.name,
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
                                                text: member.phone,
                                                textColor:
                                                    const Color(0XFF6E7A84),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      isEditMode
                                          ? customIconButton(
                                              iconData:
                                                  PhosphorIcons.caretRight(),
                                              onPressed: () {
                                                showMemberOptionBottomSheet(
                                                  member,
                                                  provider,
                                                  members.length,
                                                  scheduleDetail.scheduleRefNo,
                                                );
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  members.length - 1 != index
                                      ? const Divider(
                                          color: Color(0XFFCDD3D7),
                                          height: 1,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              );
                            },
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
                  padding: const EdgeInsets.fromLTRB(24.0, 16, 24.0, 24.0),
                  child: SizedBox(
                    height: 40,
                    child: isEditMode
                        ? Row(
                            children: [
                              Expanded(
                                child: MultiCallOutLineButtonWidget(
                                  text: "Cancel",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  textColor:
                                      const Color.fromRGBO(255, 102, 102, 1),
                                  borderRadius: 8,
                                  backgroundColor:
                                      const Color.fromRGBO(255, 224, 224, 1),
                                  borderColor:
                                      const Color.fromRGBO(255, 224, 224, 1),
                                  onTap: () {
                                    setState(() {
                                      isEditMode = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: MultiCallOutLineButtonWidget(
                                  text: "Reschedule",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  textColor: Colors.white,
                                  borderRadius: 8,
                                  backgroundColor:
                                      const Color.fromRGBO(98, 180, 20, 1),
                                  borderColor:
                                      const Color.fromRGBO(98, 180, 20, 1),
                                  onTap: () {
                                    MultipleClickHandler.checkClick(
                                      key: 'rescheduleButtonClick',
                                      onClick: () async {
                                        final defaultProfile =
                                            provider.selectedProfile;

                                        final filteredCallMeOnList =
                                            Provider.of<CallMeOnController>(
                                                    context,
                                                    listen: false)
                                                .filteredCallMeOnList;

                                        /// get profile member allow size
                                        var profileSize =
                                            defaultProfile?.profileSize == 0
                                                ? 4
                                                : defaultProfile?.profileSize ??
                                                    4;

                                        if (members.length > profileSize) {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MaximumMemberAlertBottomSheet(
                                                onTapSeePlan: () {
                                                  // GOTO PLAN SCREEN
                                                  debugPrint(
                                                      "On Tap See Plans");
                                                },
                                              );
                                            },
                                          );
                                          return;
                                        }

                                        if (defaultProfile?.accountType ==
                                            AppConstants.retailPrepaid) {
                                          RequestScheduleEstimateSuccess?
                                              response;
                                          provider.scheduleEstimation(
                                            profileRefNumber:
                                                defaultProfile?.profileRefNo ??
                                                    0,
                                            confDuration: provider
                                                .getConferenceDuration(),
                                            totalNumberOfMessages:
                                                (members.length / 2).ceil(),
                                            chairPersonPhoneNumber:
                                                filteredCallMeOnList[provider
                                                        .getSelectedCallMeOn]
                                                    .callMeOn,
                                            dialType: provider.dialInFlag,
                                            otherFeatures: -1,
                                            typeOfStart:
                                                provider.getTypeOfStart(),
                                            totalMembers: members.length,
                                          );

                                          List<List<MemberEstimation>> pairs =
                                              [];

                                          // Group members into pairs
                                          for (int i = 0;
                                              i < members.length;
                                              i += 2) {
                                            if (i + 1 < members.length) {
                                              var temp1 = MemberEstimation(
                                                memberNumber: members[i].phone,
                                                callType:
                                                    provider.getCallType(),
                                              );
                                              var temp2 = MemberEstimation(
                                                memberNumber:
                                                    members[i + 1].phone,
                                                callType:
                                                    provider.getCallType(),
                                              );

                                              pairs.add([temp1, temp2]);
                                            } else {
                                              var temp = MemberEstimation(
                                                memberNumber: members[i].phone,
                                                callType:
                                                    provider.getCallType(),
                                              );
                                              pairs.add([temp]);
                                            }
                                          }

                                          // Simulate API calls for each pair
                                          for (int i = 0;
                                              i < pairs.length;
                                              i++) {
                                            List<MemberEstimation> pair =
                                                pairs[i];
                                            // Perform API call with pair
                                            if (i != pairs.length - 1) {
                                              provider
                                                  .scheduleEstimationMembers(
                                                profileRefNumber: defaultProfile
                                                        ?.profileRefNo ??
                                                    0,
                                                members: pair,
                                              );
                                            } else {
                                              response = await provider
                                                  .scheduleEstimationMembers(
                                                profileRefNumber: defaultProfile
                                                        ?.profileRefNo ??
                                                    0,
                                                members: pair,
                                              ) as RequestScheduleEstimateSuccess;
                                              debugPrint("Estimation:" +
                                                  response.estimateAmount
                                                      .toString());
                                            }
                                          }
                                          if (mounted) {
                                            // Show the bottom sheet and wait for the user's response
                                            bool continueExecution =
                                                await showCallEstimateBottomSheet(
                                              context,
                                              members.length.toString(),
                                              provider
                                                  .getConferenceDuration()
                                                  .toString(),
                                              (response?.estimateAmount == null
                                                      ? 0
                                                      : response!
                                                              .estimateAmount /
                                                          100)
                                                  .toString(),
                                              callType: "Reschedule",
                                            );

                                            // If the user chooses not to continue, return early
                                            if (!continueExecution) {
                                              return;
                                            }
                                          }
                                        }

                                        final combinedDateTime = DateTime(
                                          updatedDate.year,
                                          updatedDate.month,
                                          updatedDate.day,
                                          updatedTime.hour,
                                          updatedTime.minute,
                                        );
                                        final updatedScheduleStartDateTime =
                                            DateFormat('yyyy-MM-dd HH:mm')
                                                .format(combinedDateTime);

                                        provider.rescheduleCall(
                                          profileRefNumber:
                                              scheduleDetail.profileRefNum,
                                          scheduleRefNumber:
                                              scheduleDetail.scheduleRefNo,
                                          scheduleStartDateTime:
                                              updatedScheduleStartDateTime,
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              if (scheduledDateTime
                                  .isAfter(DateTime.now())) ...[
                                if (scheduledDateTime
                                        .difference(DateTime.now())
                                        .inMinutes <=
                                    5) ...[
                                  // Show both Delete and Start Call buttons
                                  _buildDeleteButton(
                                    provider: provider,
                                    textColor:
                                        const Color.fromRGBO(255, 102, 102, 1),
                                    backgroundColor:
                                        const Color.fromRGBO(255, 224, 224, 1),
                                    borderColor:
                                        const Color.fromRGBO(255, 224, 224, 1),
                                  ),
                                  const SizedBox(width: 16),
                                  _buildStartButton(
                                    defaultProfile: selectedProfile,
                                    context: context,
                                    provider: provider,
                                  ),
                                ] else ...[
                                  // Show only Delete button
                                  _buildDeleteButton(
                                    provider: provider,
                                    textColor: Colors.white,
                                    backgroundColor: const Color(0xFFFF6666),
                                    borderColor: const Color(0xFFFF6666),
                                    deleteButtonText: "Delete Call",
                                  ),
                                ]
                              ] else ...[
                                // Show only Start Call button
                                _buildStartButton(
                                  defaultProfile: selectedProfile,
                                  context: context,
                                  provider: provider,
                                ),
                              ],
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

  Widget _buildDeleteButton({
    required CallsController provider,
    required Color textColor,
    required Color backgroundColor,
    required Color borderColor,
    String? deleteButtonText,
  }) {
    return Expanded(
      child: MultiCallOutLineButtonWidget(
        text: deleteButtonText ?? "Delete",
        fontSize: 16,
        fontWeight: FontWeight.w700,
        borderRadius: 8,
        textColor: textColor,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        onTap: () {
          if (scheduleDetail.recurrentID == 0) {
            /// delete only this call
            deleteCall(provider, scheduleDetail.recurrentID);
            return;
          }

          /// show popup to confirm delete all or this schedule call
          showDeleteCallConfirmationBottomSheet(
            provider: provider,
          );
        },
      ),
    );
  }

  void deleteCall(CallsController provider, int recurrentID) {
    provider.deleteSchedule(
      profileRefNumber: scheduleDetail.profileRefNum,
      scheduleRefNumber: scheduleDetail.scheduleRefNo,
      recurrentId: recurrentID,
    );
  }

  Widget _buildStartButton({
    required Profile? defaultProfile,
    required BuildContext context,
    required CallsController provider,
  }) {
    return Expanded(
      child: MultiCallOutLineButtonWidget(
        text: "Start Call",
        fontSize: 16,
        fontWeight: FontWeight.w700,
        textColor: Colors.white,
        borderRadius: 8,
        backgroundColor: const Color.fromRGBO(98, 180, 20, 1),
        borderColor: const Color.fromRGBO(98, 180, 20, 1),
        onTap: () {
          /// get profile member allow size
          var profileSize = defaultProfile?.profileSize == 0
              ? 4
              : defaultProfile?.profileSize ?? 4;

          if (members.length > profileSize) {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return MaximumMemberAlertBottomSheet(
                  onTapSeePlan: () {},
                );
              },
            );
          } else {
            if (scheduleDetail.dialinFlag == 1) {
              final phoneNumberString =
                  'tel:${scheduleDetail.dialinDID},${defaultProfile?.chairpersonPin}%23';
              launchURL(phoneNumberString);
            } else {
              provider.startScheduleCall(
                profileRefNumber: scheduleDetail.profileRefNum,
                scheduleRefNumber: scheduleDetail.scheduleRefNo,
              );
            }
          }
        },
      ),
    );
  }

  TimeOfDay addMinutesToTimeOfDay(TimeOfDay time, int minutesToAdd) {
    final int totalMinutes = time.hour * 60 + time.minute + minutesToAdd;
    final int newHour = (totalMinutes ~/ 60) % 24;
    final int newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
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

  Widget buildInfoColumn(String title, String value, double maxWidth) {
    // Calculate the font size based on the available width
    double titleFontSize = maxWidth / 30;
    double valueFontSize = maxWidth / 25;

    return Column(
      children: [
        UnderlineText(
          text: title,
          underlineColor: const Color.fromRGBO(0, 134, 181, 1),
          underlineHeight: 0.5,
          fontWeight: FontWeight.w700,
          fontSize: titleFontSize.clamp(
            10.0,
            12.0,
          ),
          // Ensure it stays within a reasonable range
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        buildGlobalText(
          value,
          valueFontSize.clamp(12.0, 14.0),
          // Ensure it stays within a reasonable range
          FontWeight.w700,
          TextAlign.center,
          const EdgeInsets.only(bottom: 6),
        ),
      ],
    );
  }

  void showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: CustomCalendar(
            initialDate: updatedDate,
            onDateSelected: (date) {
              setState(() {
                updatedDate = date;
              });
            },
          ),
        );
      },
    );
  }

  void showTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: CustomTimePicker(
            initialTime: updatedTime,
            onSubmitDismiss: false,
            onTimeSelected: (time) {
              final now = TimeOfDay.now();
              final selectedTime = time;

              /// Check if the selected time is in the past
              if (selectedTime.hour < now.hour ||
                  (selectedTime.hour == now.hour &&
                      selectedTime.minute < now.minute)) {
                /// Show an error message or handle the restriction
                showToast("Please select future date and time.");
              } else {
                Navigator.pop(context);

                /// Proceed with the selected time
                setState(() {
                  updatedTime = selectedTime;
                  updatedEndTime = addMinutesToTimeOfDay(
                    updatedTime,
                    scheduleDetail.confDuration,
                  );
                });
              }
            },
          ),
        );
      },
    );
  }

  void openAddMemberBottomSheet() {
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
                          builder: (context) =>
                              const ContactScreen(isFromRescheduleScreen: true),
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
                          builder: (context) => const GroupListScreen(
                              isFromRescheduleScreen: true),
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
                              isFromRescheduleScreen: true),
                        ),
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

  void showMemberOptionBottomSheet(
    ScheduleCallMembers member,
    CallsController provider,
    int noOfMembers,
    int scheduleRefNo,
  ) {
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
                  text: member.name,
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
                      makePhoneCall(member.phone);
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
                    isClicked: () async {
                      /// API Calls for delete member from the list
                      if (noOfMembers > 1) {
                        /// change conferees header
                        provider.changeConfereesHeader(
                          profileRefNumber: scheduleDetail.profileRefNum,
                          scheduleRefNumber: scheduleDetail.scheduleRefNo,
                          totalNumberOfMessages: 1,
                          totalConfereeCount: 1,
                        );

                        /// call remove member API
                        var result = await provider.removeConfereeReschedule(
                          profileRefNumber: scheduleDetail.profileRefNum,
                          scheduleRefNumber: scheduleDetail.scheduleRefNo,
                          confereeEmail: member.email,
                          confereeName: member.name,
                          confereeNumber: member.phone,
                        ) as ResponseChangeConfereeList;

                        /// change conferees header
                        provider.changeConfereesHeader(
                          profileRefNumber: scheduleDetail.profileRefNum,
                          scheduleRefNumber: scheduleDetail.scheduleRefNo,
                          totalNumberOfMessages: 1,
                          totalConfereeCount: 1,
                        );

                        if (result.status) {
                          provider.removeMemberFromScheduleCall(
                              member, scheduleRefNo);
                        }
                      } else {
                        showToast(
                            "Scheduling the call requires adding at least one member.");
                      }

                      if (!context.mounted) {
                        return; // Check if the context is still valid
                      }

                      Navigator.pop(context);
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

  void showDeleteCallConfirmationBottomSheet({
    required CallsController provider,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                  const MultiCallTextWidget(
                    text: "Are you sure to delete this call?",
                    textColor: Color(0XFF101315),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
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
                      child: Row(
                        children: [
                          Expanded(
                            child: MultiCallOutLineButtonWidget(
                              text: "All calls",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor: const Color(0XFFFF6666),
                              borderColor: const Color(0XFFFF6666),
                              onTap: () {
                                /// delete all recurrent calls
                                deleteCall(
                                    provider, scheduleDetail.recurrentID);

                                /// close bottom sheet
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: MultiCallOutLineButtonWidget(
                              text: "Only this call",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor: const Color(0XFFFF6666),
                              borderColor: const Color(0XFFFF6666),
                              onTap: () {
                                /// delete only this call
                                deleteCall(provider, 0);

                                /// close bottom sheet
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
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
}

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.nameInitial,
    required this.title,
    required this.number,
  });

  final String nameInitial;
  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color(0XFFEDF0F2),
          ),
          child: Center(
            child: MultiCallTextWidget(
              text: nameInitial,
              textColor: const Color(0XFF101315),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        ContactInfo(
          title: title,
          number: number,
        ),
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    super.key,
    required this.title,
    required this.number,
  });

  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiCallTextWidget(
          text: title,
          textColor: const Color(0XFF101315),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(
          height: 2,
        ),
        MultiCallTextWidget(
          text: number,
          textColor: const Color(0XFF6E7A84),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

Widget buildGlobalTextRow(String title, String value, FontWeight fontWeight,
    double fontSize, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GlobalText(
        text: title,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
      GlobalText(
        text: value,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ],
  );
}
