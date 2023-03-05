// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review extends StatefulWidget {
  //which displays review of seller
  String phone;
  Review(this.phone);
  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  List review = [];
  double total = 0.0;

  Future getReview() async {
    var path = await FirebaseFirestore.instance
        .collection("Seller/${widget.phone}/review")
        .get();
    for (var i in path.docs) {
      review.add(i.data());
    }
    Map number = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0};
    for (var i in review) {
      if (i['val'] == 1) {
        number.update("1", (value) => number['1'] + 1);
      }
      if (i['val'] == 2) {
        number.update("2", (value) => number['2'] + 1);
      }
      if (i['val'] == 3) {
        number.update("3", (value) => number['3'] + 1);
      }
      if (i['val'] == 4) {
        number.update("4", (value) => number['4'] + 1);
      }
      if (i['val'] == 5) {
        number.update("5", (value) => number['5'] + 1);
      }
    }
    num mul = 0;
    for (var j in number.keys) {
      mul += (number[j] * int.parse(j));
    }
    total = mul / review.length; //average
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getReview();
      setState(() {});
    });
  }

  Widget con(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            Text(review[index]['val'].toString()),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(review[index]['text']),
        ),
        const Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.yellow,
      ),
      body: review.isNotEmpty
          ? ListView(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.amber,
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                Text("${review.length} reviews and rating"),
                const Divider(
                  thickness: 2,
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return con(index);
                  },
                  shrinkWrap: true,
                  itemCount: review.length,
                ),
              ],
            )
          : const Center(
              child: Text(
                'No Reviews Found',
              ),
            ),
    );
  }
}
