import 'package:multicall_mobile/models/response.dart';

class ConfereeSpeakingStatusResponse extends RecievedMessage {
  final int regNum;
  final int profileRefNum;
  final int confRefNum;
  final int schedRefNum;
  final int totalConfereeCount;
  final List<String> confereePhones;
  final String uniqueId;

  ConfereeSpeakingStatusResponse({
    required super.reactionType,
    super.status = true,
    required this.regNum,
    required this.profileRefNum,
    required this.confRefNum,
    required this.schedRefNum,
    required this.totalConfereeCount,
    required this.confereePhones,
    required this.uniqueId,
  });

  factory ConfereeSpeakingStatusResponse.fromJson(Map<String, dynamic> json) {
    return ConfereeSpeakingStatusResponse(
      reactionType: json['reactionType'],
      status: true,
      regNum: json['regnum'],
      profileRefNum: json['profile_refnum'],
      confRefNum: json['conf_refnum'],
      schedRefNum: json['sched_refnum'],
      totalConfereeCount: json['total_conferee_count'],
      confereePhones: List<String>.from(json['conferee_phones']),
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'regNum': regNum,
      'profile_refnum': profileRefNum,
      'conf_refnum': confRefNum,
      'sched_refnum': schedRefNum,
      'total_conferee_count': totalConfereeCount,
      'conferee_phones': confereePhones,
      'uniqueId': uniqueId,
    };
  }
}