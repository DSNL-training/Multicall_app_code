import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_widget.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({Key? key}) : super(key: key);
  static const routeName = '/answer_screen';

  @override
  Widget build(BuildContext context) {
    final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
    final size = MediaQuery.of(context).size;
    final String question = (args as Map)['question'] ?? '';
    final List<String> answers = getAnswer(question);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text('Help'),
      ),
      body: SingleChildScrollView(
        child: CustomStyledContainer(
          height: size.height,
          width: size.width,
          verticalPadding: 24,
          horizontalPadding: 24,
          radius: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(
                alignment: Alignment.topLeft,
                text: question,
                fontWeight: FontWeight.w700,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12), // Add some space between question and answers
              ...answers
                  .map((answer) => Padding(
                        padding: EdgeInsets.only(bottom: 8.0, left: (answers.length > 1) ? 8 : 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (answers.length > 1)
                              Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(110, 122, 132, 1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (answers.length > 1) const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                answer,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(110, 122, 132, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  List<String> getAnswer(String question) {
    Map<String, List<String>> answerMap = {
      'Having trouble signing in?': [
        "Please use your registered email ID and Mobile number to sign in. These are the details you used to sign up on the app for the first time.",
        "You can access your MultiCall account from multiple devices using your registered email ID and phone number."
      ],
      'Forgotten email ID/Mobile number?': [
        'Please write to us at support@multicall.in or call us on +91 44 71262626 to reset your account (Note: This will log you out of all current MultiCall sessions across devices)'
      ],
    };

    return answerMap[question] ?? [''];
  }
}
