import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/add_on_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/choose_your_plan_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/payment_history_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/topup_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePlanDetailsScreen extends StatefulWidget {
  static const routeName = '/profile-plan-details-screen';

  const ProfilePlanDetailsScreen({super.key});

  @override
  State<ProfilePlanDetailsScreen> createState() =>
      _ProfilePlanDetailsScreenState();
}

class _ProfilePlanDetailsScreenState extends State<ProfilePlanDetailsScreen> {
  AccountController? accountController;
  int profileRefNum = 0;
  bool isProfileDataAvailable = true;
  bool isLoading = true;
  bool isLoadingExceeded = false;
  RequestAccountDetailsSuccess? accountInfo;
  RequestProfilePlanDetailsSuccess? profilePlanDetails;
  RequestProfileAddOnPlanDetailsSuccess? profileAddPlanDetails;
  Timer? loadingTimer;

  @override
  void initState() {
    super.initState();
    accountController = Provider.of<AccountController>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args == null) {
        if (mounted) {
          setState(() {
            isProfileDataAvailable = false;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          profileRefNum = (args as Map)['profileRefNo'];
        });
        startLoadingTimer();
        getAccountDetails();
      }
    });
  }

  void startLoadingTimer() {
    loadingTimer = Timer(const Duration(seconds: 3), () {
      if (isLoading && mounted) {
        setState(() {
          isLoadingExceeded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    loadingTimer?.cancel();
    super.dispose();
  }

  Future<void> getAccountDetails() async {
    accountInfo = await accountController?.getAccountDetails(profileRefNum);
    profilePlanDetails = await accountController?.getProfilePlanDetails(
      accountInfo?.accountID ?? 0,
      accountInfo?.profileReferenceNumber.toString() ?? "0",
    );
    if (mounted) {
      setState(() {
        isLoading = false;
        loadingTimer?.cancel();
      });
    }
  }

  Future<RequestCurrentPlanActiveStatusSuccess?> getPlanDetails(
      int reqType) async {
    RequestCurrentPlanActiveStatusSuccess? resopnse = await accountController
        ?.requestCurrentPlanActiveStatus(profileRefNum, reqType);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
    final String question = (args as Map)['title'] ?? 'Profile Plan Details';

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24.0,
          ),
        ),
      ),
      body: isLoading && !isLoadingExceeded
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(98, 180, 20, 1),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
                    child: CustomStyledContainer(
                      height: 168,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Active Plan: ${profilePlanDetails?.basePlanName ?? ""}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PlanDetailsPoint(
                                  title: "Balance",
                                  content:
                                      "₹ ${profilePlanDetails?.balanceInformation != null ? (double.tryParse(profilePlanDetails!.balanceInformation)! / 100).toStringAsFixed(2) : 0}",
                                ),
                                PlanDetailsPoint(
                                  title: "Validity",
                                  content: profilePlanDetails
                                          ?.validityDateInformation ??
                                      "NA",
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            PlanDetailsPoint(
                                title: "Add-ons",
                                content: profilePlanDetails == null
                                    ? "NA"
                                    : profilePlanDetails?.addOnPlanDurationCount
                                                .toString() ==
                                            "0"
                                        ? "NA"
                                        : profilePlanDetails!
                                            .addOnPlanDurationCount
                                            .toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
                    child: CustomStyledContainer(
                      height: 169,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Services",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 11),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: ServiceTile(
                                    clickFunction: () async {
                                      Provider.of<PaymentProvider>(context,
                                              listen: false)
                                          .addProfileDetails(
                                        accountInfo?.accountID ?? 0,
                                        profileRefNum,
                                        accountInfo
                                                ?.conferenceReferenceNumber ??
                                            0,
                                      );
                                      final response = await accountController
                                          ?.requestCurrentPlanActiveStatus(
                                              profileRefNum, 1);
                                      if (response != null && response.status) {
                                        if (mounted) {
                                          Navigator.pushNamed(context,
                                              ChoosePlanScreen.routeName,
                                              arguments: {
                                                "accountId": profilePlanDetails
                                                    ?.accountID,
                                                "profileRefNum": profileRefNum,
                                                "basePlanId": profilePlanDetails
                                                    ?.basePlanID,
                                              });
                                        }
                                      } else {
                                        showToast(response?.failReason ??
                                            "Failed to get the response");
                                      }
                                    },
                                    iconData: PhosphorIconsDuotone.creditCard,
                                    title: "Recharge",
                                  ),
                                ),
                                Flexible(
                                  child: ServiceTile(
                                    clickFunction: () async {
                                      Provider.of<PaymentProvider>(context,
                                              listen: false)
                                          .addProfileDetails(
                                        accountInfo?.accountID ?? 0,
                                        profileRefNum,
                                        accountInfo
                                                ?.conferenceReferenceNumber ??
                                            0,
                                      );
                                      final response = await accountController
                                          ?.requestCurrentPlanActiveStatus(
                                        profileRefNum,
                                        3,
                                      );
                                      if (response != null && response.status) {
                                        Navigator.pushNamed(
                                          context,
                                          TopUpScreen.routeName,
                                          arguments: {
                                            "profileRefNo":
                                                profileRefNum.toString(),
                                            "planName": profilePlanDetails
                                                    ?.basePlanName ??
                                                "",
                                            "planDuration": profilePlanDetails
                                                    ?.basePlanDurationInt ??
                                                "",
                                          },
                                        );
                                      } else {
                                        showToast(
                                          response?.failReason ??
                                              "Failed to get the response",
                                        );
                                      }
                                    },
                                    iconData: PhosphorIconsDuotone.currencyInr,
                                    title: "Top-Up",
                                  ),
                                ),
                                Flexible(
                                  child: ServiceTile(
                                    clickFunction: () async {
                                      final response = await accountController
                                          ?.requestCurrentPlanActiveStatus(
                                        profileRefNum,
                                        2,
                                      );
                                      if (response != null && response.status) {
                                        Navigator.pushNamed(
                                          context,
                                          AddOnsScreen.routeName,
                                          arguments: {
                                            'isNavigatedFromProfileDetails':
                                                true,
                                            'price': 0,
                                            "isUnlimitedCallingPlan": true,
                                            "title": "",
                                            "duration": "",
                                            "displayAmount": "",
                                            "accountId":
                                                accountInfo?.accountID ?? 0,
                                            "profileRefNo": accountInfo
                                                    ?.profileReferenceNumber ??
                                                0,
                                            "basePlanId": profilePlanDetails
                                                    ?.basePlanID ??
                                                0,
                                          },
                                        );
                                      } else {
                                        showToast(response?.failReason ??
                                            "Failed to get the response");
                                      }
                                    },
                                    iconData: PhosphorIconsDuotone.coins,
                                    title: "Add-ons",
                                  ),
                                ),
                                Flexible(
                                  child: ServiceTile(
                                    clickFunction: () {
                                      Navigator.pushNamed(
                                          context, PaymentHistory.routeName,
                                          arguments: {
                                            "profileRefNo":
                                                profileRefNum.toString(),
                                          });
                                    },
                                    iconData:
                                        PhosphorIconsDuotone.clockCountdown,
                                    title: "Payment history",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.iconData,
    required this.title,
    required this.clickFunction,
  });

  final PhosphorDuotoneIconData iconData;
  final String title;
  final VoidCallback clickFunction;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: clickFunction,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(222, 246, 255, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(6),
                ),
                border: Border.all(
                  width: 1,
                  color: const Color.fromRGBO(200, 235, 248, 1),
                ),
              ),
              child: PhosphorIcon(
                duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                iconData,
                size: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromRGBO(16, 19, 21, 1),
                fontSize: size.width > 310 ? 14 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanDetailsPoint extends StatelessWidget {
  const PlanDetailsPoint({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            alignment: Alignment.topLeft,
            text: title,
            textAlign: TextAlign.left,
            color: const Color.fromRGBO(110, 122, 132, 1),
            fontSize: 12,
            padding: EdgeInsets.zero,
          ),
          GlobalText(
            alignment: Alignment.topLeft,
            text: content,
            textAlign: TextAlign.left,
            color: const Color.fromRGBO(16, 19, 21, 1),
            fontSize: 14,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
