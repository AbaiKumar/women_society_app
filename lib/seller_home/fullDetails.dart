// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../common_widget/reviewDisplay.dart';
import '../common_widget/showReview.dart';

class Elaborate extends StatefulWidget {
  Map data;
  String did;
  Elaborate(this.data, this.did);
  @override
  State<Elaborate> createState() => _ElaborateState();
}

class _ElaborateState extends State<Elaborate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          widget.data["name"],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Hero(
                  tag: widget.data,
                  child: Image.network(
                    "https://abai-194101.000webhostapp.com/women_innovation_hackathon/${widget.data["imageUrl"]}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "About : ",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.data["desc"],
                        maxLines: 5,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    const Text(
                      "Quantity Available : ",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      widget.data["stock"],
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: [
                    const Text(
                      "Price : ",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data["price"],
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: [
                    const Text(
                      "Seller Name : ",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data["sname"],
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: [
                    const Text(
                      "Seller number : ",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.data["seller"],
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.data["cname"] != null)
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: [
                      const Text(
                        "Customer name : ",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data["cname"],
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.data["customer"] != null)
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: [
                      const Text(
                        "Customer number : ",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data["customer"],
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Review(
                          widget.data['seller'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.star_outlined,
                    color: Colors.amber,
                  ),
                  label: const Text(
                    "Click to See Seller Reviews",
                  ),
                ),
              ),
              if (widget.did.isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: [
                      const Text(
                        "Postal Delivery ID : ",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.did,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StarReview(
                            widget.data['seller'],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.feedback),
                    label: const Text(
                      "Click to review.",
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
