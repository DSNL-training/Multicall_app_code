import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';

void showLogoutConfirmationBottomSheet(context) {
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
              padding: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 20,
                bottom: 12.0 + MediaQuery.of(context).padding.bottom,
              ),
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
                    text: "Are you sure you want to log out?",
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
                              text: "Logout",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor: const Color(0XFFFF6666),
                              borderColor: const Color(0XFFFF6666),
                              onTap: () {
                                logout(context);
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