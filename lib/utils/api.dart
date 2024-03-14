// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<String> fetchToken(BuildContext context) async {
  // if (!dotenv.isInitialized) {
  //   // Load Environment variables
  //   await dotenv.load(fileName: ".env.example");
  // }
  // const String authUrl = "https://api.videosdk.live/v2";
  // String authToken = "67b205cc-62a2-4c21-bb08-98f08a07fb62";
  // print("=========>>>>>> Nimadir bo'ldi");

  // if ((authToken.isEmpty) && (authUrl.isEmpty)) {
  //   print("=========>>>>>> Nimadir bo' 2");
  //   showSnackBarMessage(
  //     message: "Please set the environment variables",
  //     context: context,
  //   );
  //   throw Exception("Either AUTH_TOKEN or AUTH_URL is not set in .env file");
  // }

  // if (authUrl.isNotEmpty) {
  //   if (kDebugMode) {
  //     print("=========>>>>>> Nimadir bu $authUrl");
  //   }
  //   final Uri getTokenUrl = Uri.parse('$authUrl/get-token');
  //   final http.Response tokenResponse = await http.get(getTokenUrl);
  //   if (kDebugMode) {
  //     print("=========>>>>>> Nimadir bu2 $tokenResponse");
  //   }
  //   authToken = json.decode(tokenResponse.body)['token'];
  // }

  return Future.delayed(
    const Duration(milliseconds: 100),
    () =>
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI1NGFlMzdkYS02NjBlLTQ5MzgtODJhNC04YjQxOTAzYjg2OTciLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcwOTcyODU3NiwiZXhwIjoxNzQxMjY0NTc2fQ.FZ4PYGu_pFFJYGAvGz-gzI496s2gd5ox7QYY2rPC8t8",
  );
}

Future<String> createMeeting(String token) async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}

Future<bool> validateMeeting(String token, String meetingId) async {
  const String videosdkApiEndpoint = "https://api.videosdk.live/v2";

  final Uri validateMeetingUrl =
      Uri.parse('$videosdkApiEndpoint/rooms/validate/$meetingId');
  final http.Response validateMeetingResponse =
      await http.get(validateMeetingUrl, headers: {
    "Authorization": token,
  });

  if (validateMeetingResponse.statusCode != 200) {
    print(
        "======>>>> Salom hayir ${json.decode(validateMeetingResponse.body)["error"]}");
    throw Exception(json.decode(validateMeetingResponse.body)["error"]);
  }

  return validateMeetingResponse.statusCode == 200;
}

Future<dynamic> fetchSession(String token, String meetingId) async {
  const String videosdkApiEndpoint = "https://api.videosdk.live/v2";

  final Uri getMeetingIdUrl =
      Uri.parse('$videosdkApiEndpoint/sessions?roomId=$meetingId');
  final http.Response meetingIdResponse =
      await http.get(getMeetingIdUrl, headers: {
    "Authorization": token,
  });
  List<dynamic> sessions = jsonDecode(meetingIdResponse.body)['data'];
  return sessions.first;
}
