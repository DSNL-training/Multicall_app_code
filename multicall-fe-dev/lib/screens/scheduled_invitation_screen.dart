import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response_invitation_sync.dart';
import 'package:multicall_mobile/utils/multiple_click_handler.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/call_container.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:provider/provider.dart';

class ScheduledInvitationScreen extends StatefulWidget {
  static const routeName = '/scheduled_invitation_screen';

  final int scheduleRefNo;

  const ScheduledInvitationScreen({super.key, this.scheduleRefNo = 0});

  @override
  State<ScheduledInvitationScreen> createState() =>
      _ScheduledInvitationScreenState();
}

class _ScheduledInvitationScreenState extends State<ScheduledInvitationScreen> {
  bool isChecked = false;
  bool isSwitched = false;

  late DateTime updatedDate;
  late TimeOfDay updatedTime;
  late DateTime updatedEndDateTime;
  late TimeOfDay updatedEndTime;
  String combinedDateTime = "";

  late ResponseInvitationSync scheduleDetail;
  late DateTime scheduledDateTime;

  @override
  void initState() {
    var provider = Provider.of<CallsController>(context, listen: false);
    scheduleDetail = findObjectByScheduleRefNo(
      provider.invitations as List<ResponseInvitationSync>,
      widget.scheduleRefNo.toString(),
    ) as ResponseInvitationSync;

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
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: CustomAppBar(
            leading: Text(
              scheduleDetail.callType == 1 ? 'Instant Call' : 'Scheduled Call',
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
                                text: scheduleDetail.confName,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          /// call details container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromRGBO(222, 246, 255, 1),
                            ),
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double maxWidth = constraints.maxWidth;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: buildInfoColumn(
                                        'Call Date',
                                        DateFormat("dd-MM-yyyy")
                                            .format(updatedDate),
                                        maxWidth,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: VerticalDashedDivider(),
                                    ),
                                    Flexible(
                                      child: buildInfoColumn(
                                        'Call Start Time',
                                        '${updatedTime.hourOfPeriod.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')} ${updatedTime.period == DayPeriod.am ? "AM" : "PM"}',
                                        maxWidth,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
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

                          /// Organizer container
                          scheduleDetail.chairpersonName.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            "Organizer",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            scheduleDetail.chairpersonName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const HorizontalDivider(
                                      color: Color.fromRGBO(221, 225, 228, 1),
                                    ),
                                  ],
                                ),

                          /// chairperson number (call-me-on) container
                          scheduleDetail.chairpersonNumber.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            scheduleDetail.chairpersonNumber,
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
                                      ),
                                    ),
                                    const HorizontalDivider(
                                      color: Color.fromRGBO(221, 225, 228, 1),
                                    ),
                                  ],
                                ),

                          /// add to calender container
                          Row(
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
                          const HorizontalDivider(
                            color: Color.fromRGBO(221, 225, 228, 1),
                          ),

                          /// repeat container
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (scheduleDetail.inviteStatus == 1 ||
                  scheduleDetail.inviteStatus == 0)
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16, 24.0, 24.0),
                    child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: MultiCallOutLineButtonWidget(
                                text: "Reject",
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
                                  MultipleClickHandler.checkClick(
                                      key: 'rejectButtonClick',
                                      onClick: () {
                                        /// Reject API call
                                        provider.responseToInvitation(
                                          scheduleRefNumber:
                                              scheduleDetail.scheduleRefNo,
                                          action: 0, // Reject
                                          recurrentId:
                                              scheduleDetail.recurrentId,
                                        );

                                        /// Refresh Upcoming Calls Data
                                        provider.refreshUpcomingCallsData();
                                      });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: MultiCallOutLineButtonWidget(
                                text: "Accept",
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
                                      key: 'acceptButtonClick',
                                      onClick: () {
                                        /// Accept the Call
                                        provider.responseToInvitation(
                                          scheduleRefNumber:
                                              scheduleDetail.scheduleRefNo,
                                          action: 1, // Accept
                                          recurrentId:
                                              scheduleDetail.recurrentId,
                                        );

                                        /// Refresh Upcoming Calls Data
                                        provider.refreshUpcomingCallsData();
                                      });
                                },
                              ),
                            )
                          ],
                        )),
                  ),
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
}
