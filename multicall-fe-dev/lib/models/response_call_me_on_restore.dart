import 'package:multicall_mobile/models/response.dart';

class ResponseCallMeOnRestore extends RecievedMessage {
  final int totalPhoneCount;
  final int unused1;
  final int unused2;
  final List<CallMeOn> callMeOnList;
  final String uniqueId;

  ResponseCallMeOnRestore({
    required super.reactionType,
    required super.status,
    required this.totalPhoneCount,
    required this.unused1,
    required this.unused2,
    required this.callMeOnList,
    required this.uniqueId,
  });

  factory ResponseCallMeOnRestore.fromJson(Map<String, dynamic> json) {
    var list = json['callMeOnList'] as List;
    List<CallMeOn> callMeOnList =
        list.map((i) => CallMeOn.fromJson(i)).toList();

    return ResponseCallMeOnRestore(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      // Defaulting to true if not present
      totalPhoneCount: json['totalPhoneCount'],
      unused1: json['unused1'],
      unused2: json['unused2'],
      callMeOnList: callMeOnList,
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'totalPhoneCount': totalPhoneCount,
      'unused1': unused1,
      'unused2': unused2,
      'callMeOnList': callMeOnList.map((i) => i.toJson()).toList(),
      'uniqueId': uniqueId,
    };
  }
}

class CallMeOn {
  final String callMeOn;
  final int labelType;

  factory CallMeOn.fromJson(Map<String, dynamic> json) {
    return CallMeOn(
      callMeOn: json['callMeOn'],
      labelType: json['labelType'],
    );
  }

  CallMeOn({required this.callMeOn, required this.labelType});

  Map<String, dynamic> toJson() {
    return {
      'callMeOn': callMeOn,
      'labelType': labelType,
    };
  }
}
