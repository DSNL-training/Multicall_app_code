import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/feedback_input_field.dart';
import 'package:multicall_mobile/widget/feedback_success_bottom_sheet.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  static const String routeName = '/feedback-screen';

  const FeedbackScreen({super.key});

  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text(
            "Feedback",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 21,
              color: Colors.black,
            ),
          ),
        ),
        body: Consumer<AppController>(
          builder: (BuildContext context, provider, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomStyledContainer(
                        height: size.height - 247,
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                "Enter your feedback here",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: FeedbackInputField(
                                size: size,
                                label: 'what\'s on your mind?',
                                controller: _feedbackController,
                                focusNode: null,
                                textInputAction: TextInputAction.done,
                                onChanged: (value) => {setState(() {})},
                              ),
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
                      title: 'Submit',
                      action: () async {
                        provider.addUserFeedback(_feedbackController.text, "");
                        Navigator.pop(context);
                        showFeedbackSuccessBottomSheet(context);
                      },
                      color: const Color.fromRGBO(98, 180, 20, 1),
                      textColor: Colors.white,
                      fontSize: 16,
                      isDisabled: _feedbackController.text.isEmpty,
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
