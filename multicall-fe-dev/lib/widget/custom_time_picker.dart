import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final void Function(TimeOfDay)? onTimeSelected;
  final bool? onSubmitDismiss;

  const CustomTimePicker({
    super.key,
    this.initialTime,
    this.onTimeSelected,
    this.onSubmitDismiss = true,
  });

  @override
  CustomTimePickerState createState() => CustomTimePickerState();
}

class CustomTimePickerState extends State<CustomTimePicker> {
  String selectedDurationType = "hour";
  String selectedPeriod = "AM";
  int selectedHours = 1;
  int selectedMinutes = 0;

  @override
  void initState() {
    super.initState();
    final initialTime = widget.initialTime ?? TimeOfDay.now();
    selectedHours = initialTime.hourOfPeriod;
    selectedMinutes = initialTime.minute;
    selectedPeriod = initialTime.period == DayPeriod.am ? "AM" : "PM";
  }

  void selectNumber(String number) {
    setState(() {
      selectedDurationType = number;
    });
  }

  void selectPeriod(String period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 92,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 134, 181, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => selectNumber("hour"),
                  child: Text(
                    selectedHours.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      color: selectedDurationType == "hour"
                          ? Colors.white
                          : const Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ":",
                  style: TextStyle(
                    fontSize: 54,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => selectNumber("mins"),
                  child: Text(
                    selectedMinutes.toString().padLeft(2, '0'),
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 54,
                      fontWeight: FontWeight.w600,
                      color: selectedDurationType == "mins"
                          ? Colors.white
                          : const Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => selectPeriod("AM"),
                      child: Text(
                        "AM",
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          color: selectedPeriod == "AM"
                              ? Colors.white
                              : const Color.fromRGBO(255, 255, 255, 0.5),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectPeriod("PM"),
                      child: Text(
                        "PM",
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          color: selectedPeriod == "PM"
                              ? Colors.white
                              : const Color.fromRGBO(255, 255, 255, 0.5),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // For hours
              TimeScroll(
                onChange: (value) {
                  setState(() {
                    selectedHours = value;
                  });
                },
                childCount: 12, // Hours from 1 to 12
                selectedValue: selectedHours,
                isEnabled: selectedDurationType == "hour",
              ),
              const SizedBox(width: 100),
              // For minutes
              TimeScroll(
                onChange: (value) {
                  setState(() {
                    selectedMinutes = value;
                  });
                },
                childCount: 60, // Minutes from 0 to 59
                selectedValue: selectedMinutes,
                isEnabled: selectedDurationType == "mins",
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromRGBO(205, 211, 215, 1),
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
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
                    TimeOfDay timeOfDay = createTimeOfDay(
                        selectedPeriod, selectedHours, selectedMinutes);
                    if (widget.onTimeSelected != null) {
                      widget.onTimeSelected!(timeOfDay);
                    }
                    if (widget.onSubmitDismiss == true) {
                      Navigator.of(context).pop();
                    }
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

TimeOfDay createTimeOfDay(String period, int hours, int minutes) {
  int hour24 = hours;
  if (period.toUpperCase() == "PM" && hours != 12) {
    hour24 += 12;
  } else if (period.toUpperCase() == "AM" && hours == 12) {
    hour24 = 0;
  }
  return TimeOfDay(hour: hour24, minute: minutes);
}

class TimeScroll extends StatefulWidget {
  final void Function(int) onChange;
  final int
      childCount; // The number of items in the list (12 for hours, 60 for minutes)
  final int selectedValue;
  final bool isEnabled;

  const TimeScroll({
    super.key,
    required this.onChange,
    required this.childCount,
    required this.selectedValue,
    required this.isEnabled,
  });

  @override
  TimeScrollState createState() => TimeScrollState();
}

class TimeScrollState extends State<TimeScroll> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Set an initial large offset to simulate infinite scrolling
    int initialItem = widget.childCount * 1000 +
        (widget.childCount == 60
            ? widget.selectedValue
            : widget.selectedValue - 1);

    _scrollController = FixedExtentScrollController(
      initialItem: initialItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isEnabled ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !widget.isEnabled,
        child: CustomStyledContainer(
          height: 150,
          width: 50,
          child: Center(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SizedBox(
                height: 150.0,
                child: ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  physics: const FixedExtentScrollPhysics(
                    parent:
                        CustomScrollPhysics(), // Decrease the scroll velocity
                  ),
                  itemExtent: 70.0,
                  // Increase item extent for slower scrolling
                  diameterRatio: 2.0,
                  onSelectedItemChanged: (index) {
                    final actualIndex = index % widget.childCount;
                    widget.onChange(actualIndex +
                        (widget.childCount == 60
                            ? 0
                            : 1)); // Adjust for 1-based value for hours
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final actualIndex = index % widget.childCount;
                      final value = actualIndex +
                          (widget.childCount == 60
                              ? 0
                              : 1); // Adjust for 1-based value for hours
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          value.toString().padLeft(2, '0'),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 36,
                            color: value == widget.selectedValue
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: value == widget.selectedValue
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomScrollPhysics extends FixedExtentScrollPhysics {
  const CustomScrollPhysics({super.parent});

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 60.0; // reduce the minimum fling velocity

  @override
  double get maxFlingVelocity => 200.0; // reduce the maximum fling velocity
}
