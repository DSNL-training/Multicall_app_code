import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class AddNewPhoneScreen extends StatefulWidget {
  static const routeName = '/add-phone-number-screen';

  const AddNewPhoneScreen({super.key});
  @override
  State<AddNewPhoneScreen> createState() => _AddNewPhoneScreenState();
}

class _AddNewPhoneScreenState extends State<AddNewPhoneScreen> {
  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text(
          'Add Phone Number',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomStyledContainer(
                  height: size.height * 0.5,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Please complete all fields to proceed",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        NameInputField(
                          size: size,
                          label: "Enter your mobile number",
                          controller: _mobileController,
                          onChanged: (v) {
                            // FocusScope.of(context).requestFocus(_pinFocus);
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
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: TextButtonWithBG(
                title: 'Done',
                action: () {},
                color: const Color.fromRGBO(98, 180, 20, 1),
                textColor: Colors.white,
                fontSize: 16,
                isDisabled: _mobileController.text.isEmpty,
                // iconData: iconData,
                iconColor: Colors.white,
                width: size.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
