import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/providers/full_screen_ad_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_me_on_screen.dart';
import 'package:multicall_mobile/screens/choose_profile_screen.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/group_list_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/add_number_to_contact_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/group_details_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/clickable_row_with_icon.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CallNowScreen extends StatefulWidget {
  static const routeName = '/call-now-screen';

  const CallNowScreen({super.key});

  @override
  State<CallNowScreen> createState() => _CallNowScreenState();
}

class _CallNowScreenState extends State<CallNowScreen> {
  var selectedCallMeOnIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final filteredCallMeOnList =
        Provider.of<CallMeOnController>(context, listen: false)
            .filteredCallMeOnList;
    Provider.of<InstantCallProvider>(context, listen: false).setCallMeOnNumber(
        filteredCallMeOnList[selectedCallMeOnIndex].callMeOn);

    debugPrint(
        "Call Me On Number: ${filteredCallMeOnList[selectedCallMeOnIndex].callMeOn}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      var instantCallProvider =
          Provider.of<InstantCallProvider>(context, listen: false);
      if (args == null) {
        var defaultProfile =
            Provider.of<ProfileController>(context, listen: false)
                .defaultProfile;
        instantCallProvider.setProfile(defaultProfile);
      } else {
        instantCallProvider.setProfile((args as Map)['selectedProfile']);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final filteredCallMeOnList =
        Provider.of<CallMeOnController>(context, listen: false)
            .filteredCallMeOnList;

    return ChangeNotifierProvider(
      create: (_) => FullScreenAdProvider(),
      child: Consumer<InstantCallProvider>(
        builder: (context, provider, child) {
          var memberList = provider.memberList;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            appBar: const CustomAppBar(
              leading: Text(
                'Instant Call',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                children: [
                                  ClickableRowWithIcon(
                                    clickFunction: () async {
                                      var profile = await Navigator.of(context)
                                          .pushNamed(
                                              ChooseProfileScreen.routeName,
                                              arguments: {
                                            "selectedProfile":
                                                provider.selectedProfile,
                                          });
                                      if (profile != null) {
                                        provider.setProfile(profile as Profile);
                                        setState(() {});
                                      }
                                    },
                                    leftIconClickFunction: () {},
                                    leftIcon: PhosphorIconsRegular.info,
                                    rightIcon: PhosphorIconsRegular.caretRight,
                                    title:
                                        provider.selectedProfile?.profileName ??
                                            "Default",
                                    subTitle: "(Profile)",
                                    toolTipText:
                                        "Call size is ${provider.selectedProfile?.profileSize == 0 ? 4 : provider.selectedProfile?.profileSize ?? 4} of this profile",
                                  ),
                                  ClickableRowWithIcon(
                                    clickFunction: () async {
                                      if (provider
                                              .selectedProfile?.accountType ==
                                          AppConstants.retailPrepaid) {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const OnlyPaidDialogue();
                                          },
                                        );
                                        return;
                                      } else {
                                        if (filteredCallMeOnList.isNotEmpty) {
                                          var result =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                            CallMeOnScreen.routeName,
                                            arguments: {
                                              "selectedCallMeOnIndex":
                                                  selectedCallMeOnIndex,
                                            },
                                          );
                                          if (result != null) {
                                            setState(() {
                                              /// member list must not contain call-me-on number
                                              final memberIndex = memberList
                                                  .indexWhere((element) =>
                                                      element.phoneNumber ==
                                                      filteredCallMeOnList[
                                                              int.parse(result
                                                                  .toString())]
                                                          .callMeOn);
                                              if (memberIndex == -1) {
                                                selectedCallMeOnIndex =
                                                    int.parse(
                                                        result.toString());
                                                provider.setCallMeOnNumber(
                                                    filteredCallMeOnList[
                                                            selectedCallMeOnIndex]
                                                        .callMeOn);
                                              } else {
                                                showToast(
                                                    "This number is already added as a participant! Please choose a different number.");
                                              }
                                            });
                                          }

                                          debugPrint("$selectedCallMeOnIndex");
                                        }
                                      }
                                    },
                                    rightIcon: PhosphorIconsRegular.caretRight,
                                    toolTipText: "Select your profile",
                                    title: filteredCallMeOnList[
                                            selectedCallMeOnIndex]
                                        .callMeOn,
                                    subTitle: "(Call-Me-On)",
                                  ),
                                ],
                              ),
                            ),
                            const HorizontalDivider(),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Row(
                                children: [
                                  MultiCallTextWidget(
                                    text: "Members-${memberList.length}",
                                    textColor: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const Spacer(),
                                  DualToneIcon(
                                    iconSrc: PhosphorIconsDuotone.plusCircle,
                                    duotoneSecondaryColor:
                                        const Color.fromRGBO(0, 134, 181, 1),
                                    color: Colors.black,
                                    size: 16,
                                    margin: 7,
                                    padding: const Padding(
                                        padding: EdgeInsets.all(7)),
                                    press: () {
                                      showAddMemberOptionBottomSheet(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ListView(
                                  children:
                                      memberList.asMap().entries.map((entry) {
                                    MemberListModel member = entry.value;
                                    return memberListCell(
                                        member, context, provider);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<FullScreenAdProvider>(
                      builder: (context, adProvider, child) {
                        return Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 24.0,
                              right: 24.0,
                              top: 12.0,
                              bottom:
                                  12.0 + MediaQuery.of(context).padding.bottom,
                            ),
                            child: TextButtonWithBG(
                              title: 'Call Now',
                              action: () async {
                                provider.onClickCallNowButton(adProvider);
                              },
                              color: const Color.fromRGBO(98, 180, 20, 1),
                              textColor: Colors.white,
                              fontSize: 16,
                              // iconData: iconData,
                              iconColor: Colors.white,
                              width: size.width,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                if (provider.callStatus == InstantCallStatus.dialing ||
                    provider.callStatus == InstantCallStatus.initiated)
                  Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget memberListCell(
    MemberListModel member,
    BuildContext context,
    InstantCallProvider provider,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () {
            showMemberOptionBottomSheet(member, provider);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Color(0XFFEDF0F2),
                ),
                child: Center(
                  child: MultiCallTextWidget(
                    text: member.name.characters.first,
                    textColor: const Color(0XFF101315),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: MultiCallTextWidget(
                      text: member.name,
                      textColor: const Color(0XFF101315),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 16,
                    child: MultiCallTextWidget(
                      text: member.phoneNumber,
                      textColor: const Color(0XFF6E7A84),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              customIconButton(
                iconData: PhosphorIcons.caretRight(),
                onPressed: () {
                  showMemberOptionBottomSheet(member, provider);
                },
              ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.delete_outline,
              //     color: Colors.red,
              //   ),
              //   onPressed: () {
              //     Provider.of<InstantCallMemberListProvider>(context,
              //             listen: false)
              //         .removeMember(member.phoneNumber);
              //   },
              // ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        const Divider(
          color: Color(0XFFCDD3D7),
          height: 1,
        ),
      ],
    );
  }

  void showMemberOptionBottomSheet(
    MemberListModel member,
    InstantCallProvider provider,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: member.name == "Unknown" ? 298 : 230,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  height: 16,
                ),
                MultiCallTextWidget(
                  text: member.name == "Unknown"
                      ? member.phoneNumber
                      : member.name,
                  textColor: const Color(0XFF101315),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Call",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      //PERFORM PHONE CALL
                      makePhoneCall(member.phoneNumber);
                    },
                    iconData: PhosphorIconsDuotone.phoneCall,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Color(0XFFDDE1E4),
                ),
                member.name == "Unknown"
                    ? SizedBox(
                        height: 70,
                        child: NavigatorOption(
                          title: "Add to contact",
                          route: "",
                          isClicked: () {
                            Navigator.pop(context);

                            /// Add number to Device Contacts
                            gotoAddNumberToContactScreen(member);
                          },
                          iconData: PhosphorIconsDuotone.addressBook,
                          duotoneSecondaryColor:
                              const Color.fromRGBO(0, 134, 181, 1),
                          color: Colors.black,
                          size: 24,
                        ),
                      )
                    : const SizedBox.shrink(),
                member.name == "Unknown"
                    ? const Divider(
                        height: 1,
                        color: Color(0XFFDDE1E4),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Remove",
                    route: "",
                    isClicked: () {
                      provider.removeMember(member.phoneNumber);
                      Navigator.pop(context);
                    },
                    iconData: PhosphorIconsDuotone.trash,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAddMemberOptionBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 260,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Contacts",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactScreen(
                            isFromCallNowScreen: true,
                          ),
                        ),
                      );
                    },
                    iconData: PhosphorIconsDuotone.addressBook,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Color(0XFFDDE1E4),
                ),
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Add Groups",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      gotoGroupSelectionScreen(context);
                    },
                    iconData: PhosphorIconsDuotone.usersFour,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Color(0XFFDDE1E4),
                ),
                SizedBox(
                  height: 70,
                  child: NavigatorOption(
                    title: "Dial Number",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPhoneNumberScreen(
                            buttonTitle: "Add",
                            isFromCallNow: true,
                          ),
                        ),
                      );
                    },
                    iconData: PhosphorIconsDuotone.dotsSix,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void gotoGroupSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupListScreen(
          isFromCallNow: true,
        ),
      ),
    );
  }

  void gotoAddNumberToContactScreen(MemberListModel member) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNumberToContactScreen(
            member: member,
            isFromCallNow: true,
          ),
        ));
  }
}
