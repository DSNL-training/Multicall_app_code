import 'package:multicall_mobile/models/response_bulk_update.dart';

class MemberListModel {
  String name;
  String phoneNumber;
  CallStatus status;
  MuteStatus muteStatus;

  MemberListModel({
    required this.name,
    required this.phoneNumber,
    this.status = CallStatus.onHold,
    this.muteStatus = MuteStatus.unMuted,
  });
}
