import 'package:multicall_mobile/models/message.dart';

class Group {
  int groupId;
  int profileRefNum;
  String name;
  int isFavorite;
  List<GroupMembers> members;

  Group({
    required this.groupId,
    required this.name,
    required this.profileRefNum,
    required this.isFavorite,
    this.members = const [],
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      profileRefNum: json['profileRefNum'],
      name: json['name'],
      isFavorite: json['isFavorite'],
      members: [],
    );
  }
  void addMemberFromJSON(Map<String, dynamic> json) {
    if (json['msgNumber'] == 1) {
      members.clear();
    }
    members.addAll(
      (json['members'] as List)
          .map(
            (e) => GroupMembers(
              memberTelephone: e['GroupMembers'] ?? "",
              memberName: e['memberName'] ?? "",
              memberEmail: e['memberEmail'] ?? "",
            ),
          )
          .toList(),
    );
  }
}
