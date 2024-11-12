import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_calendar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/icon_with_border.dart';
import 'package:multicall_mobile/widget/row_option_selection.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class RepeatCallScreen extends StatefulWidget {
  static const routeName = '/repeat-call-screen';

  const RepeatCallScreen({super.key});

  @override
  State<RepeatCallScreen> createState() => _RepeatCallScreenState();
}

class _RepeatCallScreenState extends State<RepeatCallScreen> {
  RepeatModel selectedOption = RepeatModel.getDefaultRepeats().first;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedOption = RepeatModel.getDefaultRepeats()
              .where((element) =>
                  element.repeat ==
                  Provider.of<CallsController>(context, listen: false)
                      .getRepeatType())
              .firstOrNull ??
          RepeatModel.getDefaultRepeats().first;
      setState(() {});
    });
    super.initState();
  }

  void showCalendarDialog(BuildContext context, double width) {
    final provider = Provider.of<CallsController>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: CustomCalendar(
            initialDate: provider.repeatTillDate,
            onDateSelected: (date) {
              provider.setRepeatTillDate(date);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text(
          'Repeat',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        trailing: BorderTextButton(
          title: 'Done',
          action: () {
            Provider.of<CallsController>(context, listen: false)
                .setRepeatType(selectedOption.repeat);
            Navigator.pop(context);
          },
          borderColor: const Color.fromRGBO(98, 180, 20, 1),
          textColor: const Color.fromRGBO(98, 180, 20, 1),
        ),
      ),
      body: Consumer<CallsController>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomStyledContainer(
                  height: size.height * 0.80,
                  width: size.width,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Column(
                          children: RepeatModel.getDefaultRepeats()
                              .asMap()
                              .entries
                              .map((entry) {
                            int idx = entry.key;
                            String option = entry.value.repeatText;
                            return OptionSelector(
                              title: option,
                              isSelected:
                                  entry.value.repeat == selectedOption.repeat,
                              leftIconClick: () {},
                              isLeftIconReq: false,
                              clickFunction: () {
                                debugPrint("Option $option selected");
                                selectedOption = entry.value;
                                setState(() {});
                              },
                              isLastItem: idx ==
                                  RepeatModel.getDefaultRepeats().length - 1,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      selectedOption.repeatText == "Never"
                          ? const SizedBox()
                          : Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  width: size.width,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(237, 240, 242, 1),
                                  ),
                                  child: const Text(
                                    "Repeat Till",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                    16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GlobalText(
                                        text:
                                            "Date - ${DateFormat('dd-MM-yyyy').format(provider.repeatTillDate)}",
                                        padding: EdgeInsets.zero,
                                        fontSize: 16,
                                      ),
                                      IconWithBorder(
                                        icon:
                                            PhosphorIconsRegular.calendarBlank,
                                        onClick: () => {
                                          showCalendarDialog(
                                            context,
                                            size.width * 0.9,
                                          )
                                        },
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
