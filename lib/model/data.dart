// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, avoid_init_to_null
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Data with ChangeNotifier {
  //default variables
  dynamic phone = null, type = null, prefs = null;
  late Map<String, dynamic> usrinfo = {};
  late FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Function stc;

  Data() {
    //constructor to initialize object
    () async {
      prefs = await SharedPreferences.getInstance(); //cookie
      phone = prefs.getString('phone');
      type = prefs.getString('type');
      if (type != null) {
        getUsrData();
      }
      notifyListeners();
    }();
  }

  void trigger(phone, type) {
    this.phone = phone;
    this.type = type;
    getUsrData().whenComplete(() {
      notifyListeners();
    });
    notifyListeners();
  }

  Future getUsrData() async {
    if (phone == null) {
      return;
    }
    final url =
        "https://abai-194101.000webhostapp.com/women_innovation_hackathon/usrdata.php?phone=$phone";
    var response = await http.get(Uri.parse(url));
    if (response.body == "No") {
      notifyListeners();
      return;
    }
    usrinfo = json.decode(response.body)[0];
    notifyListeners();
  }

  Future<void> sendNotification(
      String msg, String reason, String msgToken) async {
    //notificatin sending function by http
    String url = "https://fcm.googleapis.com/fcm/send";
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "to": msgToken,
            "notification": {
              "title": msg,
              "body": reason,
              "mutable_content": true,
              "sound": "Tri-tone",
              "priority": "high"
            },
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAA9E6-k3o:APA91bFujDP4MT6pTf5VDUzSfDLXtG_iwi8GWV-kTl0hJd1F1pLpLGmS_qqULreV-nSRsweoOFNHEWg6Dqp8nD3NgaVZ67slPkKZSJMO04GzLNBb_nYz4jBYjjp5xr2uUCUdlCbhemKh",
        },
      );
    } catch (e) {
      //none
    }
  }

  void clear() async {
    //logout
    // Remove cokie data...
    prefs.clear();
    usrinfo = {};
    phone = null;
    type = null;
    stc();
    notifyListeners();
  }
}
