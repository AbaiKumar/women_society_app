// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/data.dart';
import '../seller_home/fullDetails.dart';

class History extends StatelessWidget {
  late Data a;
  History(this.a);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.yellow,
      ),
    );
    return Scaffold(
      body: Column(
        children: [YellowBanner(), MyProducts(a)],
      ),
    );
  }
}

class Product {
  final String id,
      desc,
      seller,
      name,
      stock,
      type,
      imageUrl,
      price,
      sname,
      customer,
      cname;

  Product(
    this.id,
    this.desc,
    this.seller,
    this.name,
    this.stock,
    this.type,
    this.imageUrl,
    this.price,
    this.sname,
    this.cname,
    this.customer,
  );
}

class MyProducts extends StatefulWidget {
  Data a;
  MyProducts(this.a);
  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<Product> product = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    //diaply past orders of seller,customer
    product = [];
    if (widget.a.type == "Customer") {
      var a = await widget.a.firestore
          .collection("Customer")
          .doc(widget.a.phone)
          .collection("Orders")
          .get();
      for (var i in a.docs) {
        var d = i.data();
        if (d["deliver"] == "1") {
          product.add(
            Product(
              d["id"],
              d["description"],
              d["seller"],
              d["name"],
              d["quantity_req"],
              d["type"],
              d["imgUrl"],
              d["price"],
              d["sellername"],
              d["customername"],
              d["customer"],
            ),
          );
        }
      }
    } else {
      var a = await widget.a.firestore
          .collection("Seller")
          .doc(widget.a.phone)
          .get();
      List orders = a.data()!["order"];
      for (dynamic i in orders) {
        var cpath = await i.get();
        var d = cpath.data();
        if (d!["deliver"] == 1) {
          product.add(
            Product(
              d["id"].toString(),
              d["description"].toString(),
              d["seller"].toString(),
              d["name"].toString(),
              d["quantity_req"].toString(),
              d["type"].toString(),
              d["imgUrl"].toString(),
              d["price"].toString(),
              d["sellername"].toString(),
              d["customername"].toString(),
              d["customer"],
            ),
          );
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Expanded(
      child: ListView.builder(
          itemCount: product.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                var tmp = product[index];
                Map a = {
                  "name": tmp.name,
                  "desc": tmp.desc,
                  "price": tmp.price,
                  "seller": tmp.seller,
                  "sname": tmp.sname,
                  "imageUrl": tmp.imageUrl,
                  "stock": tmp.stock,
                  "cname": tmp.cname,
                  "customer": tmp.customer,
                };
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Elaborate(a, ""),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Card(
                  elevation: 1,
                  borderOnForeground: true,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                //image widget
                                width: size.width * 0.38,
                                height: size.height * 0.15,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      "https://abai-194101.000webhostapp.com/women_innovation_hackathon/${product[index].imageUrl}",
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.45,
                                margin: EdgeInsets.all(size.width * 0.02),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        //data print
                                        "Name  : ${product[index].name}",
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontFamily: "OpenSans",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        //data print
                                        "Quamtity : ${product[index].stock}",
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontFamily: "OpenSans",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        //data print
                                        "Price : ${product[index].price}",
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontFamily: "OpenSans",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        //data print
                                        "Customer Name : ${product[index].cname}",
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontFamily: "OpenSans",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
    ;
  }
}

class YellowBanner extends StatefulWidget {
  @override
  State<YellowBanner> createState() => _YellowBannerState();
}

class _YellowBannerState extends State<YellowBanner> {
  String name = "Welcome";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double left = size.width * 0.17;
    return Container(
      height: size.height * 0.25,
      width: double.infinity,
      color: Colors.yellow,
      child: Padding(
        padding: EdgeInsets.only(
            left: left * 0.6, right: left * 0.6, top: left, bottom: left * 0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.5,
                        child: const Text(
                          "History",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: ClipRRect(
                      //add border radius
                      child: Image.asset(
                        "assets/icons/history.png",
                        fit: BoxFit.fill,
                        width: 170,
                        height: 170,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
