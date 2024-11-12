// import 'dart:convert';
// import 'package:http/http.dart' as http;

// int messageVersionFlag = 1;
// int messageVersion = 14;
// void registrationCall(
//     {required String name,
//     required String email,
//     required String phoneNumber}) {
//   int specialFlag = 1;
//   int codeRequestRegistration = 5;
//   int registrationNumber = -1;
//   int profilePin = 0;
//   int socialNetworkFlag = 1;
//   int phoneLen = 16;
//   int emailLen = 80;
//   int nameLen = 32;

//   // String phoneNumber = "7880667652";
//   // String name = "Aakanksh";
//   // String email = "aakankshsingh012@gmail.com";

//   List<int> sendBuffer = [];

//   sendBuffer.add(messageVersionFlag);
//   sendBuffer.addAll([messageVersion & 0xFF, (messageVersion >> 8) & 0xFF]);
//   sendBuffer.add(specialFlag);
//   sendBuffer.add(codeRequestRegistration);
//   sendBuffer.addAll([
//     registrationNumber & 0xFF,
//     (registrationNumber >> 8) & 0xFF,
//     (registrationNumber >> 16) & 0xFF,
//     (registrationNumber >> 24) & 0xFF
//   ]);

//   for (int id = 0; id < phoneLen; id++) {
//     sendBuffer.add(id < phoneNumber.length ? phoneNumber.codeUnitAt(id) : 0);
//   }

//   for (int id = 0; id < emailLen; id++) {
//     sendBuffer.add(id < email.length ? email.codeUnitAt(id) : 0);
//   }

//   for (int id = 0; id < nameLen; id++) {
//     sendBuffer.add(id < name.length ? name.codeUnitAt(id) : 0);
//   }

//   sendBuffer.addAll([
//     profilePin & 0xFF,
//     (profilePin >> 8) & 0xFF,
//     (profilePin >> 16) & 0xFF,
//     (profilePin >> 24) & 0xFF
//   ]);

//   sendBuffer.add(socialNetworkFlag);

//   if (sendBuffer.length < 256) {
//     int fillSize = 256 - sendBuffer.length;
//     sendBuffer.addAll(List<int>.filled(fillSize, 0));
//   }

//   print("sendBuffer contents:");
//   print(sendBuffer);

//   sendBufferToApi(sendBuffer);
// }

// void sendBufferToApi(List<int> sendBuffer) async {
//   var url = Uri.parse('https://multicall.f22labs.cloud/');
//   var response = await http.post(
//     url,
//     body: jsonEncode(sendBuffer),
//     headers: {"Content-Type": "application/json"},
//   );

//   if (response.statusCode == 200) {
//     print('Response from API:');
//     print(response.body);
//   } else {
//     print('Failed to load data. Status code: ${response.statusCode}');
//   }
// }
