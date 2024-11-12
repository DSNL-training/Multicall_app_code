import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class GenericBottomSheetDialog extends StatelessWidget {
  final String title;
  final String negativeButtonText;
  final String positiveButtonText;
  final VoidCallback onTap;
  final bool isOnlyOneButton;

  const GenericBottomSheetDialog({
    super.key,
    required this.negativeButtonText,
    required this.positiveButtonText,
    required this.onTap,
    required this.title,
    this.isOnlyOneButton = false,
  });

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
                height: 24,
              ),
              SizedBox(
                height: 8,
                child: Center(
                  child: Container(
                    height: 6,
                    width: 46,
                    decoration: const BoxDecoration(
                      color: Color(0XFFCDD3D7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(16, 19, 21, 1),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const HorizontalDivider(),
              isOnlyOneButton
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButtonWithBG(
                        fontSize: 16,
                        title: positiveButtonText,
                        action: onTap,
                        width: MediaQuery.of(context).size.width * 0.90,
                        color: const Color.fromRGBO(0, 134, 181, 1),
                        textColor: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          TextButtonWithBG(
                            fontSize: 16,
                            title: negativeButtonText,
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
                            title: positiveButtonText,
                            action: onTap,
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
