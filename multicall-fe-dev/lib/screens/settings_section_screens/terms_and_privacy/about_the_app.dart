import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';

class AboutTheAppScreen extends StatelessWidget {
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        leading: Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
        borderColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Image.asset(
                'assets/images/multicall_logo.png',
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '(C) DSNL',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Lato",
                fontWeight: FontWeight.w600,
                color: Color(0XFF101315),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '2017 All rights reserved',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Lato",
                fontWeight: FontWeight.w600,
                color: Color(0XFF101315),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
