import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/models/labels_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response_call_me_on_restore.dart';
import 'package:multicall_mobile/models/response_call_me_on_update.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/phone_number_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class AddPhoneNumberDropDownScreen extends StatefulWidget {
  static const routeName = '/add-phone-dropdown-number';

  const AddPhoneNumberDropDownScreen({super.key});

  @override
  AddPhoneNumberDropDownScreenState createState() =>
      AddPhoneNumberDropDownScreenState();
}

class AddPhoneNumberDropDownScreenState
    extends State<AddPhoneNumberDropDownScreen> {
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _phoneNumberFocus = FocusNode();
  String strPhoneError = "";

  LabelModel selectedModel = LabelModel(code: -1, value: "");

  var isDropDownErrorVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final callMeOnProvider =
        Provider.of<CallMeOnController>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text("Add Phone Number"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomStyledContainer(
                    height: _numberController.text.isNotEmpty
                        ? size.height - math.max(size.height * 0.265, 200)
                        : size.height - math.max(size.height * 0.165, 140),
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Please complete all fields to proceed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDropdownField(
                            size: size,
                            label: "Select Label",
                            errorLabel: "Please select a label",
                            isErrorVisible: isDropDownErrorVisible,
                            items: LabelModel.getDefaultLabels().map((e) {
                              return e.value;
                            }).toList(),
                            onChanged: (v) {
                              isDropDownErrorVisible = false;
                              selectedModel = LabelModel(
                                code: LabelModel.getCodeByLabel(v),
                                value: v,
                              );
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PhoneNumberInputField(
                            focusNode: _phoneNumberFocus,
                            size: size,
                            label: "Enter your mobile number",
                            errorText: strPhoneError,
                            controller: _numberController,
                            onChanged: (v) {
                              strPhoneError = "";
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_numberController.text.isNotEmpty)
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButtonWithBG(
                    title: 'Done',
                    action: () async {
                      bool hasError = false;

                      // Validate dropdown selection
                      if (selectedModel.code == -1) {
                        isDropDownErrorVisible = true;
                        hasError = true;
                      }

                      // Validate phone number
                      if (!RegExp(r'^[0-9]{10,15}$')
                          .hasMatch(_numberController.text)) {
                        strPhoneError = 'Please enter a valid phone number';
                        hasError = true;
                      }

                      if (hasError) {
                        setState(() {}); // Update UI if there's any error
                        return; // Stop execution if validation failed
                      }

                      // Check for duplicate number
                      var number =
                          callMeOnProvider.filteredCallMeOnList.firstWhere(
                        (element) => element.callMeOn == _numberController.text,
                        orElse: () => CallMeOn(callMeOn: "", labelType: -2),
                      );

                      if (number.callMeOn.isNotEmpty) {
                        showToast("Duplicate Number Found!");
                        return; // Stop execution if duplicate number is found
                      }

                      // Prepare members list
                      List<NumberEntry> members = [];

                      // Add existing call me on numbers
                      if (callMeOnProvider.callMeOnList.isNotEmpty) {
                        for (var element in callMeOnProvider.callMeOnList) {
                          members.add(NumberEntry(
                            callMeOnNumber: element.callMeOn,
                            type: element.labelType,
                          ));
                        }
                      }

                      // Add the currently selected number
                      members.add(NumberEntry(
                        callMeOnNumber: _numberController.text,
                        type: selectedModel.code,
                      ));

                      // Call update API
                      var response = await callMeOnProvider.updateCallMeOn(
                        members.length,
                        members,
                      ) as ResponseCallMeOnUpdate;

                      if (response.status == true) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Provider.of<CallMeOnController>(context,
                                  listen: false)
                              .addNumberSuccess(response.status);
                          showToast("Call Me On number added successfully.");
                          Navigator.pop(context);
                        });
                      }
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
        ),
      ),
    );
  }
}
