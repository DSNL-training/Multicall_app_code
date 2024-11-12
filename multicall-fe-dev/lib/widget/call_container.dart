import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_calendar.dart';
import 'package:multicall_mobile/widget/custom_time_picker.dart';
import 'package:multicall_mobile/widget/dashed_line_widget.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:provider/provider.dart';

class UnderlineText extends StatelessWidget {
  final String text;
  final double underlineHeight;
  final Color underlineColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const UnderlineText({
    super.key,
    required this.text,
    this.underlineHeight = 2,
    this.underlineColor = Colors.black,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: underlineHeight / 2),
          child: GlobalText(
            text: text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: const Color.fromRGBO(0, 134, 181, 1),
            textAlign: textAlign,
            padding: EdgeInsets.zero,
          ),
        ),
        Container(
          color: underlineColor,
          height: underlineHeight,
          width: _calculateTextWidth(text, fontSize, fontWeight),
        ),
      ],
    );
  }

  double _calculateTextWidth(
      String text, double fontSize, FontWeight fontWeight) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }
}

class VerticalDashedDivider extends StatelessWidget {
  const VerticalDashedDivider({
    super.key,
    this.height = 90,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: height,
      child: CustomPaint(
        painter: DashedLinePainter(),
      ),
    );
  }
}

class CallContainer3 extends StatelessWidget {
  const CallContainer3({super.key});

  Widget buildGlobalText(String text, double fontSize, FontWeight fontWeight,
      TextAlign textAlign, EdgeInsets padding) {
    return GlobalText(
      text: text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: const Color(0xFF0086B5),
      textAlign: textAlign,
      padding: padding,
    );
  }

  void showCalendarDialog(BuildContext context, CallsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: CustomCalendar(
            initialDate: controller.selectedDate,
            onDateSelected: (date) {
              controller.updateDate(date);
            },
          ),
        );
      },
    );
  }

  void showTimeDialog(BuildContext context, CallsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: CustomTimePicker(
            initialTime: controller.selectedTime,
            onSubmitDismiss: false,
            onTimeSelected: (time) {
              final now = DateTime.now();
              final restrictionTime = now.add(const Duration(minutes: 15));
              final selectedDateTime = DateTime(
                now.year,
                now.month,
                now.day,
                time.hour,
                time.minute,
              );

              /// Check if the selected time is before the restricted time
              if (selectedDateTime.isBefore(restrictionTime)) {
                /// Show an error message or handle the restriction
                showToast("Please select a time at least 15 minutes from now.");
              } else {
                Navigator.pop(context);

                /// Proceed with the selected time
                controller.updateTime(time);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CallsController>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromRGBO(222, 246, 255, 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              showCalendarDialog(context, controller);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildGlobalText(
                  'Date',
                  14,
                  FontWeight.bold,
                  TextAlign.center,
                  EdgeInsets.zero,
                ),
                Container(
                  width: 32,
                  height: 1,
                  color: const Color(0xff0086B5), // Add underline
                ),
                const SizedBox(
                    height: 8), // Add space between the underline and date
                buildGlobalText(
                  intl.DateFormat('dd-MM-yyyy').format(controller.selectedDate),
                  18,
                  FontWeight.bold,
                  TextAlign.center,
                  const EdgeInsets.only(bottom: 2),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 1,
            height: 110,
            child: CustomPaint(
              painter: DashedLinePainter(),
            ),
          ),
          GestureDetector(
            onTap: () {
              showTimeDialog(context, controller);
            },
            child: Column(
              children: [
                buildGlobalText(
                  'Time',
                  14,
                  FontWeight.bold,
                  TextAlign.center,
                  EdgeInsets.zero,
                ),
                Container(
                  width: 32,
                  height: 1,
                  color: Colors.blue[800], // Add underline
                ),
                const SizedBox(
                    height: 8), // Add space between the underline and date
                buildGlobalText(
                  '${controller.selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${controller.selectedTime.minute.toString().padLeft(2, '0')} ${controller.selectedTime.period == DayPeriod.am ? "AM" : "PM"}',
                  18,
                  FontWeight.bold,
                  TextAlign.center,
                  const EdgeInsets.only(bottom: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
