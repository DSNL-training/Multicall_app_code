import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FAQScreen extends StatelessWidget {
  static const String routeName = '/faq-screen';

  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text(
          "FAQ's",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomStyledContainer(
          width: size.width,
          height: double.infinity,
          child: ListView(
            children: [
              FAQSection(
                sectionTitle: 'App Installation and Registration',
                faqList: appInstallAndReg,
              ),
              FAQSection(
                sectionTitle: 'Making calls on the app',
                faqList: makingCallOnApp,
              ),
              FAQSection(
                sectionTitle: 'Corporate customers',
                faqList: corporateCustomers,
              ),
              FAQSection(
                sectionTitle: 'Individual customers',
                faqList: individualCustomers,
              ),
              FAQSection(
                sectionTitle: 'Groups',
                faqList: groups,
              ),
              FAQSection(
                sectionTitle: 'Other features',
                faqList: otherFeatures,
              ),
              // Add more FAQSections for other sections
            ],
          ),
        ),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  final String sectionTitle;
  final List<Map<String, String>> faqList;

  const FAQSection({
    super.key,
    required this.sectionTitle,
    required this.faqList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FAQTile(
                    question: faqList[index]['question']!,
                    answer: faqList[index]['answer']!,
                    number: index + 1,
                  ),
                  if (index !=
                      faqList.length - 1) // Check if it is not the last item
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromRGBO(205, 211, 215, 1),
                                width:
                                    1.0, // You can adjust the width as needed
                              ),
                            ),
                          ),
                        )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FAQTile extends StatefulWidget {
  final String question;
  final String answer;
  final int number;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
    required this.number,
  });

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      visualDensity: VisualDensity.comfortable,
      shape: Border.all(width: 0, color: Colors.transparent),
      iconColor: Colors.red,
      expandedAlignment: Alignment.centerLeft,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.number}. ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              ' ${widget.question}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      // trailing:
      // IconWithBorder(
      //   icon:
      //       isExpanded ? PhosphorIconsRegular.minus : PhosphorIconsRegular.plus,
      //   color: Colors.black,
      //   onClick: () {},
      // ),
      trailing: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: const Color.fromRGBO(205, 211, 215, 1),
          ),
        ),
        child: Center(
          child: Icon(
            isExpanded ? PhosphorIconsRegular.minus : PhosphorIconsRegular.plus,
            color: Colors.black,
            size: 12,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(17.0, 0, 16, 8),
          child: Text(
            widget.answer,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(110, 122, 132, 1),
            ),
          ),
        ),
      ],
      onExpansionChanged: (expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
    );
  }
}

final List<Map<String, String>> appInstallAndReg = [
  {
    'question': 'What is my account ID and password?',
    'answer':
        'Your app has a one-time registration process that is linked to the email ID and phone number that you entered at sign-up (the first time you used the app). The app will always be logged in on your phone. There are no troublesome passwords or IDs you need to remember.',
  },
  {
    'question':
        'I need to install MultiCall on my new device. How do I link it to my old account?',
    'answer':
        'Download the app onto your new phone. At the registration screen, simply enter the registered phone number and email ID of your existing MultiCall account. You will have to validate your details (via OTPs) and then you will be logged into your MultiCall account, with all your profile information and groups. \nPlease note that you need access to your registered phone number and email ID to validate your account.',
  },
  {
    'question':
        'I am changing my registered phone number. Will this affect my MultiCall account?',
    'answer':
        'If you are changing your registered phone number, please write to us at support@MultiCall.in for a call-back or call us at 044 71 26 26 26.',
  },
];

final List<Map<String, String>> makingCallOnApp = [
  {
    'question': 'How do I start calling people?',
    'answer':
        'Calling people is extremely easy with MultiCall. You need to create/ add a profile so we know how to bill you for the calls you are going to make. Then you just need to go to the “MultiCalls” tab and press “Call Now”',
  },
  {
    'question': 'What are profiles? How can I create one?',
    'answer':
        'Profiles are basically linked to the way you pay for each call. Each profile can also be linked to different email IDs/ phone numbers (your work email or your personal email, for example). This makes it easy for you to track the calls you make for different purposes separately.\nYou can add a profile to your account if your company has a MultiCall subscription or you could just create a Personal Profile for your calls. Please write to your company administrator or contact us at support@MultiCall.in if you would like more information',
  },
  {
    'question': 'How many people can I call at one time?',
    'answer':
        'The call size varies based on your Profile. Please check your Profile details to see the call size of each Profile.',
  },
  {
    'question':
        'Do I need to be connected to the internet to make/ receive a call?',
    'answer':
        'You will need a basic internet connection to set up a MultiCall. However, to actually start/ be on the call, you don’t need to be connected. So, if you anticipate having to make a MultiCall when you don’t have mobile data, just schedule one ahead of time (and make sure you set the call to “Auto-Initiate”). At the specified time, your participants and you will receive a call',
  },
  {
    'question':
        'Why do my invitees not receive a call from my number? Which number will my invitees receive a call from?',
    'answer':
        'MultiCall uses a server to call everyone you have invited instantly so there is no time wasted and everyone is connected at the same time. This means that your invitees will receive a call from the server’s number, and not from your phone.',
  },
  {
    'question':
        'I pressed “Call” for an instant call but I can’t hear anything on my phone. Why?',
    'answer':
        'When you start an Instant Call, the MultiCall server calls you first and once you are connected the server will call all your invitees. You will receive a call from our server a few seconds after you press “Call”. If you do not receive a call after 2 minutes, please check your connectivity and try again. If the problem persists, please contact us at support@MultiCall.in',
  },
];

final List<Map<String, String>> corporateCustomers = [
  {
    'question': 'My company has subscribed to MultiCall. How can I use it?',
    'answer':
        'You would have received an email with your corporate MultiCall Code that had been generated by your company’s administrative head. You will then need to add a profile using this PIN and your corporate mail ID and phone number. For more information, contact your administrative head or write to us at support@MultiCall.in specifying your company details and your contact details.',
  },
  {
    'question': 'How much does one call cost? How can I pay for a call?',
    'answer':
        'MultiCall is currently available for the corporate customers in a postpaid or prepaid model of billing. Calls made through MultiCall will be charged as per the corporate subscription plan. Refer the MultiCall website for details of various plans. You can also contact your Administrative head for details. If you need further details on all available plans and rates, please write to us at support@MultiCall.in or call us at +91 44 71 26 26 26',
  },
  {
    'question': 'Can MultiCall access my company’s corporate directory?',
    'answer':
        'MultiCall can only access contacts stores in your phone’s address book. To get access to corporate contacts in your MultiCall app, you need to add them to your phone’s address book first.',
  },
  {
    'question': 'Can I use MultiCall to reach people not in my company?',
    'answer':
        'Yes, you can use MultiCall to reach anyone in your phone book. Your invitees need not have the MultiCall app or a MultiCall account to receive calls from you.',
  },
];
final List<Map<String, String>> individualCustomers = [
  {
    'question': 'How can I get an individual MultiCall account?',
    'answer':
        'Individual customers can buy MultiCall from the app itself. The plans for Personal Profiles are listed under the “Payments” section of the app. Only Prepaid plans are available for individual Users. Visit the website to know more about the plans and its terms and conditions. If you still need more information, please write to us at support@MultiCall.in.',
  },
  {
    'question': 'How can I know my call cost?',
    'answer':
        'You will see a history details for all the calls you make through MultiCall. The Call history for each call will show the Call cost for that MultiCall.',
  },
  {
    'question': 'Why do I see Overdue charges in my Profile?',
    'answer':
        'For better customer experience we do not close a MultiCall abruptly due to low balance. When the balance starts running low, you will see an in-app notification informing you the same. The call will be allowed to overrun upto a threshold and only beyond which the MultiCall will be closed. In such cases the Profile will be in negative balance',
  },
  {
    'question': 'Can I use MultiCall without buying a plan?',
    'answer':
        'MultiCall lets you use your Personal Profile to call up-to four members for free when you don’t have a paid plan. This is a limited period launch offer and the company reserves the rights to withdraw this offer without any prior notice',
  },
];
final List<Map<String, String>> groups = [
  {
    'question': 'How do I create a group?',
    'answer':
        'Go to the groups tab and click on the “+” button. Add a group name and the list of members you would like to call. You can now start making calls to this group. If you need further assistance, check out the groups tutorial in the help screen.',
  },
  {
    'question': 'How many people can I add to a group?',
    'answer': 'You can add up to 24 members to a group.',
  },
  {
    'question': 'Why should I link a profile with a group?',
    'answer':
        'Linking a group with a specific profile means that all calls made to that group will automatically be charged to the linked profile. By linking it, you can also make the group a favourite and enable one-touch calling from the “Favourites” tab.',
  },
];
final List<Map<String, String>> otherFeatures = [
  {
    'question':
        'What is a “Call-Me-On” number? How do I change my “Call-Me-On” number?',
    'answer':
        'When you set up a call, the MultiCall server will dial you and all your invitees. Your Call-Me-On number is how the server reaches you. Your default Call-Me-On is your registered phone number, and you can change this at any time in your MultiCall setting. Call-Me-Ons do not require any verification so you can make any number your Call-Me-On based on your convenience (your office desk number or even the number of your hotel room when you’re on the road). You can add a maximum of 8 numbers to your call-me-on list. You can delete unwanted numbers in case you need to add more than 8 numbers.',
  },
  {
    'question':
        'Can I link my MultiCall account to multiple email IDs/ phone numbers? How?',
    'answer':
        'Yes, you can link up to five email IDs or phone numbers to a single MultiCall account. Simply add an email ID (or phone number) under your account settings in the MultiCall app. You will need to verify the new email ID once and it will be linked to your account.',
  },
  {
    'question': 'Can I add someone to an ongoing MultiCall?',
    'answer':
        'Yes, you can add a participant to an ongoing MultiCall that you initiated. When the call is going on, click on the “Active Call” row in your app. You will see all the participants in your current call. Simply tap on the add contacts button and select the person you want to add. A call will go out immediately and he/she will be added to you call.',
  },
];
