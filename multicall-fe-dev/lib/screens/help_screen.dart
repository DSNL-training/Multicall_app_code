import 'package:flutter/material.dart';
import 'package:multicall_mobile/screens/answer_screen.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/question_widget.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = "/help-screen";

  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Row(
            children: [
              Text(
                "Help",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: CustomStyledContainer(
            height: size.height,
            width: size.width,
            verticalPadding: 16,
            horizontalPadding: 24,
            radius: 0,
            child: Column(
              children: [
                QuestionWidget(
                  question: 'Having trouble signing in?',
                  isLastQuestion: false,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AnswerWidget.routeName,
                      arguments: {'question': 'Having trouble signing in?'},
                    );
                  },
                ),
                QuestionWidget(
                  question: 'Forgotten email ID/Mobile number?',
                  isLastQuestion: false,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AnswerWidget.routeName,
                      arguments: {
                        'question': 'Forgotten email ID/Mobile number?'
                      },
                    );
                  },
                ),
                QuestionWidget(
                  question:
                      'Still facing a problem? \nCall us at +91 44 71262626',
                  isLastQuestion: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
