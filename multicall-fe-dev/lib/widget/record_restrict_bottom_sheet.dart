import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/screens/payments_section_screens/choose_your_plan_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/profile_plan_details.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';

void showCRecordRestrictBottomSheet(context, Profile? profile) {
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
            child: Padding(
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
                    text: "This feature is available in our paid plans.",
                    textColor: Color(0XFF101315),
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "To explore our paid plans, ",
                      style: const TextStyle(
                        color: Color(0XFF101315),
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "click here",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Navigator.pushNamed(
                                context,
                                ProfilePlanDetailsScreen.routeName,
                                arguments: {
                                  "title": profile?.profileName,
                                  "profileRefNo": profile?.profileRefNo
                                },
                              );
                            },
                        ),
                      ],
                    ),
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
                              text: "Cancel",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              borderColor: const Color(0XFFDDE1E4),
                              textColor: const Color(0XFF101315),
                              borderRadius: 8,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: MultiCallOutLineButtonWidget(
                              text: "Paid plans",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor:
                                  const Color.fromRGBO(0, 134, 181, 1),
                              borderColor: const Color.fromRGBO(0, 134, 181, 1),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProfilePlanDetailsScreen.routeName,
                                  arguments: {
                                    "title": profile?.profileName,
                                    "profileRefNo": profile?.profileRefNo
                                  },
                                );
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
  );
}
