// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import '../model/data.dart';
import 'package:intl/intl.dart';

class ChatUI extends StatefulWidget {
  Data a;
  ChatUI(this.a);
  @override
  State<ChatUI> createState() => _ChatUIState();
}

class Message {
  final String message, type, date, name;
  int me = 0, compare = 0;
  Message(this.message, this.type, this.date, this.me, this.compare, this.name);
}

class _ChatUIState extends State<ChatUI> {
  TextEditingController control = TextEditingController();
  List<Message> msg = [];

  @override
  void initState() {
    getDataByFormat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    msg.clear();
    control.dispose();
  }

  void getDataByFormat() {
    var now = DateTime.now();
    var format = "${now.day}|${now.month}|${now.year}";
    widget.a.firestore
        .collection("chat")
        .doc("messages")
        .collection(format.toString())
        .get()
        .then((value) {
      for (dynamic i in value.docs) {
        int me = (i["phone"] == widget.a.phone.toString()) ? 1 : 0;
        String date = i["date"];
        msg.add(
          Message(
            i["msg"],
            i["type"],
            i["date"],
            me,
            int.parse(
              date.substring(11, 13) + date.substring(14, 16),
            ),
            i["name"],
          ),
        );
      }
    }).whenComplete(() {
      msg.sort((a, b) {
        return (a.compare).compareTo(b.compare);
      });
      setState(() {});
    });
  }

  void send() {
    if (control.text.isEmpty) {
      return;
    }
    if (widget.a.usrinfo.isEmpty || widget.a.usrinfo["name"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text(
              "Update your information in settings.",
            ),
          ),
        ),
      );
      return;
    }
    var now = DateTime.now();

    var format = "${now.day}|${now.month}|${now.year}";
    widget.a.firestore
        .collection("chat")
        .doc("messages")
        .collection(format.toString())
        .doc()
        .set(
      {
        "name": widget.a.usrinfo["name"],
        "date": now.toString(),
        "type": widget.a.type,
        "msg": control.text,
        "phone": widget.a.phone
      },
    );
    msg.add(
      Message(
        control.text,
        widget.a.type,
        now.toString(),
        1,
        2,
        widget.a.usrinfo["name"],
      ),
    );
    control.text = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          tooltip: "This screen shows only today's chat..",
          icon: const Icon(Icons.chat_rounded),
          onPressed: () {},
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        title: const Text(
          "Open Chat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0x1f000000),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: const Color(0x4d9e9e9e),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: msg.length,
                itemBuilder: (context, index) {
                  final dateFormat = DateFormat('h:mm a');
                  final stringFormat =
                      dateFormat.format(DateTime.parse(msg[index].date));
                  return Align(
                    alignment: msg[index].me == 0
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: msg[index].me == 0
                            ? Colors.white
                            : const Color.fromARGB(255, 155, 227, 158),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg[index].name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  msg[index].me == 0 ? Colors.pink : Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            msg[index].message,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            stringFormat,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: size.width * 1,
              child: Card(
                elevation: 1,
                child: TextField(
                  controller: control,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: "Type Something...",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          send();
                        },
                        color: const Color(0xff212435),
                        iconSize: 30,
                      ),
                    ),
                    focusColor: Colors.black,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: IconButton(
                        icon: Icon(Icons.sentiment_satisfied_alt_outlined),
                        onPressed: null,
                        color: Color(0xff212435),
                        iconSize: 30,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0xfff2f2f3),
                    isDense: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
