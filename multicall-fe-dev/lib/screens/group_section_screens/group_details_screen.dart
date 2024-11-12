import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now_screen.dart';
import 'package:multicall_mobile/screens/choose_profile_screen.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/group_list_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/add_number_to_contact_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/change_number_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/update_group_name_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/call_dial_type_selection.dart';
import 'package:multicall_mobile/widget/common/multicall_outline_button_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/icon_with_border.dart';
import 'package:multicall_mobile/widget/only_paid_dialogue.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  File? _image;
  String strProfileName = "Default profile (Optional)";
  Group? group;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (PreferenceHelper.get("GroupPhoto-${group?.name}") != null) {
        _image = File(PreferenceHelper.get("GroupPhoto-${group?.name}"));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    GroupController groupController = context.watch<GroupController>();
    group = groupController.groupInAction;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: Text(group?.name ?? ""),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconWithBorder(
              icon: group?.isFavorite == 1
                  ? PhosphorIconsFill.heart
                  : PhosphorIconsDuotone.heart,
              onClick: () => setState(() {
                //group?.isFavorite = group?.isFavorite == 1 ? 0 : 1;

                addOrRemoveGroupAsFavorite(group?.name ?? '');
              }),
              color: group?.isFavorite == 1 ? Colors.red : Colors.black,
            ),
            const SizedBox(
              width: 16,
            ),
            DualToneIcon(
              margin: 0,
              iconSrc: PhosphorIconsDuotone.dotsThreeCircle,
              duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
              color: Colors.black,
              size: 16,
              padding: const Padding(padding: EdgeInsets.all(7)),
              press: () {
                showGroupOptionBottomSheet(group?.name ?? "");
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/default_image.png')
                              as ImageProvider<Object>,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                          PreferenceHelper.set(
                              "GroupPhoto-${group?.name}", pickedFile.path);
                        });
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          PhosphorIconsFill.camera,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text('Edit',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Row(
                        children: [
                          MultiCallTextWidget(
                            text: "Members-${group?.members.length ?? 0}",
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
                            padding: const Padding(padding: EdgeInsets.all(7)),
                            press: () {
                              showAddMemberBottomSheet();
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView(
                          children: (group?.members ?? [])
                              .asMap()
                              .entries
                              .map((entry) {
                            GroupMembers member = entry.value;
                            return memberListCell(member);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: MultiCallOutLineButtonWidget(
                          text: "Call Later",
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          borderColor: const Color(0XFF62B414),
                          backgroundColor: const Color(0XFFDAEFC6),
                          textColor: const Color(0XFF62B414),
                          borderRadius: 8,
                          iconData: null,
                          iconSize: 20,
                          iconColor: const Color(0XFF62B414),
                          onTap: () {
                            final defaultProfile =
                                Provider.of<ProfileController>(context,
                                        listen: false)
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
                              //CALL LATER FUNCTIONALITY
                              Provider.of<CallsController>(context,
                                      listen: false)
                                  .clearMembers();
                              for (var member in group!.members) {
                                Provider.of<CallsController>(context,
                                        listen: false)
                                    .addMember(
                                  ScheduleCallMember(
                                    memberName: member.memberName ?? "",
                                    memberTelephone: member.memberTelephone,
                                    memberEmail: "",
                                  ),
                                );
                              }

                              showModalBottomSheet<void>(
                                isScrollControlled: true,
                                showDragHandle: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return const CallDialTypeSelection(
                                    isFromGroupDetails: true,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: MultiCallOutLineButtonWidget(
                          text: "Call Now",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textColor: Colors.white,
                          borderRadius: 8,
                          backgroundColor: const Color(0XFF62B414),
                          borderColor: const Color(0XFF62B414),
                          iconData: PhosphorIconsLight.phoneCall,
                          iconSize: 20,
                          iconColor: Colors.white,
                          onTap: () {
                            //CALL NOW FUNCTIONALITY

                            Provider.of<InstantCallProvider>(context,
                                    listen: false)
                                .memberList
                                .clear();
                            for (var member in group!.members) {
                              Provider.of<InstantCallProvider>(context,
                                      listen: false)
                                  .addMember(
                                MemberListModel(
                                  name: member.memberName ?? "",
                                  phoneNumber: member.memberTelephone,
                                ),
                              );
                            }

                            final profileProvider =
                                Provider.of<ProfileController>(context,
                                    listen: false);
                            var profileIndex = profileProvider.profiles
                                .indexWhere((element) =>
                                    element.profileRefNo ==
                                    group?.profileRefNum);

                            if (profileIndex != -1) {
                              var profile =
                                  profileProvider.profiles[profileIndex];
                              Navigator.of(context).pushNamed(
                                  CallNowScreen.routeName,
                                  arguments: {
                                    "selectedProfile": profile,
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget memberListCell(GroupMembers member) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
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
                  text: (member.memberName ?? "").isEmpty
                      ? ""
                      : member.memberName![0],
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
                    text: (member.memberName ?? "").isEmpty
                        ? "User"
                        : member.memberName ?? "",
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
                    text: member.memberTelephone,
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
                showMemberOptionBottomSheet(member);
              },
            ),
          ],
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

  void showAddMemberBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 280,
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
                            isFromNewGroupScreen: false,
                            isFromGroupDetailsScreen: true,
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
                    title: "Dial Number",
                    route: "",
                    isClicked: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPhoneNumberScreen(
                                  isFromGroupDetails: true,
                                )),
                      );
                    },
                    iconData: PhosphorIconsDuotone.dotsSix,
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
              ],
            ),
          ),
        );
      },
    );
  }

  void showGroupOptionBottomSheet(String groupName) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                      title: "Change Profile",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);
                        //PERFORM CHANGE PROFILE FUNCTIONALITY
                        _navigateAndGetSelectedProfile(context);
                      },
                      iconData: PhosphorIconsDuotone.userCircle,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
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
                      title: "Change Group Name",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);

                        // OPEN Change Group Name Screen

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateGroupNameScreen(
                                    isFromEditGroupName: true,
                                    groupName: groupName,
                                  )),
                        );
                      },
                      iconData: PhosphorIconsDuotone.pencilSimpleLine,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
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
                      title: "Delete Group",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);

                        // OPEN DELETE CONFIRMATION BOTTOM SHEET
                        showDeleteGroupConfirmationBottomSheet(groupName);
                      },
                      iconData: PhosphorIconsDuotone.trash,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void showDeleteGroupConfirmationBottomSheet(String groupName) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                  const SizedBox(
                    height: 24,
                  ),
                  const MultiCallTextWidget(
                    text: "Are you sure to delete this group?",
                    textColor: Color(0XFF101315),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0XFFDDE1E4),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: MultiCallOutLineButtonWidget(
                              text: "Cancel",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              borderColor: const Color(0XFFDDE1E4),
                              textColor: const Color(0XFF101315),
                              borderRadius: 8,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: MultiCallOutLineButtonWidget(
                              text: "Delete",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                              borderRadius: 8,
                              backgroundColor: const Color(0XFFFF6666),
                              borderColor: const Color(0XFFFF6666),
                              onTap: () {
                                Navigator.pop(context);
                                //Call Delete API Here:
                                deleteGroup(groupName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void showMemberOptionBottomSheet(GroupMembers member) {
    bool isUnknown =
        (member.memberName == "Unknown" || member.memberName == null);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                    text: member.memberName == "Unknown"
                        ? member.memberTelephone
                        : member.memberName ?? "",
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
                        makePhoneCall(member.memberTelephone);
                      },
                      iconData: PhosphorIconsDuotone.phoneCall,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Color(0XFFDDE1E4),
                  ),
                  isUnknown
                      ? SizedBox(
                          height: 70,
                          child: NavigatorOption(
                            title:
                                isUnknown ? "Add to contact" : "Change Number",
                            route: "",
                            isClicked: () {
                              Navigator.pop(context);
                              if (isUnknown) {
                                gotoAddNumberToContactScreen(member);
                              } else {
                                _navigateAndChangeNumber(context, member);
                              }
                            },
                            iconData: isUnknown
                                ? PhosphorIconsDuotone.addressBook
                                : PhosphorIconsDuotone.shuffle,
                            duotoneSecondaryColor:
                                const Color.fromRGBO(0, 134, 181, 1),
                            color: Colors.black,
                            size: 24,
                          ),
                        )
                      : const SizedBox.shrink(),
                  isUnknown
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
                        Navigator.pop(context);
                        // PERFORM REMOVE GROUP MEMBER API
                        if ((group?.members.length ?? 0) > 1) {
                          showRemoveMemberConfirmationBottomSheet(member);
                        } else {
                          showToast("A group must have at-least one member.");
                        }
                      },
                      iconData: PhosphorIconsDuotone.trash,
                      duotoneSecondaryColor:
                          const Color.fromRGBO(0, 134, 181, 1),
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void showRemoveMemberConfirmationBottomSheet(GroupMembers member) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    bottom: 12 + MediaQuery.of(context).padding.bottom),
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
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: MultiCallTextWidget(
                        text:
                            "Are you sure to remove ${member.memberName == "Unknown" ? member.memberTelephone : member.memberName} from this group?",
                        textColor: const Color(0XFF101315),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0XFFDDE1E4),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: MultiCallOutLineButtonWidget(
                                text: "Cancel",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                borderColor: const Color(0XFFDDE1E4),
                                textColor: const Color(0XFF101315),
                                borderRadius: 8,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: MultiCallOutLineButtonWidget(
                                text: "Remove",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: Colors.white,
                                borderRadius: 8,
                                backgroundColor: const Color(0XFFFF6666),
                                borderColor: const Color(0XFFFF6666),
                                onTap: () {
                                  Navigator.pop(context);
                                  //Call Remove Member API Here:
                                  removeMemberFromGroup(member);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void gotoAddNumberToContactScreen(GroupMembers member) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNumberToContactScreen(
            groupMember: member,
            isFromEditGroupDetails: true,
          ),
        ));
  }

  Future<void> _navigateAndGetSelectedProfile(BuildContext context) async {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group group = groupController.groupInAction!;

    var groupProfile = Provider.of<ProfileController>(context, listen: false)
        .profiles
        .firstWhere(
          (element) => element.profileRefNo == group.profileRefNum,
          orElse: () => Provider.of<ProfileController>(context, listen: false)
              .profiles[0],
        );

    final profile = await Navigator.pushNamed(
        context, ChooseProfileScreen.routeName,
        arguments: {
          "selectedProfile": groupProfile,
        });

    if (profile != null) {
      group.profileRefNum = (profile as Profile).profileRefNo;
      int totalIterations = (group.members.length / 2).ceil();

      groupController.requestToEditGroupDetails(
        groupMemberCount: group.members.length,
        oldGroupName: group.name,
        newGroupName: group.name,
        profileRefNumber: group.profileRefNum,
        totalIterations: totalIterations,
      );
      groupController.requestToEditGroupMembers(
        group.name,
        group.name,
        group.members,
      );
    }
  }

  Future<void> _navigateAndChangeNumber(
      BuildContext context, GroupMembers member) async {
    final selectedNumber = await Navigator.pushNamed(
      context,
      ChangeNumberScreen.routeName,
      arguments: {'selectedNumber': member.memberTelephone},
    );

    try {
      if (!mounted) return;
      GroupController groupController =
          Provider.of<GroupController>(context, listen: false);

      Group group = groupController.groupInAction!;
      int totalIterations = (group.members.length / 2).ceil();

      groupController.requestToEditGroupDetails(
        groupMemberCount: group.members.length,
        oldGroupName: group.name,
        newGroupName: group.name,
        profileRefNumber: group.profileRefNum,
        totalIterations: totalIterations,
      );
      groupController.requestToEditGroupMembers(
        group.name,
        group.name,
        group.members
            .map((m) => m.memberTelephone == selectedNumber ? member : m)
            .toList(),
      );
    } catch (e) {
      debugPrint('reason ${e.toString()}');
    }
  }

  Future<void> deleteGroup(String groupName) async {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);

    DeleteGroupResponse response =
        await groupController.requestDeleteGroup(groupName);

    if (response.status) {
      showToast("Group Deleted Successfully.");
      groupController.clearAllGroup();
      groupController.getGroupList();
      Navigator.pop(context);
    }
  }

  Future<void> addOrRemoveGroupAsFavorite(String groupName) async {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    var profileRefNo = Provider.of<ProfileController>(context, listen: false)
        .defaultProfile
        ?.profileRefNo;

    MakeGroupFavoriteResponse response;

    if (groupController.groupInAction?.isFavorite == 0) {
      response = await groupController.requestMakeFavoriteGroup(
          groupName, profileRefNo!);
    } else {
      response = await groupController.requestRemoveFavoriteGroup(groupName);
    }

    if (response.status) {
      if (response.reactionType == 115) {
        showToast("Group Marked as Favorite.");
        groupController.groupInAction?.isFavorite = 1;
      } else if (response.reactionType == 116) {
        showToast("Group Removed from Favorite.");
        groupController.groupInAction?.isFavorite = 0;
      }
      groupController.clearAllGroup();
      groupController.getGroupList();
      setState(() {});
    }
  }

  removeMemberFromGroup(GroupMembers member) {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group activeGroup = groupController.groupInAction!;
    Group tempGroup = activeGroup;
    tempGroup.members.removeWhere(
        (element) => element.memberTelephone == member.memberTelephone);
    int totalIterations = (tempGroup.members.length / 2).ceil();

    groupController.requestToEditGroupDetails(
      groupMemberCount: tempGroup.members.length,
      oldGroupName: tempGroup.name,
      newGroupName: tempGroup.name,
      profileRefNumber: tempGroup.profileRefNum,
      totalIterations: totalIterations,
    );

    groupController.requestToEditGroupMembers(
      tempGroup.name,
      tempGroup.name,
      tempGroup.members,
    );
  }

  void gotoGroupSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupListScreen(
          isFromGroupDetails: true,
        ),
      ),
    );
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri url = Uri(
    scheme: "tel",
    path: phoneNumber,
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    showToast("Cannot make this call");
  }
}
