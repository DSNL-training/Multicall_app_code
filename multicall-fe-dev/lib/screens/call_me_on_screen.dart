import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_dropdown.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:multicall_mobile/widget/row_option_selection.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class CallMeOnScreen extends StatefulWidget {
  static const routeName = '/call-me-on-screen';

  const CallMeOnScreen({super.key});

  @override
  State<CallMeOnScreen> createState() => _CallMeOnScreenState();
}

class _CallMeOnScreenState extends State<CallMeOnScreen> {
  int selectedPosition = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ModalRoute.of(context)!.settings.arguments;
      if (data == null) {
        selectedPosition = 0;
      } else {
        selectedPosition = (data as Map)['selectedCallMeOnIndex'];
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CallMeOnController>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: CustomAppBar(
            leading: const Text(
              'Call-Me-On',
            ),
            trailing: BorderTextButton(
              title: 'Done',
              action: () {
                Navigator.pop(context, selectedPosition);
              },
              borderColor: const Color.fromRGBO(98, 180, 20, 1),
              textColor: const Color.fromRGBO(98, 180, 20, 1),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CustomStyledContainer(
                    height: double.infinity,
                    width: size.width,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: provider.filteredCallMeOnList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String option =
                                provider.filteredCallMeOnList[index].callMeOn;
                            return OptionSelector(
                              title: option,
                              isSelected: index == selectedPosition,
                              isLeftIconReq: false,
                              clickFunction: () {
                                debugPrint("Option $option selected");
                                selectedPosition = index;
                                setState(() {});
                              },
                              isLastItem: index ==
                                  provider.filteredCallMeOnList.length - 1,
                            );
                          },
                        )),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextButtonWithBG(
                    title: 'Add Phone Number',
                    action: () {
                      final defaultProfile =
                          Provider.of<ProfileController>(context, listen: false)
                              .defaultProfile;

                      if (defaultProfile?.accountType ==
                          AppConstants.retailPrepaid) {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return const OnlyPaidDialogue();
                          },
                        );
                        return;
                      } else {
                        Navigator.pushNamed(
                            context, AddPhoneNumberDropDownScreen.routeName);
                      }
                    },
                    color: const Color.fromRGBO(98, 180, 20, 1),
                    textColor: Colors.white,
                    fontSize: 16,
                    // iconData: iconData,
                    iconColor: Colors.white,
                    width: size.width,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
