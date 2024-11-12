import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/screens/payments_section_screens/profile_plan_details.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/menu_options.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class PaymentChooseProfileScreen extends StatefulWidget {
  static const routeName = '/payment-choose-profile-screen';

  const PaymentChooseProfileScreen({super.key});
  @override
  State<PaymentChooseProfileScreen> createState() =>
      _PaymentChooseProfileScreenState();
}

class _PaymentChooseProfileScreenState
    extends State<PaymentChooseProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Row(
          children: [
            Text(
              "Payments",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24.0,
              ),
            )
          ],
        ),
      ),
      body: Consumer<ProfileController>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
                  child: CustomStyledContainer(
                    height: size.height - math.max(size.height * 0.275, 260),
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          Column(
                            children: provider.profiles
                                .asMap()
                                .entries
                                .where((entry) => entry.value.accountType == AppConstants.retailPrepaid)
                                .map((entry) {
                              int idx = entry.key;
                              String option = entry.value.profileName;
                              return MenuOptions(
                                itemName: option,
                                isLastItem: idx ==
                                    provider.profiles
                                            .asMap()
                                            .entries
                                            .where((entry) =>
                                                entry.value.accountType == AppConstants.retailPrepaid)
                                            .length -
                                        1,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ProfilePlanDetailsScreen.routeName,
                                    arguments: {
                                      "title": option,
                                      "profileRefNo": entry.value.profileRefNo
                                    },
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 16, 24, 30),
                  child: Column(
                    children: [
                      Text(
                        "Profiles help you segregate your spends between personal, work, social etc. You can select different plans, configure different email ID’s, mobiles numbers, and notifications for each of your profiles.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(110, 122, 132, 1),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
