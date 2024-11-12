import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_tab_container.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class MulticallScreen extends StatefulWidget {
  static const routeName = '/multicall_screen';

  const MulticallScreen({super.key});

  @override
  MulticallScreenState createState() => MulticallScreenState();
}

class MulticallScreenState extends State<MulticallScreen> {
  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: SizedBox(
          width: 98,
          height: 36,
          child: SvgPicture.asset(
            'assets/images/multicall_logo_without_tag.svg',
            height: 50,
            width: 100,
          ),
        ),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.youtubeLogo,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              press: () {
                launchURL("https://youtube.com/watch?v=ZaZfWmd6vBc");
              },
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.note,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              press: () async {
                launchURL("https://www.multicall.in/blog/");
              },
            ),
            DualToneIcon(
              iconSrc: PhosphorIconsDuotone.headset,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              press: () {
                launchURL("tel:04446741321");
              },
            ),
          ],
        ),
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: CustomTabContainer(
                onIsEmptyChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _isEmpty = value;
                    });
                  }
                  return value;
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: const Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(205, 211, 215, 1),
                  width: 1,
                ),
              ),
            ),
            child: _isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: RowWithTextButtons(
                      buttonWidth: MediaQuery.of(context).size.width * 0.44,
                      callLaterAction: () {
                        final defaultProfile = Provider.of<ProfileController>(
                                context,
                                listen: false)
                            .defaultProfile;

                        if (defaultProfile?.facilityElement !=
                            AppConstants.allowScheduling) {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return const OnlyPaidDialogue();
                            },
                          );
                          return;
                        } else {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            showDragHandle: false,
                            context: context,
                            builder: (BuildContext context) {
                              return const CallDialTypeSelection();
                            },
                          );
                        }
                      },
                      callNowAction: () {
                        Provider.of<InstantCallProvider>(context, listen: false)
                            .memberList
                            .clear();
                        Navigator.of(context)
                            .pushNamed(CallNowScreen.routeName);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
