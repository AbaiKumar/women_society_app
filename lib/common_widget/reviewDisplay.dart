// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages, must_be_immutable, avoid_init_to_null, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StarReview extends StatefulWidget {
  final phone;
  const StarReview(
    this.phone,
  );

  @override
  State<StarReview> createState() => _StarReviewState();
}

class _StarReviewState extends State<StarReview> {
  int value = -1;
  TextEditingController txt1 = TextEditingController();

  Future<void> writeReview() async {
    if (txt1.text != "" && value != -1) {
      FirebaseFirestore.instance
          .collection('Seller')
          .doc(widget.phone)
          .collection("review")
          .doc()
          .set(
        {
          "text": txt1.text,
          "val": value,
        },
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: const IconThemeData(size: 30, color: Colors.amber),
      ),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text(
            "Write Your Review",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.yellow,
          centerTitle: true,
          elevation: 1,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 350,
              child: Card(
                elevation: 1,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 85,
                      child: Card(
                        margin: const EdgeInsets.all(15),
                        elevation: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      value = index;
                                    });
                                  },
                                  icon: Icon(
                                    index <= value
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 40,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextField(
                        style: const TextStyle(
                          fontFamily: "OpenSans",
                        ),
                        cursorColor: Colors.redAccent,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          label: Text(
                            "Write a review",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        controller: txt1,
                        maxLines: 2,
                        maxLength: 75,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            writeReview();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.yellow,
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
