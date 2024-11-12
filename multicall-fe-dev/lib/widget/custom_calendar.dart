import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  final DateTime? initialDate;
  final void Function(DateTime)? onDateSelected;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime now = DateTime.now();
  DateTime? _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate ?? now;
    _selectedDay = widget.initialDate;
  }

  String _formatYear(DateTime date) {
    return DateFormat('y').format(date);
  }

  String _formatWeekDay(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  String _formatMonthDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 134, 181, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDay != null
                        ? _formatYear(_selectedDay!)
                        : _formatYear(now),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _selectedDay != null
                        ? '${_formatWeekDay(_selectedDay!)}, ${_formatMonthDate(_selectedDay!)}'
                        : '${_formatWeekDay(now)}, ${_formatMonthDate(now)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            // height: 410,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TableCalendar(
                firstDay: now,
                lastDay: DateTime(now.year + 1, now.month, now.day),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  // if (widget.onDateSelected != null) {
                  //   widget.onDateSelected!(selectedDay);
                  // }
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: true,
                  rightChevronVisible: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey, // Different color for today
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  defaultTextStyle: TextStyle(color: Colors.black),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            color: Color.fromRGBO(205, 211, 215, 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButtonOnlyBorder(
                  title: 'Cancel',
                  borderColor: const Color.fromRGBO(205, 211, 215, 1),
                  action: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  textColor: const Color.fromRGBO(16, 19, 21, 1),
                  width: size.width * 0.38,
                  fontWeight: FontWeight.w700,
                ),
                TextButtonWithBG(
                  title: 'OK',
                  action: () {
                    if (_selectedDay != null && widget.onDateSelected != null) {
                      widget.onDateSelected!(_selectedDay!);
                    }
                    Navigator.of(context).pop();
                  },
                  padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  color: const Color.fromRGBO(0, 134, 181, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  iconColor: Colors.white,
                  width: size.width * 0.38,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
