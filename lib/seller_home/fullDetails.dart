// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

import 'view_menu.dart';

class Elaborate extends StatefulWidget {
  Product data;
  Elaborate(this.data);
  @override
  State<Elaborate> createState() => _ElaborateState();
}

class _ElaborateState extends State<Elaborate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.data.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                child: Hero(
                  tag: widget.data,
                  child: Image.network(
                    "https://abai-194101.000webhostapp.com/women_innovation_hackathon/${widget.data.imageUrl}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Text(
                  "\n\nAbout :\n${widget.data.desc}",
                  maxLines: 5,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  "Quantity Available :\n${widget.data.stock}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  "Price :\n${widget.data.price}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
