import 'package:multicall_mobile/models/response.dart';

/// Response model for DidListsForDialIn
class DidListsForDialInResponse extends RecievedMessage {
  final String dialInDid;
  final String uniqueId;

  DidListsForDialInResponse({
    required super.reactionType,
    required super.status,
    required this.dialInDid,
    required this.uniqueId,
  });

  factory DidListsForDialInResponse.fromJson(Map<String, dynamic> json) {
    return DidListsForDialInResponse(
      reactionType: json['reactionType'],
      status: json['status'] ?? true,
      dialInDid: json['dialInDid'],
      uniqueId: json['uniqueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
      'status': status,
      'dialInDid': dialInDid,
      'uniqueId': uniqueId,
    };
  }
}