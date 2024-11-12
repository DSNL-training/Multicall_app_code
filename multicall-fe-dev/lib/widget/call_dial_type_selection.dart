import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/screens/schedule_call_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_radio_button.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

enum DialTypeSelection { dialIn, dialOut, default1 }

class CallDialTypeSelection extends StatefulWidget {
  final bool? isFromCallHistory;
  final bool? isFromGroupDetails;

  const CallDialTypeSelection({
    super.key,
    this.isFromCallHistory = false,
    this.isFromGroupDetails = false,
    x,
  });

  @override
  State<CallDialTypeSelection> createState() => _CallDialTypeSelectionState();
}

class _CallDialTypeSelectionState extends State<CallDialTypeSelection> {
  DialTypeSelection _option = DialTypeSelection.default1;

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(
              bottom: 12 + MediaQuery.of(context).padding.bottom),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                height: 24,
              ),
              Text(
                "Select call dial type",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      minimumSize: MaterialStateProperty.all(
                        const Size(0, 0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _option = DialTypeSelection.dialIn;
                      });
                    },
                    child: ListTile(
                      title: const Text("Dial-In"),
                      leading: CustomRadio(
                        onChanged: (p0) {
                          setState(() {
                            _option = (p0 == 0)
                                ? DialTypeSelection.dialIn
                                : DialTypeSelection.dialOut;
                          });
                        },
                        value: 0,
                        groupValue: _option == DialTypeSelection.default1
                            ? -1
                            : _option == DialTypeSelection.dialIn
                                ? 0
                                : 1,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      minimumSize: MaterialStateProperty.all(
                        const Size(0, 0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _option = DialTypeSelection.dialOut;
                      });
                    },
                    child: ListTile(
                      title: const Text("Dial-Out"),
                      leading: CustomRadio(
                        onChanged: (p0) {
                          setState(() {
                            _option = (p0 == 0)
                                ? DialTypeSelection.dialIn
                                : DialTypeSelection.dialOut;
                          });
                        },
                        value: 1,
                        groupValue: _option == DialTypeSelection.default1
                            ? -1
                            : _option == DialTypeSelection.dialIn
                                ? 0
                                : 1,
                      ),
                    ),
                  ),
                ],
              ),
              _option == DialTypeSelection.dialIn ||
                      _option == DialTypeSelection.dialOut
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: TextButtonWithBG(
                        fontSize: 16,
                        title: "OK",
                        action: () {
                          if (_option == DialTypeSelection.default1) {
                            showToast("Please select call dial type.");
                            return;
                          }

                          /// Pop call dial type selection bottom sheet
                          Navigator.pop(context);

                          /// check is
                          /// from call history or not
                          /// from group details screen or not

                          if (!(widget.isFromCallHistory == true ||
                              widget.isFromGroupDetails == true)) {
                            /// Clear previous session
                            Provider.of<CallsController>(context, listen: false)
                                .clearMembers();
                          }

                          /// Push schedule call screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ScheduleCallScreen(dialType: _option)));
                        },
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromRGBO(0, 134, 181, 1),
                        textColor: Colors.white,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
