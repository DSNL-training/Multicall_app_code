import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/models/response_customer_care_number.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';

class AccountController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();
  List<String> emails = [];

  List<String> userPhoneNumberList = [];

  AccountController() {
    // Call all initial apis here
    clearAllEmails();
    fetchEmails();
    getUserPhoneNumberList();
  }

  /// Call this methode when user logout
  /// To clear all data
  void clearAccountControllerAllData() {
    emails.clear();
    userPhoneNumberList.clear();
    notifyListeners();
  }

  //Add EmailID To Account
  Future<ResponseAddEmailSuccess> addNewEmailIDToAccount(
      String newEmail) async {
    ResponseAddEmailSuccess response = await webSocketService.asyncSendMessage(
      RequestAddUserIdentifierEmail(
        regNum: regNum,
        email: email,
        telephone: telephone,
        userIdentifierEmail: newEmail,
      ),
    ) as ResponseAddEmailSuccess;
    return response;
  }

  Future refreshEmails() async {
    clearAllEmails();
    fetchEmails();
  }

  //Verify EmailID To Add in Account
  Future<RecievedMessage> verifyNewEmailIDToAddToAccount(int otp) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestUserIdentifierEmailOtp(
        regNum: regNum,
        email: email,
        telephone: telephone,
        otp: otp,
      ),
    );
    return response;
  }

  Future addEmails(response) async {
    List<String> newEmails = response.cast<String>();
    emails.addAll(newEmails);
    notifyListeners();
  }

  Future resendEmailOtp(newEmail) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestResendEmailOTP(
        regNum: regNum,
        telephone: telephone,
        registeredEmailID: email,
        email: newEmail,
      ),
    );
    return response;
  }

  //Add Phone Number To Account
  Future<ResponseAddEmailSuccess> addNewPhoneNumberToAccount(
      String newPhoneNumber) async {
    ResponseAddEmailSuccess response = await webSocketService.asyncSendMessage(
      RequestAddUserIdentifierPhone(
        regNum: regNum,
        email: email,
        telephone: telephone,
        userIdentifierPhone: newPhoneNumber,
      ),
    ) as ResponseAddEmailSuccess;
    return response;
  }

  //Verify Phone Number To Add in Account
  Future<VerificationResponseForAddNewPhoneNumber>
      verifyNewPhoneNumberToAddToAccount(int otp) async {
    VerificationResponseForAddNewPhoneNumber response =
        await webSocketService.asyncSendMessage(
      RequestUserIdentifierPhoneOtp(
        regNum: regNum,
        email: email,
        telephone: telephone,
        otp: otp,
      ),
    ) as VerificationResponseForAddNewPhoneNumber;
    return response;
  }

  //Get User Phone Number List
  Future<UserPhoneNumberListResponse> getUserPhoneNumberList() async {
    UserPhoneNumberListResponse response =
        await webSocketService.asyncSendMessage(
      RequestRestoreUserPhoneNumbers(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
      ),
    ) as UserPhoneNumberListResponse;

    userPhoneNumberList = response.phones.map((e) => e as String).toList();
    notifyListeners();

    return response;
  }

  Future<RequestAccountDetailsSuccess> getAccountDetails(
      int profileRefNum) async {
    RequestAccountDetailsSuccess response =
        await webSocketService.asyncSendMessage(
      RequestAccountDetails(
        profileRefNum: profileRefNum,
        regNum: regNum,
      ),
    ) as RequestAccountDetailsSuccess;
    return response;
  }

  Future<RequestProfilePlanDetailsSuccess> getProfilePlanDetails(
    int accountId,
    String profileRefNo,
  ) async {
    RequestProfilePlanDetailsSuccess response =
        await webSocketService.asyncSendMessage(
      RequestForRetailProfileBalance(
        profileRefNum: profileRefNo,
        accountId: accountId,
        regNum: regNum,
      ),
    ) as RequestProfilePlanDetailsSuccess;
    return response;
  }

  Future<RequestProfileBasePlanDetailsSuccess> getProfileBasePlanDetails(
    int accountId,
    int profileRefNo,
    int basePlanId,
  ) async {
    RequestProfileBasePlanDetailsSuccess response =
        await webSocketService.asyncSendMessage(
      RequestBasePlanDetails(
        regNum: regNum,
        profileRefNum: profileRefNo,
        accountId: accountId,
        basePlanId: basePlanId,
      ),
    ) as RequestProfileBasePlanDetailsSuccess;
    return response;
  }

  Future<RequestProfileBasePlanDetailsSuccess> ackProfileBasePlanDetails(
    int accountId,
    int profileRefNo,
    int jobId,
  ) async {
    RequestProfileBasePlanDetailsSuccess response =
        await webSocketService.asyncSendMessage(
      AckResponseFromBasePlanDetails(
        regNum: regNum,
        profileRefNum: profileRefNo,
        accountId: accountId,
        jobId: jobId,
      ),
    ) as RequestProfileBasePlanDetailsSuccess;
    return response;
  }

  void clearAllEmails() {
    emails.clear();
  }

  Future<RequestProfileAddOnPlanDetailsSuccess> getProfileAddOnPlanDetails(
    int accountId,
    int profileRefNo,
    int basePlanId,
  ) async {
    RequestProfileAddOnPlanDetailsSuccess response =
        await webSocketService.asyncSendMessage(
      RequestAddOnPlans(
        regNum: regNum,
        profileRefNum: profileRefNo,
        accountId: accountId,
        basePlanId: basePlanId,
      ),
    ) as RequestProfileAddOnPlanDetailsSuccess;
    return response;
  }

  Future<RequestProfileAddOnPlanDetailsSuccess> ackResponseAddOnPlanDetails(
    int accountId,
    int profileRefNo,
    int basePlanId,
    int jobId,
  ) async {
    RequestProfileAddOnPlanDetailsSuccess response =
        await webSocketService.asyncSendMessage(
      AckForResponseAddOnPlans(
        regNum: regNum,
        profileRefNum: profileRefNo,
        accountId: accountId,
        basePlanId: basePlanId,
        jobId: jobId,
      ),
    ) as RequestProfileAddOnPlanDetailsSuccess;
    return response;
  }

  Future<RequestProfilePaymentHistorySuccess> getProfilePlansHistoryDetails(
    String profileRefNo,
  ) async {
    RequestProfilePaymentHistorySuccess response =
        await webSocketService.asyncSendMessage(
      RequestForRetailPaymentHistory(
        regNum: regNum,
        profileRefNum: profileRefNo,
      ),
    ) as RequestProfilePaymentHistorySuccess;
    return response;
  }

  Future<RequestAppRequestToSendEnterprisePlanToMcSupportSuccess>
      requestAppRequestToSendEnterprisePlanToMcSupport(
    String email,
    String name,
    String phone,
  ) async {
    RequestAppRequestToSendEnterprisePlanToMcSupportSuccess response =
        await webSocketService.asyncSendMessage(
      App2MMRequestToSendEnterprisePlanToMcSupport(
        regNum: regNum,
        email: email,
        name: name,
        phoneNumber: phone,
      ),
    ) as RequestAppRequestToSendEnterprisePlanToMcSupportSuccess;
    return response;
  }

  Future<RequestSwitchPlanSuccess> requestSwitchToFreePlan(
    int profileRefNum,
  ) async {
    RequestSwitchPlanSuccess response = await webSocketService.asyncSendMessage(
      SwitchToFreePlan(
        regNum: regNum,
        profileRefNum: profileRefNum,
      ),
    ) as RequestSwitchPlanSuccess;
    return response;
  }

  Future<RequestCurrentPlanActiveStatusSuccess> requestCurrentPlanActiveStatus(
    int profileRefNum,
    int requestType,
  ) async {
    RequestCurrentPlanActiveStatusSuccess response =
        await webSocketService.asyncSendMessage(
      RequestCurrentPlanActiveStatus(
        regNum: regNum,
        profileRefNum: profileRefNum,
        requestType: requestType,
      ),
    ) as RequestCurrentPlanActiveStatusSuccess;
    return response;
  }

  Future<RequestActiveStatusSuccess> requestActiveStatus(
    int reqType,
    int profileRefNum,
  ) async {
    RequestActiveStatusSuccess response =
        await webSocketService.asyncSendMessage(
      RequestActiveStatus(
        regNum: regNum,
        profileRefNum: profileRefNum,
        reqType: reqType,
      ),
    ) as RequestActiveStatusSuccess;
    return response;
  }

  Future<RequestPrimaryEmailCheckSuccess> requestCheckPrimaryEmail(
    String email,
    int appSocketId,
    int socialNetworkFlag,
  ) async {
    RequestPrimaryEmailCheckSuccess response =
        await webSocketService.asyncSendMessage(
      RequestCodeCheckEmailIdPrimaryCheck(
        emailId: email,
        appSocketId: appSocketId,
        socialNetworkFlag: socialNetworkFlag,
      ),
    ) as RequestPrimaryEmailCheckSuccess;
    return response;
  }

  Future<RecievedMessage> requestTopUpPlan(
    int profileRefNum,
  ) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestTopUP(
        message: "top required",
        profileRefNum: profileRefNum,
        regNum: regNum,
      ),
    );
    return response;
  }

  Future<RecievedMessage> requestRetailPaymentOption(
    int profileRefNum,
  ) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRetailPayOption(
        profileRefNum: profileRefNum,
        regNum: regNum,
      ),
    );
    return response;
  }

  Future fetchEmails() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await webSocketService.asyncSendMessage(RequestRestoreUserEmails(
        registrationNumber: regNum,
        telephone: telephone,
        emailId: email,
      ));
    });
  }

  Future<ResponseCustomerCareNumber> requestCustomerCareNumber() async {
    ResponseCustomerCareNumber response =
        await webSocketService.asyncSendMessage(
      RequestCustomerCareNumber(
        registrationNumber: regNum,
      ),
    ) as ResponseCustomerCareNumber;
    return response;
  }
}
