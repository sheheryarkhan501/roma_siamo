import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pressfame_new/constant/global.dart';

String serverKey = "AAAA6LfdX64:APA91bGqet2wIVyUpb6rpGOyW2MCr1NfeJQuaWwZ8ZHyMXMPsWPwIZEpQyryvVyxlmVk-uNaq_-PJ4M8Eb_m8hg0ZygJ68LqoNXV3BDL-PX_CrjM7ubR4ZBbmIpb-oQ1HU1K3M_tZjYW";
setNotificationData(
    String peerId, String type, String message, String redirectId) {
  var time = DateTime.now().millisecondsSinceEpoch.toString();
  FirebaseFirestore.instance.collection("notification").doc(time).set({
    "idFrom": globalID,
    "idTo": peerId,
    "type": type,
    "message": message,
    "timestamp": time,
    "redirectId": redirectId
  }).then((value) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(peerId)
        .get()
        .then((peerData) {
      if (peerData.exists) {
        sendNotification(peerData['token'], message);
      }
    });
  });
}

Future<http.Response> sendNotification(String peerToken, String content) async {
  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "key=$serverKey"
    },
    body: jsonEncode({
      "to": peerToken,
      "priority": "high",
      "data": {
        "type": "100",
        "user_id": globalID,
        "title": content,
        "message": globalName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "sound": "default",
        "vibrate": "300",
      },
      "notification": {
        "vibrate": "300",
        "priority": "high",
        "body": content,
        "title": globalName,
        "sound": "default",
      }
    }),
  );
  return response;
}

Future<http.Response> sendImageNotification(
    String peerToken, String content) async {
  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "key=$serverKey"
    },
    body: jsonEncode({
      "to": peerToken,
      "priority": "high",
      "data": {
        "type": "100",
        "user_id": globalID,
        "title": content,
        "message": globalName,
        "image": content,
        "time": DateTime.now().millisecondsSinceEpoch,
        "sound": "default",
        "vibrate": "300",
      },
      "notification": {
        "vibrate": "300",
        "priority": "high",
        "body": "📷 Image",
        "title": globalName,
        "sound": "default",
        "image": content,
      }
    }),
  );
  return response;
}
