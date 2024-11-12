import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/add_on_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/billing_screen.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/screens/payments_section_screens/enterprise_plans_screen.dart';
import 'package:multicall_mobile/widget/plan_details_card.dart';
import 'package:multicall_mobile/widget/tab_item.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});
  static const routeName = '/choose-plan-screen';

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RequestProfileBasePlanDetailsSuccess? profileBasePlanDetails;
  int accountId = 0;
  int profileRefNum = 0;
  int basePlanId = 0;
  bool isLoading = true;
  List<RequestProfileBasePlanDetailsSuccess> plans = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      accountId = (args as Map)["accountId"] ?? 0;
      profileRefNum = (args)["profileRefNum"] ?? 0;
      basePlanId = (args)["basePlanId"] ?? 0;
      getPlans();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getPlans() async {
    AccountController accountController = Provider.of<AccountController>(
      context,
      listen: false,
    );
    profileBasePlanDetails = await accountController.getProfileBasePlanDetails(
      accountId,
      profileRefNum,
      basePlanId,
    );
    if (profileBasePlanDetails?.basePlanID != -1) {
      plans.add(profileBasePlanDetails as RequestProfileBasePlanDetailsSuccess);
      await getRemainingPlans(profileBasePlanDetails?.basePlanID ?? 0,
          profileBasePlanDetails?.jobID ?? 0, accountController);
    }

    // Sort the plans list by planPriority in ascending order
    plans.sort((a, b) => a.planPriority.compareTo(b.planPriority));

    // Notify the UI that the data is ready
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getRemainingPlans(
      int basePlanId, int jobId, AccountController accountController) async {
    if (basePlanId == -1) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    RequestProfileBasePlanDetailsSuccess planDetail =
        await accountController.ackProfileBasePlanDetails(
      accountId,
      profileRefNum,
      jobId,
    );

    // Check if the plan with the same basePlanID already exists in the list
    bool planExists =
        plans.any((plan) => plan.basePlanID == planDetail.basePlanID);

    if (!planExists) {
      plans.add(planDetail);
    }

    await getRemainingPlans(
      planDetail.basePlanID,
      planDetail.jobID,
      accountController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text("Choose Your Plan"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(98, 180, 20, 1),
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.white,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: const BoxDecoration(
                        color: Color.fromRGBO(0, 134, 181, 1),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      tabs: const [
                        TabItem(
                          title: 'Unlimited Calling Plans',
                        ),
                        TabItem(
                          title: 'Calling Plans',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      filterByTalkTime(plans, true).length,
                                  itemBuilder: (context, index) {
                                    final plan =
                                        filterByTalkTime(plans, true)[index];
                                    return Column(
                                      children: [
                                        PlanDetailsCard(
                                          title: plan.planName,
                                          buyAction: () {
                                            Provider.of<PaymentProvider>(
                                              context,
                                              listen: false,
                                            ).addPlanDetails(
                                              plan.basePlanID,
                                              plan.planDurationDisplay,
                                              plan.planName,
                                              double.parse(plan.paymentAmount
                                                  .toString()),
                                              plan.jobID,
                                            );
                                            Navigator.of(context).pushNamed(
                                              BillingScreen.routeName,
                                              arguments: {
                                                'price': plan.paymentAmount,
                                                "isUnlimitedCallingPlan": true,
                                                "title": plan.planName,
                                                "duration":
                                                    plan.planDurationDisplay,
                                                "displayAmount":
                                                    plan.paymentAmountDisplay,
                                                "amount": plan.paymentAmount,
                                                "addOnAmount": 0,
                                              },
                                            );
                                          },
                                          // buyAction: plan['buyAction'] as VoidCallback,
                                          callSize: plan.planSize.toString(),
                                          callType: plan.talkTimeDisplay,
                                          price: plan.paymentAmountDisplay,
                                          validity: plan.planDurationDisplay,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: ChoosePlanRedirectComponent(size: size),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    filterByTalkTime(plans, false).length,
                                itemBuilder: (context, index) {
                                  final plan =
                                      filterByTalkTime(plans, false)[index];
                                  return Column(
                                    children: [
                                      PlanDetailsCard(
                                        title: plan.planName,
                                        buyAction: () {
                                          Provider.of<PaymentProvider>(context,
                                                  listen: false)
                                              .addPlanDetails(
                                            plan.basePlanID,
                                            plan.planDurationDisplay,
                                            plan.planName,
                                            double.parse(
                                                plan.paymentAmount.toString()),
                                            plan.jobID,
                                          );
                                          Navigator.of(context).pushNamed(
                                            AddOnsScreen.routeName,
                                            arguments: {
                                              'isNavigatedFromProfileDetails':
                                                  false,
                                              'price': plan.paymentAmount,
                                              "isUnlimitedCallingPlan": false,
                                              "title": plan.planName,
                                              "duration":
                                                  plan.planDurationDisplay,
                                              "displayAmount":
                                                  plan.paymentAmountDisplay,
                                              "accountId": accountId,
                                              "profileRefNo": profileRefNum,
                                              "basePlanId": plan.basePlanID,
                                            },
                                          );
                                        },
                                        // buyAction: plan['buyAction'] as VoidCallback,
                                        callSize: plan.planSize.toString(),
                                        callType:
                                            "${plan.talkTimeDisplay} local minutes",
                                        price: plan.paymentAmountDisplay,
                                        validity: plan.planDurationDisplay,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: ChoosePlanRedirectComponent(size: size),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class ChoosePlanRedirectComponent extends StatelessWidget {
  const ChoosePlanRedirectComponent({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const GlobalText(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  textAlign: TextAlign.left,
                  text: "To know more about the plans",
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL("https://multicall.in/multicall-plans/");
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Click here',
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 134, 181, 1),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL("https://multicall.in/multicall-plans/");
                        },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const GlobalText(
                  alignment: Alignment.centerLeft,
                  textAlign: TextAlign.left,
                  padding: EdgeInsets.zero,
                  text: "For Enterprise Plans ",
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                      text: 'Fill out the form',
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 134, 181, 1),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            EnterprisePlansScreen.routeName,
                          );
                        },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/casual-life-cash-receipt.png',
            // 3d-casual-life-cash-receipt-and-coin.svg
            height: 72,
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

List<RequestProfileBasePlanDetailsSuccess> filterByTalkTime(
    List<RequestProfileBasePlanDetailsSuccess> plans, bool isUnlimited) {
  return plans.where((plan) {
    if (isUnlimited) {
      return plan.talkTimeDisplay == 'Unlimited';
    }
    return plan.talkTimeDisplay != 'Unlimited' &&
        plan.talkTimeDisplay.isNotEmpty;
  }).toList();
}
