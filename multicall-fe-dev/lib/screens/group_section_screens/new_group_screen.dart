import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/screens/choose_profile_screen.dart';
import 'package:multicall_mobile/screens/contact_screen.dart';
import 'package:multicall_mobile/screens/group_list_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/add_number_to_contact_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/change_number_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/update_group_name_screen.dart';
import 'package:multicall_mobile/screens/settings_section_screens/add_phone_number_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/clickable_row_with_icon.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewGroupScreen extends StatefulWidget {
  static const routeName = '/new_group_screen';

  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  File? _image;
  Profile? selectedProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedProfile =
        Provider.of<ProfileController>(context, listen: false).defaultProfile;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    GroupController groupController =
        Provider.of<GroupController>(context, listen: true);
    groupController.newCreatingGroup ??= Group(
      groupId: 0,
      name: "New Group",
      profileRefNum: selectedProfile?.profileRefNo ?? 1,
      isFavorite: 0,
      members: [],
    );
    Group? newGroupData = groupController.newCreatingGroup;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: Text("New Group"),
      ),
      body: Column(
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
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: size.width,
            height: 40,
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
            color: const Color.fromRGBO(221, 225, 228, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  newGroupData?.name ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                DualToneIcon(
                  iconSrc: PhosphorIconsDuotone.pencilSimpleLine,
                  duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                  color: Colors.black,
                  size: 16,
                  padding: const Padding(padding: EdgeInsets.all(7)),
                  margin: 0,
                  press: () {
                    _navigateAndGetGroupName(newGroupData?.name ?? "");
                  },
                )
              ],
            ),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClickableRowWithIcon(
                      clickFunction: () async {
                        var profile = await Navigator.of(context).pushNamed(
                            ChooseProfileScreen.routeName,
                            arguments: {
                              "selectedProfile": selectedProfile,
                            });
                        if (profile != null) {
                          selectedProfile = profile as Profile;
                          groupController.newCreatingGroup?.profileRefNum =
                              selectedProfile?.profileRefNo ?? 1;
                          setState(() {});
                        }
                      },
                      leftIconClickFunction: () {},
                      leftIcon: PhosphorIconsRegular.info,
                      rightIcon: PhosphorIconsRegular.caretRight,
                      title: selectedProfile?.profileName ?? "Default",
                      subTitle: "(Profile)",
                      toolTipText:
                          "Call size is ${selectedProfile?.profileSize == 0 ? 4 : selectedProfile?.profileSize ?? 4} of this profile",
                    ),
                  ),
                  const Divider(
                    color: Color(0XFFCDD3D7),
                    height: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    child: Row(
                      children: [
                        MultiCallTextWidget(
                          text: "Members-${newGroupData?.members.length ?? 0}",
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
                          margin: 0,
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
                        children:
                            newGroupData!.members.asMap().entries.map((entry) {
                          return memberListCell(entry.value);
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
                left: 24.0,
                right: 24.0,
                top: 12.0,
                bottom: 12.0 + MediaQuery.of(context).padding.bottom,
              ),
              child: TextButtonWithBG(
                title: 'Create',
                action: () {
                  if (groupController.groups
                      .map((e) => e.name.trim())
                      .toList()
                      .contains(newGroupData.name.trim())) {
                    showToast(
                        "Group name already exist, Please enter different name.");
                    return;
                  }

                  var refNo =
                      Provider.of<ProfileController>(context, listen: false)
                          .defaultProfile
                          ?.profileRefNo;
                  //debugPrint("Total Number Of Messages:");
                  // Total Number Of Messages = How many time will you call add member API
                  // If 10 members are there and group size is 2 then call add member API 5 times.
                  // 5 is Total Number Of Messages.

                  newGroupData.profileRefNum = refNo ?? 0;

                  createGroup(newGroupData, _image?.absolute.path);
                },
                isDisabled: newGroupData.members.isEmpty,
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
  }

  Widget memberListCell(GroupMembers member) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () {
            showMemberOptionBottomSheet(member);
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
                    text: (member.memberName ?? "").characters.first,
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
                      text: member.memberName ?? "",
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
              Icon(
                PhosphorIcons.caretRight(),
              )
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

  void showAddMemberBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
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
                                  isFromNewGroupScreen: true)),
                        );
                      },
                      iconData: PhosphorIconsDuotone.addressBook,
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
                      title: "Dial Number",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPhoneNumberScreen(
                              isFromNewGroupScreen: true,
                            ),
                          ),
                        );
                      },
                      iconData: PhosphorIconsDuotone.dotsSix,
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
                      title: "Add Groups",
                      route: "",
                      isClicked: () {
                        Navigator.pop(context);
                        gotoGroupSelectionScreen(context);
                      },
                      iconData: PhosphorIconsDuotone.usersFour,
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

  Future<void> _navigateAndGetGroupName(String groupName) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateGroupNameScreen(
            groupName: groupName,
            isFromCreatingNewGroup: true,
          ),
        ));
  }

  Future<void> removeContact(GroupMembers member) async {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    groupController.removeMemberFromNewGroup(member);
  }

  Future<void> createGroup(Group groupData, String? fileAbsolutePath) async {
    int totalIterations = ((groupData.members.length) / 2).ceil();
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);

    ///Call Create Group API:
    groupController.requestCreateGroup(
      groupData.name,
      groupData.profileRefNum,
      totalIterations,
      groupData.members.length,
    );

    ///Call Add Members API in For Loop number of totalIterations times
    int currentIterationNumber = 1;
    for (var i = 0; i < (groupData.members.length); i += 2) {
      List<GroupMembers> members = [
        GroupMembers(
            memberTelephone: groupData.members.elementAt(i).memberTelephone,
            memberName: groupData.members.elementAt(i).memberName ?? "",
            memberEmail: "")
      ];

      if ((groupData.members.length) > i + 1) {
        members.add(GroupMembers(
            memberTelephone: groupData.members.elementAt(i + 1).memberTelephone,
            memberName: groupData.members.elementAt(i + 1).memberName ?? "",
            memberEmail: ""));
      }

      if ((i == (groupData.members.length) - 1) ||
          (i == (groupData.members.length) - 2)) {
        CreateGroupResponse response =
            await groupController.requestToAddMembersToGroup(
          groupData.name,
          currentIterationNumber,
          members.length,
          members,
        );

        if ((currentIterationNumber == totalIterations) && response.status) {
          // store file path with unique id using PreferenceHelper
          PreferenceHelper.set(
              "GroupPhoto-${response.groupName}", fileAbsolutePath);

          //Group Created Successfully
          groupController.clearAllGroup();
          groupController.getGroupList();
          showToast("Group Created Successfully.");
          final currentContext = navigatorKey.currentContext!;
          if (!currentContext.mounted) return;
          if (Navigator.canPop(currentContext)) {
            Navigator.maybePop(currentContext);
          }
        }
      } else {
        groupController.requestToAddMembersToGroup(
          groupData.name,
          currentIterationNumber,
          members.length,
          members,
        );
      }

      currentIterationNumber++;
    }
  }

  Future<void> _navigateAndChangeNumber(
      BuildContext context, GroupMembers member) async {
    final selectedNumber = await Navigator.pushNamed(
      context,
      ChangeNumberScreen.routeName,
      arguments: {'selectedNumber': member.memberTelephone},
    );
    debugPrint(selectedNumber.toString());
  }

  void gotoAddNumberToContactScreen(GroupMembers member) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNumberToContactScreen(
            groupMember: member,
            isFromCreatingNewGroup: true,
          ),
        ));
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
                    text: member.memberName ?? "",
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
                        removeContact(member);
                        Navigator.pop(context);
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

  void gotoGroupSelectionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupListScreen(
          isFromCreatingNewGroup: true,
        ),
      ),
    );
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
}
