import 'package:flutter/material.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class OnlyPaidDialogue extends StatefulWidget {
  const OnlyPaidDialogue({super.key});

  @override
  State<OnlyPaidDialogue> createState() => _OnlyPaidDialogueState();
}

class _OnlyPaidDialogueState extends State<OnlyPaidDialogue> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Text(
                "This feature is available in our paid plans.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(16, 19, 21, 1),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const HorizontalDivider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    TextButtonWithBG(
                      fontSize: 16,
                      title: "OK",
                      action: () {
                        Navigator.pop(context);
                      },
                      border: Border.all(
                        width: 1,
                        color: const Color.fromRGBO(221, 225, 228, 1),
                      ),
                      width: MediaQuery.of(context).size.width * 0.43,
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButtonWithBG(
                      fontSize: 16,
                      title: "Paid Plans",
                      action: () {
                        Navigator.pop(context);
                        final homeProvider =
                            Provider.of<HomeProvider>(context, listen: false);

                        Future.delayed(const Duration(milliseconds: 500),
                            () => homeProvider.navigateToPremium());
                      },
                      width: MediaQuery.of(context).size.width * 0.43,
                      color: const Color.fromRGBO(0, 134, 181, 1),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ],
    );
  }
}
