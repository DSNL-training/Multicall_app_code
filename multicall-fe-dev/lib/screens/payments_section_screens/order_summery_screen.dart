import "package:flutter/material.dart";
import "package:multicall_mobile/providers/payment_provider.dart";
import "package:multicall_mobile/screens/payments_section_screens/payment_receipt_screen.dart";
import "package:multicall_mobile/utils/cc_avenue.dart";
import "package:multicall_mobile/widget/custom_app_bar.dart";
import "package:multicall_mobile/widget/custom_container.dart";
import "package:multicall_mobile/widget/dashed_divider.dart";
import "package:multicall_mobile/widget/text_button.dart";
import "package:provider/provider.dart";

class OrderSummery extends StatefulWidget {
  static const routeName = "/order-summery";

  const OrderSummery({super.key});

  @override
  State<OrderSummery> createState() => _OrderSummeryState();
}

class _OrderSummeryState extends State<OrderSummery> {
  String planTitle = "";
  String validity = "";
  double amount = 0.0;
  String addOnPlanTitle = "";
  String addOnValidity = "";
  double addOnAmount = 0;
  String displayAmount = "";
  String addOnDisplayAmount = "";

  double totalBeforeGST = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
      planTitle = (args as Map)["title"] ?? "";
      validity = (args)["validity"] ?? "";
      amount = (args)["price"] ?? "";
      displayAmount = (args)["displayAmount"] ?? "";
      addOnPlanTitle = (args)["addOnTitle"] ?? "";
      addOnValidity = (args)["addOnValidity"] ?? "";
      addOnAmount = (args)["addOnAmount"] ?? "";
      addOnDisplayAmount = (args)["addOnDisplayAmount"] ?? "";

      totalBeforeGST = (amount) + (addOnAmount);

      setState(() {});
    });
  }

  calculateCGST() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text("Order Summary"),
      ),
      body: Consumer<PaymentProvider>(
        builder:
            (BuildContext context, PaymentProvider provider, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    height: double.infinity,
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order ID: 24913",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (planTitle.isNotEmpty)
                            OrderSummeryRow(
                              title: "$planTitle | Validity $validity",
                              subTitle: "₹$amount",
                            ),
                          if (addOnPlanTitle.isNotEmpty)
                            OrderSummeryRow(
                              title:
                                  "$addOnPlanTitle | Validity $addOnValidity",
                              subTitle: "₹$addOnAmount",
                            ),
                          OrderSummeryRow(
                            title: "CGST(${provider.cgst}%)",
                            subTitle:
                                "₹${(provider.cgstAmount / 100).toStringAsFixed(2)}",
                          ),
                          OrderSummeryRow(
                            title: "SGST(${provider.sgst}%)",
                            subTitle:
                                "₹${(provider.sgstAmount / 100).toStringAsFixed(2)}",
                          ),
                          OrderSummeryRow(
                            title: "IGST(${provider.igst}%)",
                            subTitle:
                                "₹${(provider.igstAmount / 100).toStringAsFixed(2)}",
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const DashedDivider(
                            color: Color.fromRGBO(205, 211, 215, 1),
                            dashGap: 5,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          OrderSummeryRow(
                            title: "Total",
                            subTitle:
                                "₹${(provider.totalAmount / 100).toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButtonWithBG(
                    title: 'Proceed To Pay',
                    action: () {
                      CCAvenuePay.launchPaymentWebView(context);
                      // Navigator.pushNamed(
                      //   context,
                      //   PaymentReceiptScreen.routeName,
                      // );
                    },
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
        },
      ),
    );
  }
}

class OrderSummeryRow extends StatelessWidget {
  const OrderSummeryRow({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(110, 122, 132, 1),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            subTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
