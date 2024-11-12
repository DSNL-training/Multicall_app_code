import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/user_details.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CCAvenuePay {
  static const String paymentAccessCode = "ATQF05LI94BL77FQLB";
  static const String merchantId = "159834";

  static Future<void> initiatePayment(
      BuildContext context, Map<String, dynamic> userDetails) async {
    try {
      // Step 1: Get user personal details
      final UserDetails? userPersonalDetails = await _getUserPersonalDetails(
          userDetails['accountId'],
          userDetails['registrationNumber'],
          userDetails['profileReferenceNumber']);

      if (userPersonalDetails != null) {
        // Step 2: Get RSA key and other payment details
        final paymentDetails =
            await _getPaymentDetails(userPersonalDetails, context);
        // Step 3: Add payment details to payment provider
        if (paymentDetails != null) {
          Provider.of<PaymentProvider>(context, listen: false)
              .addPaymentGatewayDetails(
            paymentDetails['payment_gateway_url'],
            paymentDetails['redirect_url'],
            paymentDetails['cancel_url'],
            paymentDetails["mobile_payment_pgw_url"],
          );
        } else {
          _showError(context, 'Failed to initiate payment. Please try again.');
        }
      }
    } catch (e) {
      _showError(context, 'An error occurred: $e');
    }
  }

  static Future<UserDetails?> _getUserPersonalDetails(String accountId,
      String registrationNumber, String profileReferenceNumber) async {
    final response = await http.post(
      Uri.parse(
        'http://3.110.39.144:8085/pgwi/getuserpersonaldetails.action?request_data=REDEF&account_id=$accountId&registration_number=$registrationNumber&profile_reference_number=$profileReferenceNumber',
      ),
    );

    if (response.statusCode == 200) {
      final responseBody = decodeString(
          response.body.trim()); // Remove any surrounding whitespace
      debugPrint(responseBody.toString());

      // Check if the response body is empty or just a space
      if (responseBody.isEmpty) {
        return null;
      }

      // Assuming the response is valid JSON if it's not empty or just a space

      if (responseBody.isNotEmpty) {
        return UserDetails.fromJson(responseBody);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load user details');
    }
  }

  static Future<Map<String, dynamic>?> _getPaymentDetails(
    UserDetails userDetails,
    context,
  ) async {
    PaymentProvider paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse(
        "http://3.110.39.144:8085/pgwi/getrsakey.action?request_data=REDEF&account_id=${paymentProvider.accountId}&currency=${paymentProvider.paymentCurrency}&plan_id=${paymentProvider.planId}&plan_duration=${paymentProvider.planDuration}&plan_name=${paymentProvider.planName}&plan_recharge_amount=${paymentProvider.planRechargeAmount.toStringAsFixed(0)}&addon_plan_id=${paymentProvider.addonPlanId}&addon_plan_duration=${paymentProvider.addonPlanDuration}&addon_plan_name=${paymentProvider.addonPlanName}&addon_plan_cost=${paymentProvider.addonPlanRechargeAmount}&payment_state_code=${paymentProvider.planStateCode}&profilename=${paymentProvider.profileName}&address1=${paymentProvider.address1}&city=${paymentProvider.city}&state=${paymentProvider.state}&country=INDIA&postalcode=${paymentProvider.postalCode}&gstcode=${paymentProvider.gstNumber}&registration_number=${paymentProvider.regNum}&profile_reference_number=${paymentProvider.profileRefNumber}&profile_phone_number=${paymentProvider.telephone}&profile_emailid=${paymentProvider.email}&profile_crn_number=${paymentProvider.profileCrnNumber}&item_type=1&app_version=15&access_code=$paymentAccessCode&merchant_id=$merchantId",
      ),
    );

    if (response.statusCode == 200) {
      final responseBody = decodeString(
          response.body.trim()); // Remove any surrounding whitespace
      debugPrint(responseBody.toString());

      // Check if the response body is empty or just a space
      if (responseBody.isEmpty) {
        return null;
      }

      paymentProvider.addGstValues(
        int.parse(responseBody["cgstpercentage"] ?? 0),
        int.parse(responseBody["sgstpercentage"] ?? 0),
        int.parse(responseBody["igstpercentage"] ?? 0),
        int.parse(responseBody["cgst"] ?? 0),
        int.parse(responseBody["sgst"] ?? 0),
        int.parse(responseBody["igst"] ?? 0),
        int.parse(responseBody["total_amount"] ?? 0),
      );
      return {
        'payment_gateway_url': responseBody['payment_gateway_url'],
        'redirect_url': responseBody['redirect_url'],
        'cancel_url': responseBody['cancel_url'],
        'mobile_payment_pgw_url':
            "${responseBody['payment_gateway_url']}&encRequest=${responseBody["rsa_key"]}&access_code=${responseBody["access_code"]}",
      };
    } else {
      return null;
    }
  }

  static void launchPaymentWebView(
    BuildContext context,
  ) {
    PaymentProvider paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);
    late final WebViewController controller;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            print("pageStated: $url");
          },
          onPageFinished: (String url) {
            print("pageFinished: $url");
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print("webViewReq, $request");
            if (request.url.startsWith(paymentProvider.redirectUrl)) {
              // Handle successful payment
              Navigator.of(context).pop(); // Close WebView
              // Add your success logic here
              return NavigationDecision.prevent;
            } else if (request.url.startsWith(paymentProvider.cancelUrl)) {
              // Handle cancelled payment
              Navigator.of(context).pop(); // Close WebView
              // Add your cancellation logic here
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentProvider.mobilePaymentGatewayUrl));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Payment')),
          body: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
