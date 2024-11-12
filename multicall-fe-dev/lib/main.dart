import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/controller/app_controller.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/add_business_profile_provider.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/providers/contact_provider.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/providers/intro_provider.dart';
import 'package:multicall_mobile/providers/payment_provider.dart';
import 'package:multicall_mobile/providers/route_observer.dart';
import 'package:multicall_mobile/providers/speaking_provider.dart';
import 'package:multicall_mobile/screens/add_new_phone.dart';
import 'package:multicall_mobile/screens/add_new_profile.dart';
import 'package:multicall_mobile/screens/add_number_without_label.dart';
import 'package:multicall_mobile/screens/answer_screen.dart';
import 'package:multicall_mobile/screens/call_me_on_screen.dart';
import 'package:multicall_mobile/screens/call_now_screen.dart';
import 'package:multicall_mobile/screens/choose_profile_screen.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/email_pin_verification_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/change_number_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/group_section_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/new_group_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/update_group_name_screen.dart';
import 'package:multicall_mobile/screens/help_screen.dart';
import 'package:multicall_mobile/screens/instant_call_screen.dart';
import 'package:multicall_mobile/screens/instant_call_screen_call_now.dart';
import 'package:multicall_mobile/screens/mobile_pin_verification.dart';
import 'package:multicall_mobile/screens/onboarding_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/add_on_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/billing_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/choose_your_plan_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/enterprise_plans_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/order_summery_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/payment_history_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/payment_profiles.dart';
import 'package:multicall_mobile/screens/payments_section_screens/payment_receipt_screen.dart';
import 'package:multicall_mobile/screens/payments_section_screens/profile_plan_details.dart';
import 'package:multicall_mobile/screens/payments_section_screens/topup_screen.dart';
import 'package:multicall_mobile/screens/premium_section_screens/premium_section_screen.dart';
import 'package:multicall_mobile/screens/rename_screen.dart';
import 'package:multicall_mobile/screens/repeat_screen.dart';
import 'package:multicall_mobile/screens/schedule_call_screen.dart';
import 'package:multicall_mobile/screens/schedule_dial_in_screen.dart';
import 'package:multicall_mobile/screens/schedule_invitation_notification_screen.dart';
import 'package:multicall_mobile/screens/scheduled_invitation_screen.dart';
import 'package:multicall_mobile/screens/select_duration_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/account_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_email_id_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_dropdown.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/call_me_on_setting_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/faq_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/feedback_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/help_settings_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/add_business_profile_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/create_profile_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/edit_profile_name.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profile_details_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/profiles_section/profiles_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/setting_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/terms_and_privacy/about_the_app.dart';
import 'package:multicall_mobile/screens/settings_section_screens/terms_and_privacy/terms_and_privacy.dart';
import 'package:multicall_mobile/screens/settings_section_screens/verify_email_screen.dart';
import 'package:multicall_mobile/screens/signup_screen.dart';
import 'package:multicall_mobile/screens/splash_screen.dart';
import 'package:multicall_mobile/theme/text_theme.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:multicall_mobile/widget/add_profile_help.dart';
import 'package:multicall_mobile/widget/home_screen_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

// Define the background handler as a top-level function outside of main()
Future<void> foregroundHandler(ReceivedAction action) async {
  if (action.payload != null && action.payload?["pushType"] == "1") {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ScheduledInvitationNotificationScreen(
          scheduleRefNo: int.parse(action.payload?["scheduleRefNo"] ?? "0"),
          confName: action.payload?["confName"] ?? "",
          scheduleDateTime: action.payload?["scheduleDateTime"] ?? "",
          updatedEndDateTime: action.payload?["updatedEndDateTime"] ?? "",
          confDuration: int.parse(action.payload?["conferenceDuration"] ?? "0"),
          chairpersonName: action.payload?["chairpersonName"] ?? "",
          repeatType: int.parse(action.payload?["repeatType"] ?? "0"),
          recurrentId: int.parse(action.payload?["recurrentId"] ?? "0"),
        ),
      ),
    );
  }
}

Future<void> backgroundHandler(RemoteMessage action) async {
  if (action.data["push_type"] == "1") {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ScheduledInvitationNotificationScreen(
          confName: action.data["conf_name"],
          scheduleRefNo: int.parse(action.data["schedule_ref_number"] ?? "0"),
          scheduleDateTime: action.data["schedule_start_date_time"],
          updatedEndDateTime: action.data["schedule_end_date_time"],
          confDuration: int.parse(action.data["conference_duration"]),
          chairpersonName: action.data["chairperson_name"],
          repeatType: int.parse(action.data["repeat_type"]),
          recurrentId: int.parse(action.data["recurrent_id"]),
        ),
      ),
    );
  }
}

void main() async {
  // Initialize Firebase based on the platform
  if (defaultTargetPlatform == TargetPlatform.android) {
    initializeFirebase();
  }

  // Run the app with a list of providers using MultiProvider.
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => BaseProvider(),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ChangeNotifierProvider(create: (context) => InstantCallProvider()),
        ChangeNotifierProvider(create: (context) => AppController()),
        ChangeNotifierProvider(create: (context) => CallsController()),
        ChangeNotifierProvider(create: (context) => GroupController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => AccountController()),
        ChangeNotifierProvider(create: (context) => CallMeOnController()),

        /// Base Provider not needed for Home Provider, Intro Provider,
        /// Add Business Profile Provider, Speaking Provider, and Contact Provider
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => IntroProvider()),
        ChangeNotifierProvider(create: (_) => AddBusinessProfileProvider()),
        ChangeNotifierProvider(create: (_) => SpeakingProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      // Start the application by rendering the MyApp widget.
      child: Builder(builder: (context) {
        return const MyApp();
      }),
    ),
  ));
}

/// Firebase Cloud Messaging (FCM) initialization
Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Change system navigation bar color to white and set icon color to dark
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Cloud Messaging (FCM) initialization
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Background message handler
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    backgroundHandler(message);
    return;
  });

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/ic_notification',
    [
      NotificationChannel(
        channelKey: 'default',
        channelName: 'Default',
        channelDescription: 'Default channel',
        importance: NotificationImportance.Max,
        locked: true,
        playSound: true,
      ),
    ],
  );

  // Message stream controller
  final messageStreamController = BehaviorSubject<RemoteMessage>();

  // Listen to foreground messages

  if (defaultTargetPlatform != TargetPlatform.iOS) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          color: Colors.green,
          channelKey: 'default',
          title: message.notification?.title,
          body: message.notification?.body,
          payload: {
            "pushType": message.data["push_type"].toString(),
            "scheduleRefNo": message.data["schedule_ref_number"].toString(),
            "confName": message.data["conf_name"],
            "scheduleDateTime": message.data["schedule_start_date_time"],
            "updatedEndDateTime": message.data["schedule_end_date_time"],
            "conferenceDuration": message.data["conference_duration"],
            "chairpersonName": message.data["chairperson_name"],
            "repeatType": message.data["repeat_type"],
            "recurrentId": message.data["recurrent_id"],
          },
          criticalAlert: true,
          wakeUpScreen: true,
          largeIcon: message.notification?.android?.imageUrl ??
              'asset://assets/images/multi-call-notification-logo.png',
        ),
      );
      messageStreamController.sink.add(message);
    });
  }

  // Set notification listeners
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: foregroundHandler,
  );

  await Future.delayed(const Duration(seconds: 1));

  // Retrieve FCM token and save it
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? fcmToken;

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    fcmToken = await messaging.getToken();
  }

  if (fcmToken != null && fcmToken.isNotEmpty) {
    await prefs.setString("fcmToken", fcmToken);
  }

  // Request notification permissions
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "MainNavigator");

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WebSocketService _webSocketService = WebSocketService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    //_webSocketService.connect('ws://multicall.f22labs.cloud/');
    _webSocketService.connect(AppConstants().websocketUrl);
    startHealthActionCallTimer(context);
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    _timer?.cancel();
    super.dispose();
  }

  void startHealthActionCallTimer(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final completer = Completer<void>();

      // Start a 1-second timer to check for WebSocket response
      Timer(const Duration(seconds: 1), () {
        if (!completer.isCompleted) {
          completer.completeError(
              'Timeout: No response from WebSocket within 1 second');
        }
      });

      try {
        // check if registrationNumber != 0
        if ((PreferenceHelper.get(PrefUtils.userRegistrationNumber) ?? 0) ==
            0) {
          return;
        }

        // Fetch the latest regNum value before making the API call
        final appController =
            Provider.of<AppController>(context, listen: false);
        ResponseRequestHealthSuccess response =
            await appController.requestHealthCheck();

        if (!completer.isCompleted) {
          completer.complete(); // Complete if response is received in time

          if (response.statusRes != "success") {
            // Handle non-success responses here
            // Calling reconnect API
            Provider.of<CallsController>(context, listen: false).reconnect();
          }
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError('Error: $e');
        }
      }

      // Handle timeout or error
      await completer.future.catchError((error) {
        //  fallback block of code
        handleNoResponse();
      });
    });
  }

//  Function to be called when no response is received
  void handleNoResponse() {
    // Calling reconnect API
    Provider.of<CallsController>(context, listen: false).reconnect();
    debugPrint(
        'No response received from WebSocket. Executing fallback function.');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MediaQuery(
      /// Prevents text size from being changed when the system font size is changed
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling,
      ),
      child: MaterialApp(
        title: 'Multicall',
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.lightBlue.shade500,
            cursorColor: Colors.lightBlue.shade200,
            selectionColor: Colors.lightBlue.shade200,
          ),
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.white,
            secondary: const Color.fromRGBO(241, 245, 249, 1),
            outline: const Color.fromRGBO(16, 19, 21, 1),
          ),
          fontFamily: 'Lato',
          textTheme: customTextTheme(),
          checkboxTheme: CheckboxThemeData(
            side: MaterialStateBorderSide.resolveWith(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return const BorderSide(
                    color: Color.fromRGBO(98, 180, 20, 1),
                    width: 1,
                  );
                }
                return const BorderSide(
                  color: Color.fromRGBO(205, 211, 215, 1),
                  width: 1,
                );
              },
            ),
          ),
        ),
        initialRoute: SplashScreen.routeName,
        navigatorObservers: [CustomRouteObserver()],
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
          SignupScreen.routeName: (context) => const SignupScreen(),
          HelpScreen.routeName: (context) => const HelpScreen(),
          AnswerWidget.routeName: (context) => const AnswerWidget(),
          EmailPinVerificationScreen.routeName: (context) =>
              const EmailPinVerificationScreen(),
          MobilePinVerificationScreen.routeName: (context) =>
              const MobilePinVerificationScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          InstantCallScreen.routeName: (context) => const InstantCallScreen(),
          InstantCallScreenCallNow.routeName: (context) =>
              const InstantCallScreenCallNow(),
          ScheduleDialInScreen.routeName: (context) =>
              const ScheduleDialInScreen(),
          ScheduledInvitationScreen.routeName: (context) =>
              const ScheduledInvitationScreen(),
          ScheduleCallScreen.routeName: (context) => const ScheduleCallScreen(),
          CallNowScreen.routeName: (context) => const CallNowScreen(),
          ContactScreen.routeName: (context) => const ContactScreen(
                isFromNewGroupScreen: false,
              ),
          ChooseProfileScreen.routeName: (context) =>
              const ChooseProfileScreen(),
          ChangeNumberScreen.routeName: (context) => const ChangeNumberScreen(),
          CallMeOnScreen.routeName: (context) => const CallMeOnScreen(),
          AddNewProfileScreen.routeName: (context) =>
              const AddNewProfileScreen(),
          AddProfileHelpWidget.routeName: (context) =>
              const AddProfileHelpWidget(),
          AddNewPhoneScreen.routeName: (context) => const AddNewPhoneScreen(),
          SelectDurationScreen.routeName: (context) =>
              const SelectDurationScreen(),
          RepeatCallScreen.routeName: (context) => const RepeatCallScreen(),
          GroupSectionScreen.routeName: (context) => const GroupSectionScreen(),
          PremiumSectionScreen.routeName: (context) =>
              const PremiumSectionScreen(),
          SettingScreen.routeName: (context) => const SettingScreen(),
          AccountScreen.routeName: (context) => const AccountScreen(),
          AddEmailIdScreen.routeName: (context) => const AddEmailIdScreen(),
          VerifyEmailScreen.routeName: (context) => const VerifyEmailScreen(),
          AddPhoneNumberScreen.routeName: (context) =>
              const AddPhoneNumberScreen(
                isFromNewGroupScreen: false,
              ),
          NewGroupScreen.routeName: (context) => const NewGroupScreen(),
          UpdateGroupNameScreen.routeName: (context) =>
              const UpdateGroupNameScreen(),
          PaymentChooseProfileScreen.routeName: (context) =>
              const PaymentChooseProfileScreen(),
          ProfilePlanDetailsScreen.routeName: (context) =>
              const ProfilePlanDetailsScreen(),
          AddOnsScreen.routeName: (context) => const AddOnsScreen(),
          ChoosePlanScreen.routeName: (context) => const ChoosePlanScreen(),
          CallMeOnScreenSettingsScreen.routeName: (context) =>
              const CallMeOnScreenSettingsScreen(),
          AddPhoneNumberDropDownScreen.routeName: (context) =>
              const AddPhoneNumberDropDownScreen(),
          HelpSettingsScreen.routeName: (context) => const HelpSettingsScreen(),
          FAQScreen.routeName: (context) => const FAQScreen(),
          FeedbackScreen.routeName: (context) => const FeedbackScreen(),
          ProfilesScreen.routeName: (context) => const ProfilesScreen(),
          CreateProfileScreen.routeName: (context) =>
              const CreateProfileScreen(),
          AddBusinessProfileScreen.routeName: (context) =>
              const AddBusinessProfileScreen(),
          TermsAndPrivacy.routeName: (context) => const TermsAndPrivacy(),
          AboutTheAppScreen.routeName: (context) => AboutTheAppScreen(),
          BillingScreen.routeName: (context) => const BillingScreen(),
          OrderSummery.routeName: (context) => const OrderSummery(),
          PaymentHistory.routeName: (context) => const PaymentHistory(),
          ProfileDetailsScreen.routeName: (context) =>
              const ProfileDetailsScreen(),
          EditProfileNameScreen.routeName: (context) =>
              const EditProfileNameScreen(),
          EnterprisePlansScreen.routeName: (context) =>
              const EnterprisePlansScreen(),
          RenameScreen.routeName: (context) => const RenameScreen(),
          AddPhoneNumberWithoutLabelScreen.routeName: (context) =>
              const AddPhoneNumberWithoutLabelScreen(),
          PaymentReceiptScreen.routeName: (context) =>
              const PaymentReceiptScreen(),
          TopUpScreen.routeName: (context) => const TopUpScreen(),
        },
      ),
    );
  }
}
