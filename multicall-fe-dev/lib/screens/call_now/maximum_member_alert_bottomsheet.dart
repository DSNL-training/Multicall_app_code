import 'package:flutter/material.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:provider/provider.dart';

class MaximumMemberAlertBottomSheet extends StatelessWidget {
  const MaximumMemberAlertBottomSheet({
    super.key,
    required this.onTapSeePlan,
  });

  final Function onTapSeePlan;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            Column(
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
                  text:
                      "Sorry, You cannot call more than 4 members with the current plan.",
                  textColor: Color(0XFF101315),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const MultiCallTextWidget(
                  text: "See our paid plans to MultiCall more people.",
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
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: MultiCallOutLineButtonWidget(
                          text: "Later",
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
                      Consumer<HomeProvider>(
                        builder: (context, homeProvider, child) {
                          return Expanded(
                            child: MultiCallOutLineButtonWidget(
                              text: "See Plans",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor: const Color(0XFF0086B5),
                              borderColor: const Color(0XFF0086B5),
                              onTap: () {
                                Navigator.pop(context);
                                onTapSeePlan();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeScreen.routeName,
                                  (Route<dynamic> route) => false,
                                );
                                Future.delayed(
                                    const Duration(milliseconds: 330),
                                    () => homeProvider.navigateToPremium());
                              },
                            ),
                          );
                          // CustomBottomNavigationBar(
                          //   selectedIndex: homeProvider.selectedIndex,
                          //   onItemTapped: homeProvider.onItemTapped,
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
