import 'package:flutter/material.dart';

List<String> accountTypes = [
  "CORPORATE_POSTPAID_1",
  "CORPORATE_POSTPAID_2",
  "CORPORATE_PREPIAD",
  "RETAIL_PREPIAD",
];

List<String> profileStatuses = ["Active", "Inactive"];

class AppConstants {
  String websocketUrl = 'ws://43.204.156.34:8080';

  static const int corporatePostpaid1 = 1;
  static const int corporatePostpaid2 = 2;
  static const int corporatePrepaid = 3;
  static const int retailPrepaid = 4;

  /// Based on the facility element parameter while creating a retail account,
  /// we will allow scheduling, recording, playback.
  static const int allowScheduling = 3;
}

GlobalKey<State<StatefulWidget>>? navigation1 =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? navigation2 =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? navigation3 =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? navigation4 =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? homePageTabs =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? createGroupButton =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? editGroupButton =
    GlobalKey<State<StatefulWidget>>();
GlobalKey<State<StatefulWidget>>? favoriteGroup =
    GlobalKey<State<StatefulWidget>>();

void resetKeys() {
  navigation1 = GlobalKey<State<StatefulWidget>>();
  navigation2 = GlobalKey<State<StatefulWidget>>();
  navigation3 = GlobalKey<State<StatefulWidget>>();
  navigation4 = GlobalKey<State<StatefulWidget>>();
  homePageTabs = GlobalKey<State<StatefulWidget>>();
  createGroupButton = GlobalKey<State<StatefulWidget>>();
  editGroupButton = GlobalKey<State<StatefulWidget>>();
  favoriteGroup = GlobalKey<State<StatefulWidget>>();
}
