import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/providers/intro_provider.dart';
import 'package:multicall_mobile/screens/group_section_screens/group_section_screen.dart';
import 'package:multicall_mobile/screens/multicall_home_screen.dart';
import 'package:multicall_mobile/screens/premium_section_screens/premium_section_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/setting_screen.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/widget/custom_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen_widget';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  TutorialCoachMark? tutorialCoachMark;
  late VoidCallback _listener;

  // Method to start the tutorial manually
  void startTutorial() {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);
    IntroProvider introProvider =
        Provider.of<IntroProvider>(context, listen: false);

    if (!introProvider.watchedIntro && !homeProvider.isTutorialShowing) {
      homeProvider.setTutorialShowing(true);
      createTutorial(introProvider);
      Future.delayed(
        Duration.zero,
        () => tutorialCoachMark!.show(context: context),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _listener = () {
      IntroProvider introProvider =
          Provider.of<IntroProvider>(context, listen: false);
      if (!introProvider.watchedIntro) {
        startTutorial();
        IntroProvider introProvider =
            Provider.of<IntroProvider>(context, listen: false);
        introProvider.removeListener(_listener);
      }
    };
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      IntroProvider introProvider =
          Provider.of<IntroProvider>(context, listen: false);
      introProvider.addListener(_listener);
      // Calling reconnect API
      Provider.of<CallsController>(context, listen: false).reconnect();

      ProfileController profileController = Provider.of<ProfileController>(
        context,
        listen: false,
      );

      Provider.of<CallsController>(context, listen: false);

      Provider.of<GroupController>(
        context,
        listen: false,
      );

      Provider.of<AccountController>(
        context,
        listen: false,
      );

      // Calling invitationSync API
      Provider.of<AppController>(context, listen: false).invitationSync();

      // Calling invitationSyncCancel API
      Provider.of<AppController>(context, listen: false).invitationSyncCancel();

      // Calling callMeOnRestore API (by calling constructor)
      Provider.of<CallMeOnController>(context, listen: false).callMeOnRestore();

      // Calling Group Sync API
      Provider.of<GroupController>(context, listen: false).syncGroup();

      profileController.getDeviceDetails().then(
            (value) => {profileController.cloudMessaging()},
          );

      /// delay for 5 seconds before making API call
      await Future.delayed(const Duration(seconds: 1)).then((value) async {
        if (!mounted) {
          return;
        }
        final profiles = profileController.profiles;

        if (profiles.isEmpty) {
          return;
        }

        /// Call the API for bulk update
        Provider.of<InstantCallProvider>(context, listen: false)
            .requestBulkUpdate();
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    IntroProvider introProvider =
        Provider.of<IntroProvider>(context, listen: false);
    introProvider.removeListener(_listener);
  }

  void createTutorial(IntroProvider introProvider) {
    PageController pageController =
        Provider.of<HomeProvider>(context, listen: false).pageController;

    var targets = <TargetFocus>[
      TargetFocus(
        identify: "homePageTabs",
        keyTarget: homePageTabs,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TourContentContainer(
              text:
                  "Monitor your active calls or find your past calls in All Calls tab.\n\nCheck your upcoming calls in Upcoming tab.",
              stepLabel: "1/7",
              onSkip: () {
                tutorialCoachMark!.finish();
              },
              onNext: () {
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "navigation1",
        keyTarget: navigation1,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TourContentContainer(
              text: "Make instant and scheduled MultiCalls from here.",
              stepLabel: "2/7",
              onSkip: () {
                tutorialCoachMark!.finish();
              },
              onNext: () async {
                await pageController.nextPage(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeIn,
                );
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "navigation2",
        keyTarget: navigation2,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TourContentContainer(
              text: "Create and manage groups for frequent call from here",
              stepLabel: "3/7",
              onSkip: () {
                tutorialCoachMark!.finish();
              },
              onNext: () {
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "createGroupButton",
        keyTarget: createGroupButton,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TourContentContainer(
              text: "Tap here to create a new group.",
              stepLabel: "4/7",
              onSkip: () {
                tutorialCoachMark!.finish();
              },
              onNext: () async {
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "editGroupButton",
        keyTarget: editGroupButton,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TourContentContainer(
              text: "Tap here to edit the group.",
              stepLabel: "5/7",
              onSkip: () {
                tutorialCoachMark!.finish();
              },
              onNext: () async {
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "favoriteGroup",
        keyTarget: favoriteGroup,
        shape: ShapeLightFocus.RRect,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => TourContentContainer(
              text:
                  "Call your Favorite groups with a single touch here.\n\nTap anywhere to start an instant call",
              stepLabel: "6/7",
              onSkip: () {
                tutorialCoachMark!.finish();
              },
              onNext: () async {
                await pageController.nextPage(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeIn);
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "navigation3",
        keyTarget: navigation3,
        shape: ShapeLightFocus.RRect,
        enableTargetTab: false,
        enableOverlayTab: false,
        radius: 10.0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => TourContentContainer(
              text: "Manage your account details here.",
              stepLabel: "7/7",
              onEnd: () async {
                tutorialCoachMark!.finish();
              },
            ),
          ),
        ],
      )
    ];
    setState(() {
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        hideSkip: true,
        useSafeArea: true,
        paddingFocus: 10,
        opacityShadow: 0.7,
        pulseEnable: false,
        imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        onClickOverlay: (p0) => {},
        onClickTargetWithTapPosition: (p0, p1) {},
        onClickTarget: (p0) => {},
        onFinish: () {
          introProvider.setWatchedIntro(true);
          Provider.of<HomeProvider>(navigatorKey.currentContext!, listen: false)
              .setTutorialShowing(false);
          introProvider.removeListener(_listener);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return CustomBottomNavigationBar(
            selectedIndex: homeProvider.selectedIndex,
            onItemTapped: homeProvider.onItemTapped,
          );
        },
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return PageView(
            controller: homeProvider.pageController,
            children: const <Widget>[
              MulticallScreen(),
              GroupSectionScreen(),
              SettingScreen(),
              PremiumSectionScreen(),
            ],
            onPageChanged: (index) {
              homeProvider.onItemTapped(index);
            },
          );
        },
      ),
    );
  }
}

class TourContentContainer extends StatelessWidget {
  const TourContentContainer({
    super.key,
    this.text = '',
    this.stepLabel = '',
    this.onSkip,
    this.onNext,
    this.onEnd,
  });

  final String text;
  final String stepLabel;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Text(
                stepLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
              const Spacer(),
              Wrap(
                direction: Axis.horizontal,
                runSpacing: 10.0,
                spacing: 10.0,
                children: [
                  if (onSkip != null)
                    GestureDetector(
                      onTap: () {
                        onSkip!();
                      },
                      child: Container(
                        height: 30,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDDE1E4).withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  if (onNext != null)
                    GestureDetector(
                      onTap: () {
                        onNext!();
                      },
                      child: Container(
                        height: 30,
                        width: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF62B414),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  if (onEnd != null)
                    GestureDetector(
                      onTap: () {
                        onEnd!();
                      },
                      child: Container(
                        height: 30,
                        width: 68,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: const Color(0xFF62B414),
                        ),
                        child: const Text(
                          "End Tour",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
