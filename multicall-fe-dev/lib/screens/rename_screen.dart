import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class RenameScreen extends StatefulWidget {
  static const routeName = '/rename-screen';

  final String? initialName;
  final String? appBarTitle;
  final String? inputFieldLabel;

  const RenameScreen({
    super.key,
    this.initialName,
    this.appBarTitle,
    this.inputFieldLabel,
  });

  @override
  RenameScreenState createState() => RenameScreenState();
}

class RenameScreenState extends State<RenameScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
          leading: Text(
            widget.appBarTitle ?? "Rename",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 21,
              color: Colors.black,
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
                  padding: const EdgeInsets.all(16.0),
                  child: CustomStyledContainer(
                    height: size.height - 250,
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Consumer<CallsController>(
                        builder: (context, callsController, child) {
                          return NameInputField(
                            size: size,
                            label: widget.inputFieldLabel ?? "Enter name",
                            controller: _nameController,
                            maxLength: 15,
                            onChanged: (v) {
                              callsController.setCallName(v);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 12.0,
                  bottom: 12.0 + MediaQuery.of(context).padding.bottom,
                ),
                child: Consumer<CallsController>(
                  builder: (context, callsController, child) {
                    return TextButtonWithBG(
                      title: 'Save',
                      action: () {
                        if (callsController.callName.length > 2) {
                          Navigator.pop(context);
                        } else {
                          showToast("Please enter a valid name");
                        }
                      },
                      color: const Color.fromRGBO(98, 180, 20, 1),
                      textColor: Colors.white,
                      fontSize: 16,
                      iconColor: Colors.white,
                      width: size.width,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
