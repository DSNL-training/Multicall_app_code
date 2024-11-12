import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/billing_screen.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/price_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  static const routeName = '/top-up-screen';

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _mobileFocus = FocusNode();

  String emailErrorText = "";
  Color emailPlaceHolderColor = const Color(0XFF4e5d69);
  Color emailFieldColor = const Color(0XffCDD7D7);
  int profileRefNum = 0;
  int planDuration = 0;
  String planName = "";
  int planId = 0;
  int jobId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        setState(() {
          profileRefNum = int.parse((args as Map)['profileRefNo']);
          planName = (args)['planName'];
          planDuration = (args)['planDuration'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text(
            "Top-Up",
          ),
        ),
        body: Consumer<AccountController>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PriceInputField(
                                size: size,
                                label: "Enter recharge value",
                                controller: _amountController,
                                focusNode: _mobileFocus,
                                hintText:
                                    "Enter the values in multiples of 100.",
                                hintTextColor:
                                    const Color.fromRGBO(44, 156, 196, 1),
                                onChanged: (v) {
                                  setState(() {});
                                },
                                onSubmit: (value) {
                                  // FocusScope.of(context)
                                  //     .requestFocus(_emailFocus);
                                },
                                errorText: isMultipleOf100(_amountController
                                                .text ==
                                            ""
                                        ? 0
                                        : int.parse(
                                            _amountController.text.toString()))
                                    ? ""
                                    : "Entered value should be multiples of 100.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButtonWithBG(
                    title: 'Proceed',
                    action: () async {
                      Provider.of<PaymentProvider>(context, listen: false)
                          .addPlanDetails(
                        planId,
                        planDuration.toString(),
                        planName,
                        _amountController.text == ""
                            ? 0
                            : double.parse(
                                _amountController.text.toString(),
                              ),
                        jobId,
                      );
                      final response =
                          await provider.requestTopUpPlan(profileRefNum);
                      if (response.status) {
                        if (mounted) {
                          Navigator.of(context).pushNamed(
                            BillingScreen.routeName,
                            arguments: {
                              'price': _amountController.text == ""
                                  ? 0
                                  : int.parse(
                                        _amountController.text.toString(),
                                      ) *
                                      100,
                              "isUnlimitedCallingPlan": true,
                              "title": "Top-Up",
                              "duration": "",
                              "displayAmount":
                                  "₹ ${_amountController.text.toString()}",
                              "addOnAmount": 0
                            },
                          );
                        }
                      } else {
                        showToast("Something went wrong");
                      }
                    },
                    isDisabled: !isMultipleOf100(_amountController.text == ""
                            ? 0
                            : int.parse(_amountController.text.toString())) ||
                        _amountController.text.isEmpty,
                    color: const Color.fromRGBO(98, 180, 20, 1),
                    textColor: Colors.white,
                    fontSize: 16,
                    iconColor: Colors.white,
                    width: size.width,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  bool isMultipleOf100(int number) {
    return number % 100 == 0;
  }
}
