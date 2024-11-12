import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/screens/repeat_screen.dart';
import 'package:multicall_mobile/screens/select_duration_screen.dart';
import 'package:multicall_mobile/widget/bottom_sheet_option_with_icon.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class DialInMoreOption extends StatelessWidget {
  final DialTypeSelection dialType;

  const DialInMoreOption({super.key, required this.dialType});

  @override
  Widget build(BuildContext context) {
    return Consumer<CallsController>(
      builder: (context, provider, child) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 12.0 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BottomSheetOptionWithIcon(
                        iconSrc: PhosphorIconsDuotone.repeat,
                        title: "Repeat",
                        selectedText: RepeatModel.getDefaultRepeats()
                            .where((element) =>
                                element.repeat == provider.getRepeatType())
                            .first
                            .repeatText,
                        action: () {
                          Navigator.pushNamed(
                            context,
                            RepeatCallScreen.routeName,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const HorizontalDivider(),
                      const SizedBox(
                        height: 16,
                      ),
                      BottomSheetOptionWithIcon(
                        iconSrc: PhosphorIconsDuotone.timer,
                        title: "Duration",
                        selectedText: "${provider.getConferenceDuration()}min",
                        action: () {
                          Navigator.pushNamed(
                            context,
                            SelectDurationScreen.routeName,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const HorizontalDivider(),
                      const SizedBox(
                        height: 16,
                      ),
                      if (dialType == DialTypeSelection.dialOut)
                        Column(
                          children: [
                            BottomSheetOptionWithIcon(
                              iconSrc: PhosphorIconsDuotone.phoneOutgoing,
                              title: "Auto-Initiate Call",
                              isChecked: provider.getTypeOfStart() == 1,
                              isSwitchPresent: true,
                              action: () {
                                provider.setTypeOfStart(
                                    provider.getTypeOfStart() == 1 ? 2 : 1);
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const HorizontalDivider(),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      BottomSheetOptionWithIcon(
                        iconSrc: PhosphorIconsDuotone.calendarPlus,
                        title: "Add to Calendar",
                        action: () {
                          provider.setCalendarEvent(
                              provider.getCalendarStatus() == 0 ? 1 : 0);
                        },
                        isCheckboxPresent: true,
                        isChecked: provider.getCalendarStatus() == 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12 + MediaQuery.of(context).viewInsets.bottom,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
