import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/screens/payments_section_screens/order_summery_screen.dart';
import 'package:multicall_mobile/utils/cc_avenue.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

Future<Map<String, dynamic>> loadJsonData(String path) async {
  String jsonString = await rootBundle.loadString(path);

  return json.decode(jsonString);
}

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  static const routeName = '/billing-screen';

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  String? state;
  String? city;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _postalCodeFocus = FocusNode();
  final FocusNode _gstNumberFocus = FocusNode();

  List<String> states = [];
  Map<String, dynamic> cities = {};
  List<String> currentCities = [];

  String planTitle = "";
  String validity = "";
  int amount = 0;
  String addOnPlanTitle = "";
  String addOnValidity = "";
  int addOnAmount = 0;
  String displayAmount = "";
  String addOnDisplayAmount = "";
  String planStateCode = "0";

  double totalAmount = 0.0;
  double cgstValue = 0;
  double sgstValue = 0;
  double igstValue = 0;

  bool isLoading = false;

  bool isNavigatedFromProfileDetails = false;

  @override
  void initState() {
    super.initState();
    loadLocationData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      planTitle = (args as Map)["title"] ?? "";
      validity = (args)["duration"] ?? "";
      amount = (args)["price"] ?? "";
      addOnPlanTitle = (args)["addOnTitle"] ?? "";
      addOnValidity = (args)["addOnValidity"] ?? "";
      addOnAmount = (args)["addOnAmount"] ?? "";
      addOnDisplayAmount = (args)["addOnDisplayAmount"] ?? "";
      isNavigatedFromProfileDetails =
          (args)["isNavigatedFromProfileDetails"] ?? false;
      displayAmount = (args)["displayAmount"];
    });
  }

  Future<void> loadLocationData() async {
    final statesData = await loadJsonData('assets/location/states.json');
    final citiesData = await loadJsonData('assets/location/cities.json');
    setState(() {
      states = List<String>.from(statesData['states']);
      cities = citiesData;
    });
  }

  void resetCity() {
    cityController.clear();
  }

  void totalAmountCalculation() {
    totalAmount = (amount + addOnAmount) / 100;
    cgstValue = getPercentage(planStateCode == "33" ? 9 : 0, totalAmount);
    sgstValue = getPercentage(planStateCode == "33" ? 9 : 0, totalAmount);
    igstValue = getPercentage(planStateCode == "33" ? 0 : 9, totalAmount);
    totalAmount = totalAmount + cgstValue + sgstValue + igstValue;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text("Billing"),
        ),
        body: Consumer<PaymentProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          PlanDetails(
                            amount: displayAmount,
                            title: planTitle,
                            validity: validity,
                            addOnTitle: addOnPlanTitle,
                            addOnAmount: addOnDisplayAmount,
                            addOnValidity: addOnValidity,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Please complete all fields to proceed",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  NameInputField(
                                    size: size,
                                    label: "Enter your name",
                                    controller: _nameController,
                                    focusNode: _nameFocus,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    onSubmit: (d) {
                                      FocusScope.of(context)
                                          .requestFocus(_addressFocus);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  NameInputField(
                                    size: size,
                                    label: "Enter your address",
                                    controller: _addressController,
                                    focusNode: _addressFocus,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    onSubmit: (d) {
                                      FocusScope.of(context)
                                          .requestFocus(_postalCodeFocus);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  DropdownField(
                                    size: size,
                                    label: "Select your state",
                                    onChanged: (value) {
                                      setState(() {
                                        state = value;
                                        planStateCode =
                                            cities[value]["code"].toString();
                                        currentCities = [];
                                        currentCities = List<String>.from(
                                            cities[value]["cities"]);
                                        resetCity();
                                      });
                                      totalAmountCalculation();
                                    },
                                    items: states,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  DropdownField(
                                    size: size,
                                    label: "Select your city",
                                    onChanged: (value) {
                                      setState(() {
                                        city = value;
                                      });
                                    },
                                    items: currentCities,
                                    controller: cityController,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  PhoneNumberInputField(
                                    size: size,
                                    label: "Enter postal code",
                                    controller: _postalCodeController,
                                    focusNode: _postalCodeFocus,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                    onSubmit: (e) {
                                      FocusScope.of(context)
                                          .requestFocus(_gstNumberFocus);
                                    },
                                    errorText: '',
                                    maxLength: 6,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  NameInputField(
                                    size: size,
                                    label: "Enter GST number (optional)",
                                    controller: _gstNumberController,
                                    focusNode: _gstNumberFocus,
                                    onChanged: (v) {
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextButtonWithBG(
                      title: 'Continue',
                      isLoading: isLoading,
                      action: () async {
                        if (_postalCodeController.text.length != 6) {
                          showToast("Postal code should be of 6 digits");
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        provider.addBillingDetails(
                          _nameController.text,
                          _addressController.text,
                          cityController.text,
                          state ?? "",
                          "INDIA",
                          _postalCodeController.text,
                          _gstNumberController.text,
                          planStateCode,
                        );
                        CCAvenuePay.initiatePayment(context, {
                          "accountId": provider.accountId.toString(),
                          "registrationNumber": provider.regNum.toString(),
                          "profileReferenceNumber":
                              provider.profileRefNumber.toString(),
                        }).then((value) {
                          Navigator.pushNamed(
                            context,
                            OrderSummery.routeName,
                            arguments: {
                              'price': amount / 100,
                              "displayAmount": displayAmount,
                              "isUnlimitedCallingPlan": true,
                              "title": planTitle,
                              "duration": validity,
                              "addOnTitle": addOnPlanTitle,
                              "addOnValidity": addOnValidity,
                              "addOnAmount": addOnAmount / 100,
                              "addOnDisplayAmount": addOnDisplayAmount
                            },
                          );
                        }).whenComplete(() {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      color: const Color.fromRGBO(98, 180, 20, 1),
                      textColor: Colors.white,
                      fontSize: 16,
                      isDisabled: _nameController.text.isEmpty ||
                          _addressController.text.isEmpty ||
                          _postalCodeController.text.isEmpty ||
                          city == null ||
                          state == null,
                      iconColor: Colors.white,
                      width: size.width,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PlanDetails extends StatelessWidget {
  final String title;
  final String amount;
  final String validity;
  final String addOnTitle;
  final String addOnValidity;
  final String addOnAmount;

  const PlanDetails({
    super.key,
    required this.title,
    required this.validity,
    required this.amount,
    required this.addOnTitle,
    required this.addOnValidity,
    required this.addOnAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 16,
      ),
      child: Column(
        children: [
          if (title.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "$title ${validity.isEmpty ? "" : "| Validity: $validity"}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          if (title.isNotEmpty && addOnTitle.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: HorizontalDivider(
                color: Color.fromRGBO(126, 145, 157, 1),
              ),
            ),
          if (addOnTitle.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "$addOnTitle | Validity: $addOnValidity",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  addOnAmount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
