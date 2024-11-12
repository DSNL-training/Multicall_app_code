import 'package:multicall_mobile/models/response.dart';

class RestoreScheduleMemberResponse extends RecievedMessage {
  int totalMembersInCall;
  int memberCountHere;
  int messageNumber;
  int scheduleRefNo;
  List<ScheduleCallMembers> members;
  String uniqueId;

  RestoreScheduleMemberResponse({
    required super.reactionType,
    required super.status,
    required this.totalMembersInCall,
    required this.memberCountHere,
    required this.messageNumber,
    required this.scheduleRefNo,
    required this.members,
    required this.uniqueId,
  });

  factory RestoreScheduleMemberResponse.fromJson(Map<String, dynamic> json) {
    return RestoreScheduleMemberResponse(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      totalMembersInCall: json['totalMembersInCall'],
      memberCountHere: json['memberCountHere'],
      messageNumber: json['messageNumber'],
      scheduleRefNo: json['scheduleRefNo'],
      members: (json['members'] as List)
          .map((i) => ScheduleCallMembers.fromJson(i))
          .toList(),
      uniqueId: json['uniqueId'],
    );
  }
}

class ScheduleCallMembers {
  String phone;
  String email;
  String name;

  ScheduleCallMembers({
    required this.phone,
    required this.email,
    required this.name,
  });

  factory ScheduleCallMembers.fromJson(Map<String, dynamic> json) {
    return ScheduleCallMembers(
      phone: json['phone'],
      email: json['email'],
      name: json['name'],
    );
  }
}
