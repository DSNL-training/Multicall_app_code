// ignore_for_file: non_constant_identifier_names
import "dart:async";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:multicall_mobile/controller/account_controller.dart";
import "package:multicall_mobile/models/response.dart";
import "package:multicall_mobile/widget/custom_app_bar.dart";
import "package:multicall_mobile/widget/custom_container.dart";
import "package:multicall_mobile/widget/text_widget.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

class PaymentHistory extends StatefulWidget {
  static const routeName = "/payment-history-screen";

  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  bool isLoading = true;
  AccountController? accountController;
  RequestProfilePaymentHistorySuccess? response;
  String profileRefNum = "0";
  bool isLoadingExceeded = false;
  Timer? loadingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountController = Provider.of<AccountController>(
        context,
        listen: false,
      );
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        profileRefNum = (args as Map)['profileRefNo'];
        getPaymentHistory();
      }
      startLoadingTimer();
    });
  }

  getPaymentHistory() async {
    response =
        await accountController?.getProfilePlansHistoryDetails(profileRefNum);
    isLoading = false;
    setState(() {});
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text("Payment History"),
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        height: size.height,
        child: isLoading && !isLoadingExceeded
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(98, 180, 20, 1),
                ),
              )
            : response?.paymentHistory == null ||
                    response!.paymentHistory.isEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: CustomStyledContainer(
                          height: size.height,
                          width: size.width,
                          child: const Center(
                            child: Text(
                              "No payment history available.",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 16.0 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "For invoice copy, write to us at ",
                            style: const TextStyle(
                                color: Color(0XFF6E7A84), fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "support@multicall.in",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: 'support@multicall.in',
                                        query:
                                            'subject=Invoice Request&body=Please provide the Order ID and Payment date.',
                                      );

                                      if (await canLaunchUrl(emailUri)) {
                                        await launchUrl(emailUri);
                                      } else {
                                        throw 'Could not launch $emailUri';
                                      }
                                    }

                                  // ..supportedDevices = {PointerDeviceKind.touch, PointerDeviceKind.mouse},

                                  ),
                              const TextSpan(
                                style: TextStyle(
                                  color: Color(0XFF6E7A84),
                                  fontSize: 12,
                                ),
                                text: " with Order ID and Payment date",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: CustomStyledContainer(
                          height: size.height,
                          width: size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: response!.paymentHistory
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int idx = entry.key;
                                return PaymentHistoryCard(
                                  amount: (entry.value["payment_amount"] == null
                                          ? 0
                                          : entry.value["payment_amount"] / 100)
                                      .toString(),
                                  date: entry.value["payment_date_time"]
                                      .toString(),
                                  orderid: entry.value["orderid"].toString(),
                                  isSuccess: entry.value["payment_status"] == 1,
                                  isLastItem: idx ==
                                      response!.paymentHistory.length - 1,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 16.0 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: "For invoice copy, write to us at ",
                            style: TextStyle(
                                color: Color(0XFF6E7A84), fontSize: 12),
                            children: [
                              TextSpan(
                                text: "support@multicall.in",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                style: TextStyle(
                                  color: Color(0XFF6E7A84),
                                  fontSize: 12,
                                ),
                                text: " with Order ID and Payment date",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class PaymentHistoryCard extends StatelessWidget {
  const PaymentHistoryCard({
    super.key,
    required this.orderid,
    required this.date,
    required this.amount,
    required this.isSuccess,
    required this.isLastItem,
  });

  final String orderid;
  final String date;
  final String amount;
  final bool isSuccess;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order ID: $orderid",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GlobalText(
                  alignment: Alignment.topLeft,
                  text: date,
                  textAlign: TextAlign.left,
                  color: const Color.fromRGBO(110, 122, 132, 1),
                  fontSize: 12,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(
                  height: 4,
                ),
                GlobalText(
                  alignment: Alignment.topLeft,
                  text: "RS $amount",
                  textAlign: TextAlign.left,
                  color: const Color.fromRGBO(16, 19, 21, 1),
                  fontSize: 14,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            PaymentStatus(
              isSuccess: isSuccess,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        if (!isLastItem)
          const Column(
            children: [
              Divider(
                color: Color.fromRGBO(205, 211, 215, 1),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          )
      ],
    );
  }
}

class PaymentStatus extends StatelessWidget {
  const PaymentStatus({
    super.key,
    required this.isSuccess,
  });

  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSuccess
            ? const Color.fromRGBO(218, 239, 198, 1)
            : const Color.fromRGBO(255, 224, 224, 1),
        borderRadius: BorderRadius.circular(120),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: GlobalText(
        padding: EdgeInsets.zero,
        text: isSuccess ? "Paid" : "Fail",
        color: isSuccess
            ? const Color.fromRGBO(76, 145, 13, 1)
            : const Color.fromRGBO(255, 102, 101, 1),
        fontSize: 12,
      ),
    );
  }
}

class PaymentHistoryEntry {
  final int orderid;
  final int accountid;
  final double payment_amount;
  final DateTime payment_date_time;
  final int payment_status;

  PaymentHistoryEntry({
    required this.orderid,
    required this.accountid,
    required this.payment_amount,
    required this.payment_date_time,
    required this.payment_status,
  });

  factory PaymentHistoryEntry.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryEntry(
      orderid: json['orderid'],
      accountid: json['accountid'],
      payment_amount: json['payment_amount'].toDouble(),
      payment_date_time: DateTime.parse(json['payment_date_time']),
      payment_status: json['payment_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderid,
      'accountid': accountid,
      'payment_amount': payment_amount,
      'payment_date_time': payment_date_time.toIso8601String(),
      'payment_status': payment_status,
    };
  }
}
