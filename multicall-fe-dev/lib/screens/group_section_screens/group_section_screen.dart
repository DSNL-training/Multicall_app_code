import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/controller/profile_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/providers/full_screen_ad_provider.dart';
import 'package:multicall_mobile/providers/home_provider.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/providers/intro_provider.dart';
import 'package:multicall_mobile/screens/group_section_screens/group_details_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/new_group_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class GroupSectionDataModel {
  String title;
  List<Group>? groups;

  GroupSectionDataModel({required this.title, this.groups});
}

class GroupSectionScreen extends StatefulWidget {
  static const routeName = '/groupSection';

  const GroupSectionScreen({super.key});

  @override
  State<GroupSectionScreen> createState() => _GroupSectionScreenState();
}

class _GroupSectionScreenState extends State<GroupSectionScreen> {
  TextEditingController searchController = TextEditingController();
  final List<GroupSectionDataModel> _groupList = [
    GroupSectionDataModel(title: "Favorites", groups: []),
    GroupSectionDataModel(title: "Groups", groups: []),
  ];
  bool isTutorial = false;

  String searchQuery = '';
  Group? loadingGroup;

  Iterable<GroupSectionDataModel> get _filteredGroups {
    var favGroup = _groupList[1]
        .groups
        ?.where((element) =>
            ((element.name.toLowerCase().contains(searchQuery.toLowerCase())) &&
                element.isFavorite == 1))
        .toList();
    var genGroup = _groupList[1]
        .groups
        ?.where((element) =>
            (element.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
                element.isFavorite == 0))
        .toList();

    List<GroupSectionDataModel> finalList = [];

    if ((genGroup?.length ?? 0) > 0) {
      finalList.insert(
          0, GroupSectionDataModel(title: "Groups", groups: genGroup));
    }
    if ((favGroup?.length ?? 0) > 0) {
      finalList.insert(
          0, GroupSectionDataModel(title: "Favorites", groups: favGroup));
    }
    return finalList;
  }

  final List<GroupSectionDataModel> _dummyList = [
    GroupSectionDataModel(
      title: "Favorites",
      groups: [
        Group(
          groupId: 1,
          name: "Favorite Group",
          profileRefNum: 101,
          isFavorite: 1,
          members: [
            GroupMembers(
                memberName: "Member 1",
                memberEmail: 'abc@gmail.com',
                memberTelephone: '123456789'),
          ],
        ),
      ],
    ),
    GroupSectionDataModel(
      title: "Groups",
      groups: [
        Group(
          groupId: 2,
          name: "General Group 1",
          profileRefNum: 102,
          isFavorite: 0,
          members: [
            GroupMembers(
                memberName: "Member 2",
                memberEmail: 'abc@gmail.com',
                memberTelephone: '123456789'),
          ],
        ),
        Group(
            groupId: 3,
            name: "General Group 2",
            profileRefNum: 103,
            isFavorite: 0,
            members: [
              GroupMembers(
                  memberName: "Member 3",
                  memberEmail: 'abc@gmail.com',
                  memberTelephone: '123456789'),
            ]),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    //Call Get Group List API From Here:
    getGroupList();
  }

  void navigateToHomeScreen(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.onItemTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    GroupController groupController =
        Provider.of<GroupController>(context, listen: true);
    List<Group> groups = groupController.groups;
    _groupList.where((element) => element.title == "Groups").first.groups =
        groups;
    IntroProvider introProvider = Provider.of<IntroProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => FullScreenAdProvider(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: CustomAppBar(
            leading: const Text("Groups"),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DualToneIcon(
                  iconSrc: PhosphorIconsDuotone.headset,
                  duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                  color: Colors.black,
                  size: 16,
                  padding: const Padding(padding: EdgeInsets.all(7)),
                  margin: 0,
                  press: () async {
                    launchURL("tel:04446741321");
                  },
                ),
                if (groups.isNotEmpty || !introProvider.watchedIntro)
                  const SizedBox(
                    width: 16,
                  ),
                if (groups.isNotEmpty || !introProvider.watchedIntro)
                  DualToneIcon(
                    key: createGroupButton,
                    iconSrc: PhosphorIconsDuotone.plusCircle,
                    duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
                    color: Colors.black,
                    size: 16,
                    padding: const Padding(padding: EdgeInsets.all(7)),
                    press: () {
                      GroupController groupController =
                          Provider.of<GroupController>(context, listen: false);
                      groupController.newCreatingGroup = null;
                      Navigator.of(context).pushNamed(NewGroupScreen.routeName);
                    },
                    margin: 0,
                  ),
              ],
            ),
            showBackButton: false,
          ),
          body: PopScope(
            canPop: false,
            onPopInvoked: (value) {
              navigateToHomeScreen(context);
              return;
            },
            child: Consumer<IntroProvider>(
                builder: (context, introProvider, child) {
              if (!introProvider.watchedIntro) {
                return dummyUI(size);
              }
              return Consumer<GroupController>(
                builder: (context, groupController, child) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomStyledContainer(
                      width: size.width,
                      height: double.infinity,
                      child: (groupController.getIsGroupFetching)
                          ? const Center(
                              child: SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  )),
                            )
                          : (groups.isNotEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: TextField(
                                          controller: searchController,
                                          onChanged: (val) {
                                            setState(() {
                                              searchQuery = val;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              PhosphorIconsDuotone
                                                  .magnifyingGlass,
                                              size: 20,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Color(0XFFCDD3D7)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Color(0XFFCDD3D7)),
                                            ),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Color(0XFFCDD3D7)),
                                            ),
                                            filled: true,
                                            focusColor: Colors.white,
                                            hintText: "Search",
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          keyboardType: TextInputType.text,
                                          cursorColor: Colors.black,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: _filteredGroups.length,
                                          itemBuilder: (context, index) {
                                            var groupData = _filteredGroups
                                                .elementAt(index);
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MultiCallTextWidget(
                                                  text: _filteredGroups
                                                      .elementAt(index)
                                                      .title,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  textColor: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                                ListView.builder(
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: groupData
                                                          .groups?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var isLastItem = (groupData
                                                                .groups
                                                                ?.length ??
                                                            0) ==
                                                        (index + 1);
                                                    bool isFavorite =
                                                        groupData.title ==
                                                            "Favorites";
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8),
                                                      child: groupListCell(
                                                        groupData.groups
                                                            ?.elementAt(index),
                                                        isLastItem,
                                                        isFavorite,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                groupData.title == "Favorites"
                                                    ? Container(
                                                        width: double.infinity,
                                                        height: 4,
                                                        color: const Color(
                                                            0XFFF1F5F9),
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/groups_section.png',
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(24, 4, 24, 24),
                                      child: GlobalText(
                                        text:
                                            "Start making group calls to connect and share ideas",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        textAlign: TextAlign.center,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                    ),
                                    TextButtonWithBG(
                                      title: 'Add Groups',
                                      action: () {
                                        GroupController groupController =
                                            Provider.of<GroupController>(
                                                context,
                                                listen: false);
                                        groupController.newCreatingGroup = null;
                                        Navigator.of(context).pushNamed(
                                            NewGroupScreen.routeName);
                                      },
                                      iconData: PhosphorIconsBold.plusCircle,
                                      size: 16,
                                      width: 20,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          const Color.fromRGBO(98, 180, 20, 1),
                                    ),
                                  ],
                                ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget dummyUI(Size size) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomStyledContainer(
          width: size.width,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        PhosphorIconsDuotone.magnifyingGlass,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(color: Color(0XFFCDD3D7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(color: Color(0XFFCDD3D7)),
                      ),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide(color: Color(0XFFCDD3D7)),
                      ),
                      filled: true,
                      focusColor: Colors.white,
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _dummyList.length,
                    itemBuilder: (context, index) {
                      var groupData = _dummyList.elementAt(index);
                      return Column(
                        key: (groupData.title == "Favorites" && index == 0)
                            ? favoriteGroup
                            : null,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MultiCallTextWidget(
                            text: _dummyList.elementAt(index).title,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            textColor: Colors.black,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: groupData.groups?.length ?? 0,
                            itemBuilder: (context, index) {
                              var isLastItem =
                                  (groupData.groups?.length ?? 0) ==
                                      (index + 1);
                              bool isFavorite = groupData.title == "Favorites";
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: groupListCell(
                                  groupData.groups?.elementAt(index),
                                  isLastItem,
                                  isFavorite,
                                ),
                              );
                            },
                          ),
                          groupData.title == "Favorites"
                              ? Container(
                                  width: double.infinity,
                                  height: 4,
                                  color: const Color(0XFFF1F5F9),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 8.0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget groupListCell(Group? groupData, bool isLasItem, bool isFavorite) {
    return Consumer<FullScreenAdProvider>(
        builder: (context, adProvider, child) {
      return Column(
        children: [
          InkWell(
            onTap: () {
              if (isFavorite) {
                ///GOTO INSTANT CALL SCREEN
                loadingGroup = groupData;
                setState(() {});
                gotoInstantCallScreen(groupData, adProvider);
              } else {
                ///GOTO GROUP DETAILS SCREEN
                gotoGroupDetailsScreen(groupData);
              }
            },
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                      color: Color(0XFFEDF0F2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        groupData!.name.substring(0, 1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0XFF101315),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    groupData.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0XFF101315),
                    ),
                  ),
                  const Spacer(),
                  loadingGroup != groupData
                      ? customIconButton(
                          key: groupData.groupId == 2 ? editGroupButton : null,
                          size: 24,
                          iconData: PhosphorIcons.caretRight(),
                          onPressed: () {
                            ///GOTO GROUP DETAILS SCREEN
                            gotoGroupDetailsScreen(groupData);
                          },
                        )
                      : Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.grey.shade500,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          !isLasItem
              ? Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0XFFCDD3D7),
                )
              : const SizedBox.shrink(),
        ],
      );
    });
  }

  gotoGroupDetailsScreen(Group? groupData) {
    if (groupData == null) return;
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    groupController.groupInAction = null;
    groupController.groupInAction = groupController.groups
        .where((grp) => grp.groupId == groupData.groupId)
        .first;
    groupController.fetchGroupMembers(groupData.groupId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GroupDetailsScreen(),
      ),
    );
  }

  gotoInstantCallScreen(
      Group? groupData, FullScreenAdProvider adProvider) async {
    if (groupData == null) return;

    Provider.of<GroupController>(context, listen: false)
        .fetchGroupMembers(groupData.groupId)
        .then((value) {
      var groupProfileIndex =
          Provider.of<ProfileController>(context, listen: false)
              .profiles
              .indexWhere((e) => e.profileRefNo == groupData.profileRefNum);

      if (groupProfileIndex == -1) {
        return;
      }

      var groupProfile = Provider.of<ProfileController>(context, listen: false)
          .profiles
          .elementAt(groupProfileIndex);

      List<MemberListModel> memberList = groupData.members
          .map((member) => MemberListModel(
              name: member.memberName ?? "",
              phoneNumber: member.memberTelephone))
          .toList();

      final instantCallProvider =
          Provider.of<InstantCallProvider>(context, listen: false);

      Future.delayed(const Duration(milliseconds: 500), () {
        loadingGroup = null;
        setState(() {});

        /// remove call me on number from memberList
        memberList.removeWhere(
            (element) => element.phoneNumber == groupProfile.profilePhone);

        instantCallProvider.memberList.clear();
        instantCallProvider.addMembers(memberList);
        instantCallProvider.setProfile(groupProfile);
        instantCallProvider.setCallMeOnNumber(groupProfile.profilePhone);

        instantCallProvider.onClickCallNowButton(adProvider);
      });
    });
  }

  Future<void> getGroupList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      GroupController groupController =
          Provider.of<GroupController>(context, listen: false);
      await groupController.fetchGroups();
    });
  }
}
