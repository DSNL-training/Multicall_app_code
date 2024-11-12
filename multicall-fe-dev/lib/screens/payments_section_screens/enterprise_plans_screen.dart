import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/gmail_input_field.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class EnterprisePlansScreen extends StatefulWidget {
  const EnterprisePlansScreen({super.key});

  static const routeName = '/enterprise-screen';

  @override
  State<EnterprisePlansScreen> createState() => _EnterprisePlansScreenState();
}

class _EnterprisePlansScreenState extends State<EnterprisePlansScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _organizationNameController =
      TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  String emailErrorText = "";
  Color emailPlaceHolderColor = const Color(0XFF4e5d69);
  Color emailFieldColor = const Color(0XffCDD7D7);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
    // final String question = (args as Map)['plan'] ?? '';
    // print(args);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text(
          "Enterprise Plan",
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
                            const Text(
                              "Please fill the following details",
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
                              onSubmit: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_mobileFocus);
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            PhoneNumberInputField(
                              size: size,
                              label: "Enter your mobile number",
                              controller: _mobileNumberController,
                              focusNode: _mobileFocus,
                              onChanged: (v) {
                                setState(() {});
                              },
                              onSubmit: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                              errorText: '',
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            GmailInputField(
                              focusNode: _emailFocus,
                              size: size.width * 0.9,
                              label: "Enter your email id",
                              errorText: emailErrorText,
                              controller: _emailIdController,
                              textInputAction: TextInputAction.next,
                              onChanged: (v) {
                                setState(() {});
                              },
                              borderColor: emailFieldColor,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            NameInputField(
                              size: size,
                              label: "Organization",
                              controller: _organizationNameController,
                              onChanged: (v) {
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 24,
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
                  title: 'Submit',
                  action: () {
                    provider.requestAppRequestToSendEnterprisePlanToMcSupport(
                      _emailIdController.text,
                      _nameController.text,
                      _mobileNumberController.text,
                    );

                    showToast("Request Sent Successfully. Thank You!");
                    Navigator.pop(context);
                  },
                  isDisabled: _nameController.text.isEmpty ||
                      _emailIdController.text.isEmpty ||
                      _mobileNumberController.text.isEmpty,
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  // iconData: iconData,
                  iconColor: Colors.white,
                  width: size.width,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
