import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';

class AddProfileHelpWidget extends StatelessWidget {
  const AddProfileHelpWidget({Key? key}) : super(key: key);
  static const routeName = '/add-profile-help';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        leading: Text('Help'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BulletPointText(
              points:
                  "Use different profiles to organize your calls and manage expenses. Create profiles for clients, colleagues or friends.",
            ),
            BulletPointText(
                points:
                    "Each profile has a default email ID and payment method that choose (You can have multiple profiles with the same email ID)"),
          ],
        ),
      ),
    );
  }
}

class BulletPointText extends StatelessWidget {
  const BulletPointText({
    super.key,
    required this.points,
  });

  final String points;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '•',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(110, 122, 132, 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  points,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(110, 122, 132, 1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
