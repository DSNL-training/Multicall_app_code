import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/screens/group_section_screens/group_members_list_screen.dart';
import 'package:multicall_mobile/screens/group_section_screens/group_section_screen.dart';
import 'package:multicall_mobile/utils/common_widgets.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/common/multicall_search_box_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/text_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class GroupListScreen extends StatefulWidget {
  final bool isFromGroupDetails;
  final bool isFromCreatingNewGroup;
  final bool isFromCallNow;
  final bool isFromScheduleCall;
  final bool isFromCurrentCallingScreen;
  final bool isFromRescheduleScreen;

  const GroupListScreen({
    super.key,
    this.isFromGroupDetails = false,
    this.isFromCreatingNewGroup = false,
    this.isFromCallNow = false,
    this.isFromScheduleCall = false,
    this.isFromCurrentCallingScreen = false,
    this.isFromRescheduleScreen = false,
  });

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<Group> selectedGroupList = [];

  TextEditingController searchController = TextEditingController();
  final List<GroupSectionDataModel> _groupList = [
    GroupSectionDataModel(title: "Groups", groups: []),
  ];

  String searchQuery = '';

  Iterable<GroupSectionDataModel> get _filteredGroups {
    var genGroup = _groupList.first.groups
        ?.where((element) =>
            (element.name.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();

    List<GroupSectionDataModel> finalList = [
      GroupSectionDataModel(title: "Groups", groups: genGroup)
    ];
    return finalList;
  }

  @override
  void dispose() {
    _groupList.clear();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //Call Get Group List API From Here:
    getGroupList();
  }

  @override
  Widget build(BuildContext context) {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: true);
    List<Group> groups = groupController.groups;
    _groupList.where((element) => element.title == "Groups").first.groups =
        groups;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
          leading: const Text("Groups"),
          trailing: (selectedGroupList.isNotEmpty)
              ? InkWell(
                  onTap: () {
                    /// Handles the tap event for adding group members based on the source screen.
                    ///
                    /// This function performs the following steps:
                    /// 1. Checks if the selected group list is empty and shows a toast message if it is.
                    /// 2. Calls the appropriate function based on the source screen:
                    ///    - `addGroupsMembersToEditingGroup` if the source is group details.
                    ///    - `addGroupMembersToNewCreatingGroup` if the source is creating a new group.
                    ///    - `addMembersToInstantCall` if the source is an instant call.
                    ///    - `addMembersToCallingScreen` if the source is the current calling screen.
                    ///    - `addMembersToScheduleCall` if the source is scheduling a call.
                    ///    - `addMembersToRescheduleCall` if the source is rescheduling a call.
                    if (selectedGroupList.isEmpty) {
                      showToast("Please select group.");
                      return;
                    }

                    if (widget.isFromGroupDetails) {
                      addGroupsMembersToEditingGroup();
                    } else if (widget.isFromCreatingNewGroup) {
                      addGroupMembersToNewCreatingGroup();
                    } else if (widget.isFromCallNow) {
                      addMembersToInstantCall();
                    } else if (widget.isFromCurrentCallingScreen) {
                      addMembersToCallingScreen(context);
                    } else if (widget.isFromScheduleCall) {
                      addMembersToScheduleCall();
                    } else if (widget.isFromRescheduleScreen) {
                      addMembersToRescheduleCall(context);
                    }
                  },
                  child: Container(
                    height: 32,
                    width: 66,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        color: const Color(0XFF62B414),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Color(0XFF62B414),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          showBackButton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ((_filteredGroups.first.groups?.length ?? 0) != 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MultiCallSearchBoxWidget(
                          borderColor: const Color(0XFFCDD3D7),
                          hintText: "Search groups",
                          onChanged: (v) {
                            searchQuery = v;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        selectedGroupList.isNotEmpty
                            ? SizedBox(
                                height: 76.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: selectedGroupList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return selectedGroupListCell(entry.value);
                                  }).toList(),
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: selectedGroupList.isNotEmpty ? 24 : 0,
                        ),
                        Container(
                          height: 26,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0XFFEDF0F2),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              MultiCallTextWidget(
                                text: "Groups",
                                textColor: Color(0XFF101315),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                _filteredGroups.first.groups?.length ?? 0,
                            itemBuilder: (context, index) {
                              var isLastItem =
                                  (_filteredGroups.first.groups?.length ?? 0) ==
                                      (index + 1);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: groupListCell(
                                    _filteredGroups.first.groups
                                        ?.elementAt(index),
                                    isLastItem),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: GlobalText(
                      text: "No groups created yet!",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    )),
            ),
          ),
        ),
      ),
    );
  }

  Widget groupListCell(Group? groupData, bool isLasItem) {
    bool isSelectedValue = selectedGroupList.contains(groupData);

    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () {
            //Perform Action When Tap On Cell

            if (selectedGroupList.contains(groupData)) {
              selectedGroupList.remove(groupData);
            } else {
              selectedGroupList.add(groupData!);
            }
            setState(() {});

            GroupController groupController =
                Provider.of<GroupController>(context, listen: false);
            groupController.fetchGroupMembers(groupData?.groupId ?? 0);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: isSelectedValue ? Colors.green : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(
                    width: 2,
                    color: isSelectedValue
                        ? Colors.green
                        : const Color(0XFFEDF0F2),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Color(0XFFEDF0F2),
                ),
                child: Center(
                  child: MultiCallTextWidget(
                    text: (groupData?.name ?? "Group").characters.first,
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
                      text: groupData?.name ?? "",
                      textColor: const Color(0XFF101315),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              customIconButton(
                iconData: PhosphorIcons.caretRight(),
                onPressed: () {
                  fetchMembersAndGotoGroupMemberListScreen(groupData);
                },
              ),
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

  Widget selectedGroupListCell(Group groupData) {
    return SizedBox(
      width: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 60,
            child: Stack(children: [
              Center(
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: Color(0XFFEDF0F2),
                  ),
                  child: Center(
                    child: MultiCallTextWidget(
                      text: groupData.name.characters.first,
                      textColor: const Color(0XFF101315),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -8,
                top: -10,
                child: IconButton(
                  onPressed: () {
                    if (selectedGroupList.contains(groupData)) {
                      selectedGroupList.remove(groupData);
                      setState(() {});
                    }
                  },
                  icon: Container(
                    height: 18,
                    width: 18,
                    decoration: const BoxDecoration(
                      color: Color(0XFF4E5D69),
                      borderRadius: BorderRadius.all(
                        Radius.circular(9.0),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: 16,
                      ),
                    ),
                  ),
                  color: Colors.white,
                ),
              )
            ]),
          ),
          MultiCallTextWidget(
            text: groupData.name,
            textColor: const Color(0XFF101315),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> getGroupList() async {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    await groupController.fetchGroups();
  }

  Future<void> addGroupsMembersToEditingGroup() async {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group tempGroup = groupController.groupInAction!;

    List<GroupMembers> tempMembers = [];

    for (var group in selectedGroupList) {
      tempMembers.addAll(group.members);
    }

    var newMembers =
        tempMembers.map((member) => member.memberTelephone).toList();

    final Set<String> phoneNumbersSet =
        tempGroup.members.map((member) => member.memberTelephone).toSet();

    if (newMembers.length == 1 && phoneNumbersSet.contains(newMembers.first)) {
      showToast("Number Already Added!, Please select different number.");
      return;
    }

    final newMemberCount = tempMembers.length;
    for (var number in newMembers) {
      if (phoneNumbersSet.contains(number)) {
        tempMembers.removeWhere((element) => element.memberTelephone == number);
      }
    }

    if (newMemberCount != tempMembers.length) {
      showToast("Duplicate number found!");
    }

    //IF EDITING THE GROUP:
    tempGroup.members.addAll(tempMembers);
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

    Navigator.pop(context);
  }

  void addGroupMembersToNewCreatingGroup() {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);

    List<GroupMembers> tempMembers = [];
    for (var group in selectedGroupList) {
      tempMembers.addAll(group.members);
    }
    bool status = groupController.addMembersToNewGroup(tempMembers);
    if (status) {
      Navigator.pop(context);
    }
  }

  fetchMembersAndGotoGroupMemberListScreen(Group? groupData) async {
    if (groupData == null) return;
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);

    await groupController.fetchGroupMembers(groupData.groupId);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupMembersListScreen(
          groupData: groupData,
          isFromGroupDetails: widget.isFromGroupDetails,
          isFromCreatingNewGroup: widget.isFromCreatingNewGroup,
          isFromCallNow: widget.isFromCallNow,
          isFromScheduleCall: widget.isFromScheduleCall,
          isFromCurrentCallingScreen: widget.isFromCurrentCallingScreen,
        ),
      ),
    );

    if (result == true) {
      Navigator.pop(context);
    }
  }

  void addMembersToInstantCall() {
    List<GroupMembers> tempMembers = [];
    for (var group in selectedGroupList) {
      tempMembers.addAll(group.members);
    }

    List<MemberListModel> newMembers = [];
    newMembers = tempMembers
        .map((e) => MemberListModel(
            name: e.memberName ?? "", phoneNumber: e.memberTelephone))
        .toList();

    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    bool status = provider.addMembersToCallNow(
        newMembers: newMembers, addToActiveCall: false);
    if (status) {
      Navigator.pop(context);
    }
  }

  void addMembersToCallingScreen(BuildContext context) {
    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    var selectedProfile = provider.selectedProfile;
    int selectedProfileSize = selectedProfile?.profileSize == 0
        ? 4
        : selectedProfile?.profileSize ?? 4;

    List<GroupMembers> tempMembers = [];
    for (var group in selectedGroupList) {
      tempMembers.addAll(group.members);
    }

    List<MemberListModel> newMembers = [];
    newMembers = tempMembers
        .map((e) => MemberListModel(
            name: e.memberName ?? "", phoneNumber: e.memberTelephone))
        .toList();

    int totalMemberLength = provider.memberList.length + newMembers.length;

    if (totalMemberLength > selectedProfileSize) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return MaximumMemberAlertBottomSheet(
            onTapSeePlan: () {
              // GOTO PLAN SCREEN
              debugPrint("On Tap See Plans");
            },
          );
        },
      );
    } else {
      bool status = provider.addMembersToCallNow(
          newMembers: newMembers, addToActiveCall: true);
      if (status) {
        Navigator.pop(context);
      }
    }
  }

  void addMembersToScheduleCall() {
    List<GroupMembers> newMembers = [];
    for (var group in selectedGroupList) {
      newMembers.addAll(group.members);
    }

    var tempMembers = newMembers
        .map((e) => ScheduleCallMember(
            memberName: (e.memberName ?? "").length > 15
                ? (e.memberName ?? "").substring(0, 15)
                : (e.memberName ?? ""),
            memberTelephone: e.memberTelephone,
            memberEmail: ""))
        .toList();

    var provider = Provider.of<CallsController>(context, listen: false);

    bool status =
        provider.addMembersToScheduleCallWithDuplicateCheck(tempMembers);
    if (status) {
      Navigator.pop(context);
    }
  }

  /// Adds members from selected groups to a rescheduled call.
  ///
  /// This function performs the following steps:
  /// 1. Collects all members from the selected groups.
  /// 2. Converts the members to `ScheduleCallMembers` format.
  /// 3. Retrieves the schedule details from the `CallsController` provider.
  /// 4. Calls `addMembersToRescheduleCallWithDuplicateCheck` to add the members, checking for duplicates.
  /// 5. If the operation is successful, navigates back to the previous screen.
  ///
  /// Args:
  ///   context (BuildContext): The build context of the widget.
  ///
  /// Returns:
  ///   Future<void>: A Future that completes when all operations are done.
  Future<void> addMembersToRescheduleCall(BuildContext context) async {
    List<GroupMembers> newMembers = [];
    for (var group in selectedGroupList) {
      newMembers.addAll(group.members);
    }

    var tempMembers = newMembers
        .map((e) => ScheduleCallMembers(
            name: e.memberName ?? "", phone: e.memberTelephone, email: ""))
        .toList();
    var provider = Provider.of<CallsController>(context, listen: false);
    var scheduleDetail = provider
        .mergedScheduleCalls[provider.selectedUpcomingCallPosition]
        .scheduleDetail;

    bool status = await provider.addMembersToRescheduleCallWithDuplicateCheck(
        tempMembers, scheduleDetail);

    if (!context.mounted) return; // Check if the context is still valid

    if (status) {
      Navigator.pop(context);
    }
  }
}
