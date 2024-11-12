import 'package:multicall_mobile/models/response_restore_schedule_members.dart';
import 'package:multicall_mobile/models/response_restore_schedule_start.dart';

class MergedScheduleCallResponse {
  int scheduleRefNo;
  ScheduleDetail scheduleDetail;
  List<ScheduleCallMembers> members;

  MergedScheduleCallResponse({
    required this.scheduleRefNo,
    required this.scheduleDetail,
    required this.members,
  });
}

