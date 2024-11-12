import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/call_me_on_controller.dart';
import 'package:multicall_mobile/main.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';
import 'package:provider/provider.dart';

class ProfileController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();
  Profile? defaultProfile;
  List<Profile> profiles = [];
  String fcmToken = "";
  int osType = 0;
  String deviceModel = '';
  String deviceOS = '';
  String buildVersion = '';

  ProfileController() {
    regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber) ?? 0;
    email = PreferenceHelper.get(PrefUtils.userEmail) ?? '';
    telephone = PreferenceHelper.get(PrefUtils.userPhoneNumber) ?? '';
    fcmToken = PreferenceHelper.get(PrefUtils.fcmToken) ?? "";
    getDeviceDetails();
    getProfiles();
  }

  syncProfileData() async {
    await syncDeletedProfile();
    await syncProfiles();
  }

  Future<void> setUserName(String name) async {
    await PreferenceHelper.set(PrefUtils.userName, name);
  }

  Future<void> setEmail(String mail) async {
    await PreferenceHelper.set(PrefUtils.userEmail, mail);
    email = await PreferenceHelper.get(PrefUtils.userEmail) ?? '';
  }

  Future<void> setPhoneNumber(String phone) async {
    await PreferenceHelper.set(PrefUtils.userPhoneNumber, phone);
    telephone = await PreferenceHelper.get(PrefUtils.userPhoneNumber) ?? '';
  }

  Future<void> setRegNum(int? reg) async {
    await PreferenceHelper.set(PrefUtils.userRegistrationNumber, reg);
    regNum = await PreferenceHelper.get(PrefUtils.userRegistrationNumber) ?? '';
  }

  Future<void> isUserRegistered(bool? isUserRegistered) async {
    await PreferenceHelper.set(PrefUtils.isUserRegistered, isUserRegistered);
  }

  /// Call this methode when user logout
  /// To clear all data
  void clearProfileControllerAllData() {
    profiles.clear();
    defaultProfile = null;
    notify();
  }

  /// Cloud Messaging api call
  /// osType values:
  /// 1-Android, 2-iOS
  Future<RecievedMessage> cloudMessaging() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCloudMessaging(
        registrationNumber: regNum,
        osType: osType,
        deviceTokenLength: fcmToken.length,
        deviceToken: fcmToken,
        deviceOs: deviceOS,
        deviceModel: deviceModel,
        buildVersion: buildVersion,
      ),
    );
    return response;
  }

  Future<Map<String, dynamic>> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      osType = 1;
      deviceModel = androidInfo.model;
      deviceOS = 'Android ${androidInfo.version.release}';
      buildVersion = "1.0.0";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      osType = 2;
      deviceModel = iosInfo.utsname.machine;
      deviceOS = iosInfo.systemName;
      buildVersion = "1.0.0";
    }

    return {
      'osType': osType,
      'deviceModel': deviceModel,
      'deviceOS': deviceOS,
      'buildVersion': buildVersion,
    };
  }

  //Send FCM to backend
  Future<RecievedMessage> requestFcm() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestFCM(
        regNum: regNum,
        token: fcmToken,
      ),
    );
    return response;
  }

  void addProfile(RestoreProfileSuccess profile) {
    if (profile.sequenceNo == 1) {
      profiles.clear();
    }
    Profile? newDefaultProfile = profile.profiles
        .where((profile) => profile.defaultProfileFlag == 1)
        .firstOrNull;
    if (newDefaultProfile != null) {
      defaultProfile = newDefaultProfile;
    }
    profiles.addAll(profile.profiles);
    debugPrint('adding profile to controller =>${profile.sequenceNo}');
    notifyListeners(); // Notify listeners to update UI

    if (newDefaultProfile != null) {
      /// Update Call Me On List based on default profile
      Provider.of<CallMeOnController>(
        navigatorKey.currentContext!,
        listen: false,
      ).setFilteredCallMeOnList();
    }
  }

  Future<RecievedMessage> createBusinessProfile({
    required int regNum,
    required int profilePin,
    required String email,
    required String telephone,
    required String profileName,
    required String profileTelephone,
    required String profileEmail,
  }) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestAddProfile(
        regNum: regNum,
        email: PreferenceHelper.get(PrefUtils.userEmail),
        telephone: PreferenceHelper.get(PrefUtils.userPhoneNumber),
        profilePin: profilePin,
        profileName: profileName,
        profileTelephone: profileTelephone,
        profileEmail: profileEmail,
      ),
    );
    return response;
  }

  Future<RequestCreateRetailProfileSuccess> createRetailProfile({
    required String profileName,
    required String profileTelephone,
    required String profileEmail,
  }) async {
    RequestCreateRetailProfileSuccess response =
        await webSocketService.asyncSendMessage(
      RequestCreateRetailProfile(
        regNum: regNum,
        email: PreferenceHelper.get(PrefUtils.userEmail),
        telephone: PreferenceHelper.get(PrefUtils.userPhoneNumber),
        profileName: profileName,
        profileTelephone: profileTelephone,
        profileEmail: profileEmail,
      ),
    ) as RequestCreateRetailProfileSuccess;
    return response;
  }

  Future<void> getProfiles() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await webSocketService.asyncSendMessage(
        RequestProfileRestore(
          telephone: telephone,
          emailid: email,
          regNum: regNum,
        ),
      );
    });
    syncProfileData();
    notify();
  }

  Future<RecievedMessage> editProfile({
    required int profileRefNo,
    required String profileName,
  }) async {
    EditProfileSuccess response =
        await webSocketService.asyncSendMessage(RequestEditProfile(
      regNum: regNum,
      profileName: profileName,
      profileRefNum: profileRefNo,
    )) as EditProfileSuccess;
    notifyListeners();
    return response;
  }

  Future<RecievedMessage> deleteProfile({
    required int profileRefNo,
    required String profileName,
    required String email,
    required String telephone,
  }) async {
    DeleteProfileSuccess response =
        await webSocketService.asyncSendMessage(RequestProfileDelete(
      regNum: regNum,
      profileRefNumber: profileRefNo,
      email: email,
      telephone: telephone,
      profileName: profileName,
    )) as DeleteProfileSuccess;
    notifyListeners();
    return response;
  }

  Future<SyncDeletedProfileSuccess> syncDeletedProfile() async {
    SyncDeletedProfileSuccess response =
        await webSocketService.asyncSendMessage(RequestProfileDeleteSync(
      regNum: regNum,
      lastSyncTime: DateTime.now().microsecondsSinceEpoch,
    )) as SyncDeletedProfileSuccess;
    return response;
  }

  Future<UpdateDefaultProfileSuccess> updateDefaultProfile({
    required int profileRefNo,
  }) async {
    UpdateDefaultProfileSuccess response =
        await webSocketService.asyncSendMessage(
      RequestUpdateDefaultProfile(
        regNum: regNum,
        profileRefNum: profileRefNo,
      ),
    ) as UpdateDefaultProfileSuccess;
    if (response.status) {
      ProfileController();
    }
    return response;
  }

  Profile? getRetailProfile() {
    for (var profile in profiles) {
      if (profile.accountType == AppConstants.retailPrepaid) {
        return profile;
      }
    }
    return null; // Return null if no retail profile is found
  }

  Future<UpdateDefaultProfileSuccess>
      updateRetailProfileToDefaultProfile() async {
    Profile? retailProfile = getRetailProfile();
    UpdateDefaultProfileSuccess response =
        await webSocketService.asyncSendMessage(
      RequestUpdateDefaultProfile(
        regNum: regNum,
        profileRefNum: retailProfile?.profileRefNo ?? 1,
      ),
    ) as UpdateDefaultProfileSuccess;
    if (response.status) {
      ProfileController();
    }
    return response;
  }

  Future<SyncProfileSuccess> syncProfiles() async {
    SyncProfileSuccess response = await webSocketService.asyncSendMessage(
      RequestProfileSync(
        regNum: regNum,
        telephone: telephone,
        emailid: email,
        lastSyncTime: DateTime.now().microsecondsSinceEpoch.toString(),
      ),
    ) as SyncProfileSuccess;
    if (response.status) {
      // TODO: Perform actions accordingly
    }
    return response;
  }

  Future<RequestProfileStatusCheckSuccess> profileStatusCheck({
    required String profileTelephone,
    required String profileEmail,
    required int profileRefNum,
  }) async {
    RequestProfileStatusCheckSuccess response =
        await webSocketService.asyncSendMessage(
      RequestProfileStatusCheck(
        regNum: regNum,
        telephone: telephone,
        email: email,
        profileRefNum: profileRefNum,
        profileTelephone: profileTelephone,
        profileEmail: profileEmail,
      ),
    ) as RequestProfileStatusCheckSuccess;
    if (response.status) {
      // TODO: Perform actions accordingly
    }
    return response;
  }

  Future<RequestProfileOverDueSuccess> getProfileOverDueAmount({
    required int profileRefNum,
  }) async {
    RequestProfileOverDueSuccess response =
        await webSocketService.asyncSendMessage(
      RequestProfileOverdueAmount(
        regNum: regNum,
        profileRefNum: profileRefNum,
      ),
    ) as RequestProfileOverDueSuccess;
    if (response.status) {
      // TODO: Perform actions accordingly
    }
    return response;
  }

  Future<SyncDeletedProfileSuccess> acknowledgeProfileDeleteSync({
    required int profileRefNum,
  }) async {
    SyncDeletedProfileSuccess response =
        await webSocketService.asyncSendMessage(
      RequestAcknowledgeProfileDeleteSync(
        regNum: regNum,
        profileRefNum: profileRefNum,
        lastSyncTime: DateTime.now().microsecondsSinceEpoch,
      ),
    ) as SyncDeletedProfileSuccess;
    if (response.status) {
      // TODO: Perform actions accordingly
    }
    return response;
  }

  void notify() {
    notifyListeners();
  }
}
