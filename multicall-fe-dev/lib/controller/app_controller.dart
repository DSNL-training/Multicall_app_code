import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/models/response.dart';
import 'package:multicall_mobile/providers/base_provider.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/utils/websocket_service.dart';

class AppController extends BaseProvider {
  final WebSocketService webSocketService = WebSocketService();

  AppController() {
    // Call all initial apis here
    regNum = PreferenceHelper.get(PrefUtils.userRegistrationNumber) ?? 0;
    email = PreferenceHelper.get(PrefUtils.userEmail) ?? '';
    telephone = PreferenceHelper.get(PrefUtils.userPhoneNumber) ?? '';
  }

  // InvitationSync -- Done
  Future<RecievedMessage> invitationSync() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestInvitationSync(
        regNum: regNum,
        email: email,
        telephone: telephone,
      ),
    );
    return response;
  }

  // InvitationSyncCancel -- Done
  Future<RecievedMessage> invitationSyncCancel() async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestCancelInvitationSync(
        regNum: regNum,
        email: email,
        telephone: telephone,
      ),
    );
    return response;
  }

  //Request health check
  Future<ResponseRequestHealthSuccess> requestHealthCheck() async {
    ResponseRequestHealthSuccess response =
        await webSocketService.asyncSendMessage(
      RequestHealthCheck(
        registrationNumber: regNum,
      ),
    ) as ResponseRequestHealthSuccess;
    return response;
  }

  Future<RecievedMessage> addUserFeedback(
    String feedbackMessage,
    String unusedString,
  ) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestUserFeedback(
          feedbackMessage: feedbackMessage,
          regNum: regNum,
          unusedString: unusedString),
    );
    return response;
  }

  Future<RequestForRegistrationStatusSuccess> requestRegistration(
    String email,
    String telephone,
  ) async {
    RequestForRegistrationStatusSuccess response =
        await webSocketService.asyncSendMessage(
      RequestRegistrationStatus(
        telephone: telephone,
        regNum: regNum,
        emailid: email,
      ),
    ) as RequestForRegistrationStatusSuccess;
    requestRegistrationReset(
      response.regNum,
      email,
      telephone,
    );
    return response;
  }

  Future<RecievedMessage> requestRegistrationReset(
      int regNo, String email, String phoneNumber) async {
    RecievedMessage response = await webSocketService.asyncSendMessage(
      RequestRegistrationReset(
        regNum: regNo,
        email: email,
        phoneNumber: phoneNumber,
      ),
    );
    return response;
  }
}
