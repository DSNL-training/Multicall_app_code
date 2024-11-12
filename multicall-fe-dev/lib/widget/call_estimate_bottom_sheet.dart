import 'package:flutter/material.dart';
import 'package:multicall_mobile/screens/instant_call_screen.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';

Future<bool> showCallEstimateBottomSheet(
  BuildContext context,
  String participants,
  String duration,
  String estimate, {
  String? callType,
}) async {
  return await showModalBottomSheet<bool>(
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                MultiCallTextWidget(
                                  text: "Estimate",
                                  textColor: Color(0XFF101315),
                                  fontSize: 14,
                                  textAlign: TextAlign.left,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Divider(
                              height: 1,
                              color: Color(0XFFDDE1E4),
                            ),
                            buildGlobalTextRow(
                              "No. of participants:",
                              participants,
                              FontWeight.w400,
                              14,
                              const Color.fromRGBO(110, 122, 132, 1),
                              const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                            ),
                            const Divider(
                              height: 1,
                              color: Color(0XFFDDE1E4),
                            ),
                            buildGlobalTextRow(
                              "Duration:",
                              duration,
                              FontWeight.w400,
                              14,
                              const Color.fromRGBO(110, 122, 132, 1),
                              const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                            ),
                            const Divider(
                              height: 1,
                              color: Color(0XFFDDE1E4),
                            ),
                            buildGlobalTextRow(
                              "Estimate:",
                              estimate,
                              FontWeight.w400,
                              14,
                              const Color.fromRGBO(110, 122, 132, 1),
                              const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                            ),
                            const Divider(
                              height: 1,
                              color: Color(0XFFDDE1E4),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      const MultiCallTextWidget(
                        text:
                            "This is just the estimate.\nActual call cost may vary.",
                        textColor: Color(0XFF101315),
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12,
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
                                  text: "Cancel",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  borderColor: const Color(0XFFDDE1E4),
                                  textColor: const Color(0XFF101315),
                                  borderRadius: 8,
                                  onTap: () {
                                    Navigator.pop(
                                        context, false); // return false
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: MultiCallOutLineButtonWidget(
                                  text: callType ?? "Schedule",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  textColor: Colors.white,
                                  borderRadius: 8,
                                  backgroundColor:
                                      const Color.fromRGBO(0, 134, 181, 1),
                                  borderColor:
                                      const Color.fromRGBO(0, 134, 181, 1),
                                  onTap: () async {
                                    Navigator.pop(context, true); // return true
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
              ),
            ],
          );
        },
      ) ??
      false; // Default to false if modal is dismissed without action
}
