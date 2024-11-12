import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multicall_mobile/screens/signup_screen.dart';
import 'package:multicall_mobile/widget/dot-indicator.dart';
import 'package:multicall_mobile/widget/onboard-content.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

// OnBoarding content list
final List<OnBoard> demoData = [
  OnBoard(
    image: "assets/images/laptop-and-talking.png",
    title: "One-To-Many Calling Made Easy",
    description:
        "Select contacts and call instantly, create groups and call with a single touch",
  ),
  OnBoard(
    image: "assets/images/schedule-and-calender.png",
    title: "Schedule Calls",
    description:
        "Schedule calls by inviting friends, choose to let the system call you at the schedule time",
  ),
  OnBoard(
    image: "assets/images/holding-phone.png",
    title: "Profiles",
    description: "Maintain different profiles for work and personal calls",
  ),
];

// OnBoardingScreen
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = "/onboarding-screen";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments ?? {};
    final bool isNavigatingForHelp =
        (args as Map)['isNavigatingForHelp'] ?? false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        actions: [
          if (!isNavigatingForHelp && _pageIndex != 2)
            TextButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(SignupScreen.routeName);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      itemCount: demoData.length,
                      controller: _pageController,
                      itemBuilder: (context, index) => OnBoardContent(
                        image: demoData[index].image,
                        title: demoData[index].title,
                        description: demoData[index].description,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        demoData.length,
                        (index) => DotIndicator(
                          isActive: index == _pageIndex,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 42.0,
                left: 24.0,
                right: 24.0,
                bottom: 16.0 + MediaQuery.of(context).padding.bottom,
              ),
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _pageIndex == 2 && !isNavigatingForHelp ? true : false,
                child: TextButtonWithBG(
                  action: () {
                    Navigator.of(context)
                        .popAndPushNamed(SignupScreen.routeName);
                  },
                  title: 'Get Started',
                  width: double.infinity,
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
