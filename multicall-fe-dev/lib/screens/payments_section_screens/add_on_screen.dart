import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/billing_screen.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

class AddOnsScreen extends StatefulWidget {
  const AddOnsScreen({super.key});

  static const routeName = '/add-ons-screen';

  @override
  State<AddOnsScreen> createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends State<AddOnsScreen> {
  bool navigatedFromProfileDetail = false;

  String planTitle = "";
  String validity = "";
  int amount = 0;
  String addOnPlan = "";
  String displayAmount = "";
  int accountId = 0;
  int profileRefNo = 0;
  int basePlanId = 0;
  bool isLoading = true;
  bool isLoadingExceeded = false;
  Timer? loadingTimer;
  List<RequestProfileAddOnPlanDetailsSuccess> addOnPlans = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map args = ModalRoute.of(context)?.settings.arguments as Map;
      final bool isNavigatedFromProfileDetails =
          args['isNavigatedFromProfileDetails'] as bool? ?? false;

      planTitle = (args['title']?.isNotEmpty ?? false) ? args['title'] : "";
      validity =
          (args['duration']?.isNotEmpty ?? false) ? args['duration'] : "";
      amount = args['price'];
      displayAmount = (args['displayAmount']?.isNotEmpty ?? false)
          ? args['displayAmount']
          : "";
      profileRefNo = (args['profileRefNo'] != null) ? args['profileRefNo'] : 0;
      accountId = (args['accountId'] != null) ? args['accountId'] : 0;
      basePlanId = (args['basePlanId'] != null) ? args['basePlanId'] : 0;
      setState(() {
        navigatedFromProfileDetail = isNavigatedFromProfileDetails;
      });
      getAddOnPlans();
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

  getAddOnPlans() async {
    AccountController accountController = Provider.of<AccountController>(
      context,
      listen: false,
    );
    RequestProfileAddOnPlanDetailsSuccess addOnPlan = await accountController
        .getProfileAddOnPlanDetails(accountId, profileRefNo, basePlanId);

    if (addOnPlan.addonPlanID != -1) {
      addOnPlans.add(addOnPlan);
      await getRemainingPlan(
          addOnPlan.addonPlanID, addOnPlan.jobID, accountController);
    }
  }

  Future<void> getRemainingPlan(
      int addonPlanID, int jobId, AccountController accountController) async {
    if (addonPlanID == -1) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }
    RequestProfileAddOnPlanDetailsSuccess planDetail =
        await accountController.ackResponseAddOnPlanDetails(
      accountId,
      profileRefNo,
      addonPlanID,
      jobId,
    );

    // Check if the plan with the same basePlanID already exists in the list
    bool planExists =
        addOnPlans.any((plan) => plan.addonPlanID == planDetail.addonPlanID);

    if (!planExists && planDetail.addonPlanID != -1) {
      addOnPlans.add(planDetail);
    }

    await getRemainingPlan(planDetail.addonPlanID, jobId, accountController);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text("Add-Ons"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(98, 180, 20, 1),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
              child: SizedBox(
                  height: size.height,
                  child: ListView.builder(
                      itemCount: addOnPlans.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            AddOnOption(
                              size: size,
                              toolTipText:
                                  "${addOnPlans[index].planName} | Price - ${addOnPlans[index].paymentAmountDisplay} | Validity - ${addOnPlans[index].planDurationDisplay}",
                              title: addOnPlans[index].planName,
                              price: addOnPlans[index].paymentAmountDisplay,
                              validity: addOnPlans[index].planDurationDisplay,
                              skipAction: () {
                                Navigator.of(context).pushNamed(
                                  BillingScreen.routeName,
                                  arguments: {
                                    "isUnlimitedCallingPlan": true,
                                    'price': amount,
                                    "title": planTitle,
                                    "duration": validity,
                                    "displayAmount": displayAmount,
                                    "amount": amount,
                                    "addOnAmount": 0
                                  },
                                );
                              },
                              addAction: () {
                                Provider.of<PaymentProvider>(
                                  context,
                                  listen: false,
                                ).addAddonPlanDetails(
                                  addOnPlans[index].addonPlanID,
                                  validity,
                                  addOnPlans[index].planName,
                                  addOnPlans[index].paymentAmountInPaise,
                                );
                                // addAddonPlanDetails
                                Navigator.of(context).pushNamed(
                                  BillingScreen.routeName,
                                  arguments: {
                                    "isUnlimitedCallingPlan": true,
                                    'price': amount,
                                    "title": planTitle,
                                    "duration": validity,
                                    "amount": amount,
                                    "isNavigatedFromProfileDetails": true,
                                    "addOnTitle": addOnPlans[index].planName,
                                    "addOnValidity":
                                        addOnPlans[index].planDurationDisplay,
                                    "addOnAmount":
                                        addOnPlans[index].paymentAmountInPaise,
                                    "addOnDisplayAmount":
                                        addOnPlans[index].paymentAmountDisplay,
                                    "displayAmount": displayAmount,
                                  },
                                );
                              },
                              isNavigatedFromProfileDetails:
                                  navigatedFromProfileDetail,
                            ),
                            const SizedBox(
                              height: 16,
                            )
                          ],
                        );
                      })
                  // ListView(
                  //   children: [

                  //   ],
                  // ),
                  ),
            ),
    );
  }
}

class AddOnOption extends StatelessWidget {
  const AddOnOption({
    super.key,
    required this.size,
    required this.title,
    required this.price,
    required this.validity,
    required this.addAction,
    required this.skipAction,
    required this.toolTipText,
    this.isNavigatedFromProfileDetails = true,
  });

  final Size size;
  final String title;
  final String price;
  final String validity;
  final VoidCallback addAction;
  final VoidCallback skipAction;
  final String toolTipText;

  final bool isNavigatedFromProfileDetails;

  @override
  Widget build(BuildContext context) {
    final _controller = SuperTooltipController();
    return CustomStyledContainer(
      height: 155,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(222, 246, 255, 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(200, 235, 248, 1),
                          ),
                        ),
                        child: const PhosphorIcon(
                          duotoneSecondaryColor: Color.fromRGBO(0, 134, 181, 1),
                          PhosphorIconsDuotone.globeStand,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                /// Subtract the width of the icon and padding from the available width
                                double iconSize = 20;
                                double padding = 4;
                                double availableWidth =
                                    constraints.maxWidth - iconSize - padding;

                                return Row(
                                  children: [
                                    /// The text portion
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: availableWidth),
                                      child: Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Lato",
                                        ),
                                      ),
                                    ),

                                    /// The icon with tooltip
                                    Padding(
                                      padding: EdgeInsets.only(left: padding),
                                      child: SuperTooltip(
                                        showBarrier: true,
                                        controller: _controller,
                                        backgroundColor:
                                            const Color(0xff2f2d2f),
                                        left: 30,
                                        right: 30,
                                        arrowTipDistance: 15.0,
                                        arrowBaseWidth: 10.0,
                                        arrowLength: 5.0,
                                        borderWidth: 2.0,
                                        constraints: const BoxConstraints(
                                          minHeight: 0.0,
                                          maxHeight: 100,
                                          minWidth: 0.0,
                                          maxWidth: 100,
                                        ),
                                        touchThroughAreaShape:
                                            ClipAreaShape.rectangle,
                                        touchThroughAreaCornerRadius: 30,
                                        barrierColor: const Color.fromARGB(
                                            26, 47, 45, 47),
                                        content: Text(
                                          toolTipText,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: const Icon(
                                          PhosphorIconsRegular.info,
                                          size: 18,
                                          weight: 400,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Text(
                              price,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Lato",
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isNavigatedFromProfileDetails)
                  InkWell(
                    onTap: skipAction,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Skip to payment",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 134, 181, 1),
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromRGBO(0, 134, 181, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextButtonWithBG(
              title: 'Add',
              action: addAction,
              color: const Color.fromRGBO(98, 180, 20, 1),
              textColor: Colors.white,
              fontSize: 16,
              // iconData: iconData,
              iconColor: Colors.white,
              width: size.width,
            ),
          ],
        ),
      ),
    );
  }
}
