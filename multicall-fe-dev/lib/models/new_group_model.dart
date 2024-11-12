class NewGroupModel {
  String? groupName;
  int? profileRefNumber;
  List<NewGroupMemberModel>? groupMembers;

  NewGroupModel({
    this.groupName,
    this.profileRefNumber,
    this.groupMembers,
  });
}

class NewGroupMemberModel {
  String memberName;
  String memberPhoneNumber;
  String memberEmail;

  NewGroupMemberModel({
    required this.memberName,
    required this.memberPhoneNumber,
    this.memberEmail = '',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['memberName'] = memberName;
    data['memberPhoneNumber'] = memberPhoneNumber;
    data['memberEmail'] = memberEmail;
    return data;
  }
}
