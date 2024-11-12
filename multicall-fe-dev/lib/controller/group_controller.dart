import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';

class GroupController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();
  List<Group> groups = [];
  Group? groupInAction;
  Group? newCreatingGroup;
  bool _isGroupFetching = false;

  /// getter and setter
  bool get getIsGroupFetching => _isGroupFetching;

  set setIsGroupFetching(bool value) {
    _isGroupFetching = value;
    notifyListeners();
  }

  GroupController() {
    // Call all initial apis here
    fetchGroups();
  }

  void addGroup(RestoreGroupsSuccess group) {
    // if (group.groupCountHere == 1) {
    //   clearAllGroup();
    // }
    groups.addAll(group.groups);
    debugPrint('adding group to controller =>${group.groupCountHere}');
    notifyListeners(); // Notify listeners to update UI
  }

  void addGroupMembers(FetchGroupMembersResponse membersResponse) {
    if (membersResponse.msgNumber == 1) {
      groups
          .where((group) => group.groupId == membersResponse.groupId)
          .first
          .members
          .clear();
    }
    groups
        .where((group) => group.groupId == membersResponse.groupId)
        .first
        .members
        .addAll(membersResponse.members);
    notifyListeners(); // Notify listeners to update UI
  }

  void clearAllGroup() {
    groups.clear();
  }

  // Fetch all groups
  Future fetchGroups() async {
    clearAllGroup();
    setIsGroupFetching = true;
    webSocketService.asyncSendMessage(
      RequestRestoreGroup(
        regNum: regNum,
        email: email,
        telephone: telephone,
      ),
    );
  }

  // Group Restore
  Future<RestoreGroupsSuccess> getGroupList() async {
    clearAllGroup();
    RestoreGroupsSuccess response = await webSocketService.asyncSendMessage(
      RequestRestoreGroup(
        regNum: regNum,
        email: email,
        telephone: telephone,
      ),
    ) as RestoreGroupsSuccess;
    return response;
  }

  // Fetch Group Members
  Future<FetchGroupMembersResponse> fetchGroupMembers(int groupID) async {
    FetchGroupMembersResponse response =
        await webSocketService.asyncSendMessage(
      RequestFetchGroupMembers(
        regNum: regNum,
        email: email,
        telephone: telephone,
        groupId: groupID,
      ),
    ) as FetchGroupMembersResponse;
    debugPrint(response.status.toString());
    return response;
  }

  // Create Group
  Future<RecievedMessage> requestCreateGroup(
    String groupName,
    int profileRefNum,
    int totalIterations,
    int groupMembersCount,
  ) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCreateGroup(
        regNum: regNum,
        email: email,
        telephone: telephone,
        groupName: groupName,
        profileRefNumber: profileRefNum,
        totalIterations: totalIterations,
        groupMembersCount: groupMembersCount,
      ),
    );
    return response;
  }

  // Request To Add New Members To Group
  Future<CreateGroupResponse> requestToAddMembersToGroup(
    String groupName,
    int currentIterationNumber,
    int membersInCurrentIteration,
    List<GroupMembers> members,
  ) async {
    List<GroupMembers> tempMembers = [];
    for (var member in members) {
      if ((member.memberName?.length ?? 0) > 15) {
        member.memberName?.substring(0, 14);
        tempMembers.add(GroupMembers(
            memberTelephone: member.memberTelephone,
            memberName: member.memberName?.substring(0, 14)));
      } else {
        tempMembers.add(GroupMembers(
            memberTelephone: member.memberTelephone,
            memberName: member.memberName));
      }
    }

    CreateGroupResponse response = await webSocketService.asyncSendMessage(
      RequestAddNewMembersToGroup(
        groupName: groupName,
        regNum: regNum,
        currentIterationNumber: currentIterationNumber,
        membersInCurrentIteration: membersInCurrentIteration,
        members: tempMembers,
      ),
    ) as CreateGroupResponse;
    return response;
  }

  // Request Edit Group Details
  Future<RecievedMessage> requestToEditGroupDetails({
    required int groupMemberCount,
    required String oldGroupName,
    required String newGroupName,
    required int profileRefNumber,
    required int totalIterations,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestEditGroupDetails(
        regNum: regNum,
        email: email,
        telephone: telephone,
        groupMemberCount: groupMemberCount,
        oldGroupName: oldGroupName,
        newGroupName: newGroupName,
        profileRefNumber: profileRefNumber,
        totalIterations: totalIterations,
      ),
    );
    return response;
  }

  // Request Edit Group Members
  Future requestToEditGroupMembers(
    String oldGroupName,
    String newGroupName,
    List<GroupMembers> members,
  ) async {
    List<GroupMembers> tempMembers = [];
    for (var member in members) {
      if ((member.memberName?.length ?? 0) > 15) {
        member.memberName?.substring(0, 14);
        tempMembers.add(GroupMembers(
            memberTelephone: member.memberTelephone,
            memberName: member.memberName?.substring(0, 14)));
      } else {
        tempMembers.add(GroupMembers(
            memberTelephone: member.memberTelephone,
            memberName: member.memberName));
      }
    }

    int currentIterationNumber = 1;
    for (var i = 0; i < (tempMembers.length); i += 2) {
      List<GroupMembers> membersForIteration = [
        GroupMembers(
            memberTelephone: tempMembers.elementAt(i).memberTelephone,
            memberName: tempMembers.elementAt(i).memberName ?? "")
      ];

      if ((tempMembers.length) > i + 1) {
        membersForIteration.add(GroupMembers(
            memberTelephone: tempMembers.elementAt(i + 1).memberTelephone,
            memberName: tempMembers.elementAt(i + 1).memberName ?? ""));
      }

      if ((i == (tempMembers.length) - 1) || (i == (tempMembers.length) - 2)) {
        EditGroupMembersResponse response =
            await webSocketService.asyncSendMessage(
          RequestEditGroupMembers(
            regNum: regNum,
            currentIteration: currentIterationNumber,
            oldGroupName: oldGroupName,
            newGroupName: newGroupName,
            membersInCurrentIteration: membersForIteration.length,
            members: membersForIteration,
          ),
        ) as EditGroupMembersResponse;

        if (response.status) {
          if (groupInAction != null) {
            groupInAction?.name = response.groupName;
            fetchGroupMembers(groupInAction!.groupId);
            notifyListeners();
          }
        }
      } else {
        webSocketService.asyncSendMessage(
          RequestEditGroupMembers(
            regNum: regNum,
            currentIteration: currentIterationNumber,
            oldGroupName: oldGroupName,
            newGroupName: newGroupName,
            membersInCurrentIteration: membersForIteration.length,
            members: membersForIteration,
          ),
        );
      }
      currentIterationNumber++;
    }
  }

  //Request Delete Group
  Future<DeleteGroupResponse> requestDeleteGroup(
    String groupName,
  ) async {
    DeleteGroupResponse response = await webSocketService.asyncSendMessage(
      RequestDeleteGroup(
        regNum: regNum,
        email: email,
        telephone: telephone,
        groupName: groupName,
      ),
    ) as DeleteGroupResponse;
    return response;
  }

  //Request Add Favorite Group
  Future<MakeGroupFavoriteResponse> requestMakeFavoriteGroup(
    String groupName,
    int profileRefNumber,
  ) async {
    MakeGroupFavoriteResponse response =
        await webSocketService.asyncSendMessage(
      RequestAddFavoriteGroup(
        regNum: regNum,
        email: email,
        telephone: telephone,
        groupName: groupName,
        profileRefNumber: profileRefNumber,
      ),
    ) as MakeGroupFavoriteResponse;
    return response;
  }

  //Request Remove Favorite Group
  Future<MakeGroupFavoriteResponse> requestRemoveFavoriteGroup(
    String groupName,
  ) async {
    MakeGroupFavoriteResponse response =
        await webSocketService.asyncSendMessage(
      RequestRemoveFavoriteGroup(
        regNum: regNum,
        email: email,
        telephone: telephone,
        groupName: groupName,
      ),
    ) as MakeGroupFavoriteResponse;
    return response;
  }

  //Request Group Acknowledgement
  Future<RecievedMessage> getGroupDetails(
    int groupId,
    int lastSyncTime,
  ) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestGroupAcknowledgement(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
        groupId: groupId,
        lastSyncTime: lastSyncTime,
      ),
    );
    return response;
  }

  //Request Group Sync
  Future<RecievedMessage> syncGroup() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestGroupSync(
        regNum: regNum,
        telephone: telephone,
        email: email,
        lastSyncTime: DateTime.now().microsecondsSinceEpoch.toInt(),
      ),
    );
    return response;
  }

  //Methods for Creating New Group Only:
  void changeNewGroupName(String groupName) {
    newCreatingGroup?.name = groupName;
    notify();
  }

  bool addMembersToNewGroup(List<GroupMembers> members) {
    var tempMembers = members
        .map((member) => GroupMembers(
              memberName: member.memberName ?? "Unknown",
              memberTelephone: processPhoneNumber(member.memberTelephone),
            ))
        .toList();

    var existingMembers = (newCreatingGroup?.members ?? [])
        .map((e) => e.memberTelephone)
        .toList();

    if (members.length == 1 &&
        existingMembers.contains(members.first.memberTelephone)) {
      showToast("Number Already Added!, Please select different number.");
      return false;
    }

    final newMemberCount = tempMembers.length;
    for (var member in existingMembers) {
      tempMembers.removeWhere((element) => element.memberTelephone == member);
    }

    if (newMemberCount != tempMembers.length) {
      showToast("Duplicate number found!");
    }

    newCreatingGroup?.members.addAll(tempMembers);
    notify();

    return true;
  }

  void removeMemberFromNewGroup(GroupMembers member) {
    newCreatingGroup?.members.remove(member);
    notify();
  }

  void notify() {
    notifyListeners();
  }
}
