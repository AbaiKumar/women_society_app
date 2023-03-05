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
              color: Colors.black,
              fontFamily: "OpenSans"),
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
                margin: const EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 5, right: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "About : ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: "OpenSans",
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.data["desc"],
                        maxLines: 5,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Times",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Expanded(
                  child: DataTable(
                    // dataRowHeight: 400,
                    columns: const [
                      DataColumn(
                          label: Text('',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text(
                        '',
                      )),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Quantity Available')),
                        DataCell(
                          Text(
                            widget.data["stock"],
                            maxLines: 50,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Price')),
                        DataCell(Text(widget.data["price"])),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Seller Name')),
                        DataCell(Text(widget.data["sname"])),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Seller Number')),
                        DataCell(Text(widget.data["seller"])),
                      ]),
                      if (widget.data["cname"] != null)
                        DataRow(cells: [
                          const DataCell(Text('Customer Name')),
                          DataCell(Text(widget.data["cname"])),
                        ]),
                      if (widget.data["customer"] != null)
                        DataRow(cells: [
                          const DataCell(Text('Customer Number')),
                          DataCell(Text(widget.data["customer"])),
                        ]),
                      if (widget.did.isNotEmpty)
                        DataRow(cells: [
                          const DataCell(Text('Postal DeliveryID')),
                          DataCell(Text(widget.did)),
                        ]),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.did.isNotEmpty)
                      FittedBox(
                        child: Container(
                          alignment: Alignment.center,
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
                              "Add review",
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 2,
                    ),
                    FittedBox(
                      child: Container(
                        alignment: Alignment.center,
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
                            "See reviews",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
