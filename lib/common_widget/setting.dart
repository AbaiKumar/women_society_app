// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../model/data.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var a = Provider.of<Data>(context, listen: false);

    return SafeArea(
      child: ElevatedButton(
        onPressed: () {
          a.clear();
        },
        child: const Text("Logout"),
      ),
    );
  }
}
