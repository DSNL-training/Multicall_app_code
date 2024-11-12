import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/calls_controller.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/screens/call_now/maximum_member_alert_bottomsheet.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/common/multicall_search_box_widget.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class GroupMembersListScreen extends StatefulWidget {
  Group groupData;
  bool isFromGroupDetails;
  bool isFromCreatingNewGroup;
  bool isFromCallNow;
  bool isFromScheduleCall;
  bool isFromCurrentCallingScreen;

  GroupMembersListScreen({
    super.key,
    required this.groupData,
    this.isFromGroupDetails = false,
    this.isFromCreatingNewGroup = false,
    this.isFromCallNow = false,
    this.isFromScheduleCall = false,
    this.isFromCurrentCallingScreen = false,
  });

  @override
  State<GroupMembersListScreen> createState() => _GroupMembersListScreenState();
}

class _GroupMembersListScreenState extends State<GroupMembersListScreen> {
  List<GroupMembers> selectedMembersList = [];

  TextEditingController searchController = TextEditingController();
  List<GroupMembers> _memberList = [];
  String searchQuery = '';

  Iterable<GroupMembers> get _filteredMembers {
    return _memberList
        .where((element) => (element.memberName!
            .toLowerCase()
            .contains(searchQuery.toLowerCase())))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: true);
    _memberList = groupController.groups
        .where((element) => element.groupId == widget.groupData.groupId)
        .first
        .members;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
          leading: Text(widget.groupData.name),
          trailing: (selectedMembersList.isNotEmpty)
              ? InkWell(
                  onTap: () {
                    debugPrint("Done...");
                    //ON TAP DONE BUTTON
                    if (selectedMembersList.isNotEmpty &&
                        widget.isFromGroupDetails) {
                      addMembersToEditingGroup();
                    } else if (selectedMembersList.isNotEmpty &&
                        widget.isFromCreatingNewGroup) {
                      addMembersToNewCreatingGroup();
                    } else if (selectedMembersList.isNotEmpty &&
                        widget.isFromCallNow) {
                      addMembersToInstantCall();
                    } else if (selectedMembersList.isNotEmpty &&
                        widget.isFromCurrentCallingScreen) {
                      //Add Members to Currently Calling Screen
                      addMembersToCallingScreen(context);
                    } else if (selectedMembersList.isNotEmpty &&
                        widget.isFromScheduleCall) {
                      addMembersToScheduleCall();
                    } else {
                      showToast("Please select member.");
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MultiCallSearchBoxWidget(
                    borderColor: const Color(0XFFCDD3D7),
                    onChanged: (v) {
                      searchQuery = v;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  selectedMembersList.isNotEmpty
                      ? SizedBox(
                          height: 76.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: selectedMembersList
                                .asMap()
                                .entries
                                .map((entry) {
                              return selectedGroupListCell(entry.value);
                            }).toList(),
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: selectedMembersList.isNotEmpty ? 24 : 0,
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
                          text: "Members",
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
                      itemCount: _filteredMembers.length,
                      itemBuilder: (context, index) {
                        var isLastItem =
                            (_filteredMembers.length) == (index + 1);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: groupListCell(
                              _filteredMembers.elementAt(index), isLastItem),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget groupListCell(GroupMembers member, bool isLasItem) {
    bool isSelectedValue = selectedMembersList.contains(member);

    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () {
            //Perform Action When Tap On Cell

            if (selectedMembersList.contains(member)) {
              selectedMembersList.remove(member);
            } else {
              selectedMembersList.add(member);
            }
            setState(() {});
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
                    text: (member.memberName ?? "Unknown").characters.first,
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
                      text: member.memberName ?? "Unknown",
                      textColor: const Color(0XFF101315),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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

  Widget selectedGroupListCell(GroupMembers member) {
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
                      text: (member.memberName ?? "").characters.first,
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
                    if (selectedMembersList.contains(member)) {
                      selectedMembersList.remove(member);
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
            text: member.memberName ?? "",
            textColor: const Color(0XFF101315),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textOverflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> addMembersToEditingGroup() async {
    //IF EDITING THE GROUP:
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group tempGroup = groupController.groupInAction!;

    var newMembers =
        selectedMembersList.map((member) => member.memberTelephone).toList();

    final Set<String> phoneNumbersSet =
        tempGroup.members.map((member) => member.memberTelephone).toSet();

    if (newMembers.length == 1 && phoneNumbersSet.contains(newMembers.first)) {
      showToast("Number Already Added!, Please select different number.");
      return;
    }

    final newMemberCount = selectedMembersList.length;
    for (var number in newMembers) {
      if (phoneNumbersSet.contains(number)) {
        selectedMembersList
            .removeWhere((element) => element.memberTelephone == number);
      }
    }

    if (newMemberCount != selectedMembersList.length) {
      showToast("Duplicate number found!");
    }

    tempGroup.members.addAll(selectedMembersList);
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

    Navigator.pop(context, true);
  }

  void addMembersToNewCreatingGroup() {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    bool status = groupController.addMembersToNewGroup(selectedMembersList);
    if (status) {
      Navigator.pop(context, true);
    }
  }

  void addMembersToInstantCall() {
    List<MemberListModel> newMembers = [];
    newMembers = selectedMembersList
        .map((e) => MemberListModel(
            name: e.memberName ?? "", phoneNumber: e.memberTelephone))
        .toList();

    bool status = Provider.of<InstantCallProvider>(context, listen: false)
        .addMembersToCallNow(newMembers: newMembers, addToActiveCall: false);
    if (status) {
      Navigator.pop(context, true);
    }
  }

  void addMembersToCallingScreen(BuildContext context) {
    var provider = Provider.of<InstantCallProvider>(context, listen: false);
    var selectedProfile = provider.selectedProfile;
    int selectedProfileSize = selectedProfile?.profileSize == 0
        ? 4
        : selectedProfile?.profileSize ?? 4;

    var newMembers = selectedMembersList
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
      bool status = Provider.of<InstantCallProvider>(context, listen: false)
          .addMembersToCallNow(newMembers: newMembers, addToActiveCall: true);
      if (status) {
        Navigator.pop(context, true);
      }
    }
  }

  void addMembersToScheduleCall() {
    var newMembers = selectedMembersList
        .map((e) => ScheduleCallMember(
            memberName: (e.memberName ?? "").length > 15
                ? (e.memberName ?? "").substring(0, 15)
                : (e.memberName ?? ""),
            memberTelephone: e.memberTelephone,
            memberEmail: ""))
        .toList();

    bool status = Provider.of<CallsController>(context, listen: false)
        .addMembersToScheduleCallWithDuplicateCheck(newMembers);
    if (status) {
      Navigator.pop(context, true);
    }
  }
}
