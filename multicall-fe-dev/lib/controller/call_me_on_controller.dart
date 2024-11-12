import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_call_me_on_restore.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';

class CallMeOnController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();

  final List<CallMeOn> _callMeOnList = [];
  final List<CallMeOn> _filteredCallMeOnList = [];

  /// Getters
  List<CallMeOn> get callMeOnList => _callMeOnList;

  List<CallMeOn> get filteredCallMeOnList => _filteredCallMeOnList;

  /// Setters
  void setCallMeOnList(List<CallMeOn> callMeOnList) {
    _callMeOnList
      ..clear()
      ..addAll(callMeOnList);
    setFilteredCallMeOnList();
    notifyListeners();
  }

  /// Call this methode when user logout
  /// To clear all data
  void clearCallMeOnControllerAllData() {
    _callMeOnList.clear();
    _filteredCallMeOnList.clear();
    notifyListeners();
  }

  void setFilteredCallMeOnList() {
    /// Add the default registered item to the top of the list
    final defaultItem = CallMeOn(
      labelType: -1,
      callMeOn: telephone,
    );

    _filteredCallMeOnList
      ..clear()
      ..add(defaultItem)
      ..addAll(_callMeOnList);
    notifyListeners();
  }

  void clearCallMeOnList() {
    _callMeOnList.clear();
    notifyListeners();
  }

  CallMeOnController();

  /// CallMeOnRestore api call
  Future callMeOnRestore() async {
    debugPrint("callMeOnRestore called");
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCallMeOnRestore(
        regNum: regNum,
        emailid: email,
        telephone: telephone,
      ),
    );
    return response;
  }

  /// CallMeOnUpdate api call
  Future<RecievedMessage> updateCallMeOn(
      int totalMembersCount, List<NumberEntry> members) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCallMeOnUpdate(
        regNum: regNum,
        email: email,
        telephone: telephone,
        totalMembersCount: totalMembersCount,
        members: members,
      ),
    );
    return response;
  }

  void addNumberSuccess(bool status) {
    if (status) {
      callMeOnRestore();
    }
  }
}
