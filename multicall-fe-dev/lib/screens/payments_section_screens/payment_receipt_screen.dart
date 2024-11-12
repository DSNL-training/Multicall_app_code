import 'dart:io';
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/template/payment_template.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/dashed_divider.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class PaymentReceiptScreen extends StatefulWidget {
  const PaymentReceiptScreen({super.key});

  static const routeName = '/payment-receipt-screen';

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

String updateHtmlTemplate(
  String template,
  String orderId,
  String accountId,
  String name,
  String address,
  String city,
  String state,
  String pinCode,
  String phoneNumber,
  String gstNo,
  String planName,
  String planAmount,
  String cgst,
  String cgstAmount,
  String sgst,
  String sgstAmount,
  String igst,
  String igstAmount,
  String totalAmount,
) {
  return template
      .replaceAll('{{orderId}}', orderId)
      .replaceAll('{{accountId}}', accountId)
      .replaceAll('{{name}}', name)
      .replaceAll('{{address}}', address)
      .replaceAll('{{city}}', city)
      .replaceAll('{{state}}', state)
      .replaceAll('{{pinCode}}', pinCode)
      .replaceAll('{{phoneNumber}}', phoneNumber)
      .replaceAll('{{gstNo}}', gstNo)
      .replaceAll('{{planName}}', planName)
      .replaceAll('{{planAmount}}', planAmount)
      .replaceAll('{{cgst}}', cgst)
      .replaceAll('{{cgstAmount}}', cgstAmount)
      .replaceAll('{{sgst}}', sgst)
      .replaceAll('{{sgstAmount}}', sgstAmount)
      .replaceAll('{{igst}}', igst)
      .replaceAll('{{igstAmount}}', igstAmount)
      .replaceAll('{{totalAmount}}', totalAmount);
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> {
  String updatedHtml = "";
  final _flutterNativeHtmlToPdfPlugin = FlutterNativeHtmlToPdf();
  String? generatedPdfFilePath;

  @override
  void initState() {
    super.initState();
    PaymentProvider provider =
        Provider.of<PaymentProvider>(context, listen: false);
    updatedHtml = updateHtmlTemplate(
      htmlTemplate,
      "000000",
      provider.accountId.toString(),
      provider.profileName,
      provider.address1,
      provider.city,
      provider.state,
      provider.postalCode.toString(),
      PreferenceHelper.get(PrefUtils.userPhoneNumber),
      provider.gstNumber,
      provider.planName,
      (provider.planRechargeAmount / 100).toString(),
      provider.cgst.toString(),
      provider.cgst == 0 ? "0" : provider.cgstAmount.toString(),
      provider.sgst.toString(),
      provider.sgst == 0 ? "0" : provider.sgstAmount.toString(),
      provider.igst.toString(),
      provider.igst == 0 ? "0" : provider.igstAmount.toString(),
      (provider.totalAmount.toStringAsFixed(2)),
    );
    generateDocument();
  }

  Future<void> generateDocument() async {
    Directory? dir;

    if (Platform.isAndroid) {
      // Android-specific download directory
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      dir = Directory(downloadsFolderPath);

      // Check storage permission before saving
      if (!(await _requestStoragePermission())) {
        return; // Handle permission denied
      }
    } else if (Platform.isIOS) {
      // iOS-specific document directory
      dir = await getApplicationDocumentsDirectory();
    }
    const targetFileName = "payment-receipt";

    final generatedPdfFile =
        await _flutterNativeHtmlToPdfPlugin.convertHtmlToPdf(
      html: updatedHtml,
      targetDirectory: dir!.path,
      targetName: targetFileName,
    );

    generatedPdfFilePath = generatedPdfFile?.path;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        showBackButton: false,
        leading: Text("Payments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ContainerWithZigZagBorder(
                  size: size,
                  orderId: 252,
                  totalAmount: "51.92",
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () async {
                    await generateDocument()
                        .then((value) => showToast("File downloaded"))
                        .catchError((e) {
                      showToast("File download failed ${e.toString()}");
                    });
                    // if (downloadedFile != null) {
                    //   showToast("File downloaded");
                    // }
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PhosphorIcon(
                        PhosphorIconsDuotone.newspaper,
                        size: 24,
                        duotoneSecondaryColor: Color.fromRGBO(0, 134, 181, 1),
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GlobalText(
                        text: "Download Receipt",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Roboto",
                        padding: EdgeInsets.zero,
                      )
                    ],
                  ),
                )
              ],
            ),
            // SingleChildScrollView(
            //   child: Html(
            //     data: updatedHtml,
            //   ),
            // ),
            TextButtonWithBG(
              title: 'Done',
              action: () {
                /// Navigate to home screen
                Navigator.of(context).popUntil((route) => route.isFirst);

                /// Set selected bottom navigation screen to 0 (MultiCall)
                Provider.of<HomeProvider>(context, listen: false)
                    .onItemTapped(0);
              },
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

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      showToast("Please allow storage permission");
      return false;
    }
  }

  Future<File?> downloadPDF(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // Check storage permission before saving
      if (Platform.isAndroid && !(await _requestStoragePermission())) {
        return null; // Handle permission denied
      }
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);

      // final directory = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName.pdf');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      // Handle download error (e.g., show a toast)
      return null;
    }
  }
}

class ContainerWithZigZagBorder extends StatelessWidget {
  const ContainerWithZigZagBorder({
    super.key,
    required this.size,
    required this.totalAmount,
    required this.orderId,
  });

  final Size size;
  final String totalAmount;
  final int orderId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ClipPath(
        clipper: MyClipper(),
        child: Container(
          width: size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/multicall_logo.png',
                width: 130,
                height: 50,
              ),
              const SizedBox(
                height: 24,
              ),
              PaymentDetailRow(
                icon: PhosphorIconsDuotone.clipboardText,
                title: "Order ID",
                data: orderId.toString(),
              ),
              const SizedBox(
                height: 16,
              ),
              PaymentDetailRow(
                icon: PhosphorIconsDuotone.handCoins,
                title: "Total Amount",
                data: '₹ $totalAmount',
              ),
              const SizedBox(
                height: 16,
              ),
              const DashedDivider(
                color: Color.fromRGBO(205, 211, 215, 1),
              ),
              const SizedBox(
                height: 16,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Status"),
                  Text(
                    "Success",
                    style: TextStyle(
                      color: Color.fromRGBO(98, 180, 20, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentDetailRow extends StatelessWidget {
  const PaymentDetailRow({
    super.key,
    required this.data,
    required this.title,
    required this.icon,
  });

  final String data;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleWithIcon(
          icon: icon,
          title: title,
        ),
        Text(
          data,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class TitleWithIcon extends StatelessWidget {
  const TitleWithIcon({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PhosphorIcon(
          icon,
          duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
          color: Colors.black,
          size: 14,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(78, 93, 105, 1),
          ),
        )
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  final int frequency;

  MyClipper({this.frequency = 50});

  @override
  Path getClip(Size size) {
    var smallLineLength = size.width / frequency;
    const smallLineHeight = 8;
    var path = Path();

    path.lineTo(0, size.height);
    for (int i = 1; i <= frequency; i++) {
      if (i % 2 == 0) {
        path.lineTo(smallLineLength * i, size.height);
      } else {
        path.lineTo(smallLineLength * i, size.height - smallLineHeight);
      }
    }
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
