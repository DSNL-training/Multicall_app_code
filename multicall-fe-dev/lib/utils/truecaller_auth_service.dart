import 'dart:async';
import 'package:dio/dio.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:uuid/uuid.dart';

class TrueCallerAuthService {
  late StreamSubscription<TcSdkCallback>? _subscription;
  late String? codeVerifier;
  final Dio dio = Dio();
  late String accessToken = "";
  late String accessTokenResponse = "";
  late String userInfoResponse = "";

  void init(
      Stream<TcSdkCallback> stream, Function onSuccess, Function onError) {
    _subscription = stream.listen((callbackData) async {
      if (callbackData.result == TcSdkCallbackResult.success) {
        TcOAuthData tcOAuthData = callbackData.tcOAuthData!;
        var res = await fetchAccessToken(
            tcOAuthData.authorizationCode, codeVerifier!);
        onSuccess(res);
      } else {
        onError("Verification failed");
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  void startVerification(Function onDeviceNotSupported, Function onNotUsable) {
    TcSdk.initializeSDK(sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS);
    TcSdk.isOAuthFlowUsable.then((isOAuthFlowUsable) {
      if (isOAuthFlowUsable) {
        TcSdk.setOAuthState(const Uuid().v1());
        TcSdk.setOAuthScopes(['profile', 'phone', 'openid', 'email']);
        TcSdk.generateRandomCodeVerifier.then((codeVerifier) {
          TcSdk.generateCodeChallenge(codeVerifier).then((codeChallenge) {
            if (codeChallenge != null) {
              this.codeVerifier = codeVerifier;
              TcSdk.setCodeChallenge(codeChallenge);
              TcSdk.getAuthorizationCode;
            } else {
              onDeviceNotSupported();
            }
          });
        });
      } else {
        onNotUsable();
      }
    });
  }

  Future<Map<String, dynamic>> fetchAccessToken(
      String authorizationCode, String codeVerifier) async {
    try {
      Response response;
      response = await dio.post(
        'https://oauth-account-noneu.truecaller.com/v1/token',
        data: {
          'grant_type': 'authorization_code',
          'client_id': '0zx0jleibop8k-oar9cqs1allxynbyhrhybwgermgg8',
          'code': authorizationCode,
          'code_verifier': codeVerifier
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> result = response.data;
        accessToken = result['access_token'];
        accessTokenResponse =
            result.entries.map((e) => '${e.key} = ${e.value}').join("\n\n");
        var userInfo = await fetchUserInfo();
        return userInfo;
      }
      throw Exception("Failed to fetch access token");
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    try {
      Response response;
      response = await dio.get(
        'https://oauth-account-noneu.truecaller.com/v1/userinfo',
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> result = response.data;
        userInfoResponse =
            result.entries.map((e) => '${e.key} = ${e.value}').join("\n\n");
        return result;
      }
      throw Exception("Failed to fetch user info");
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}
