// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/data.dart';
import '../seller_home/fullDetails.dart';

class MyOrders extends StatelessWidget {
  late Data a;
  MyOrders(this.a);

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
  dynamic ppath;

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
    this.ppath,
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
  final TextEditingController _textController = TextEditingController();
  String did = "";
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    product = [];
    if (widget.a.type == "Customer") {
      var a = await widget.a.firestore
          .collection("Customer")
          .doc(widget.a.phone)
          .collection("Orders")
          .get();
      for (var i in a.docs) {
        var d = i.data();
        if (d["deliver"] == 0) {
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
              "",
            ),
          );
          did = d["deliveryId"];
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
        if (d!["deliver"] == 0) {
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
                ""),
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
                    builder: (context) => Elaborate(a, did),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Card(
                  elevation: 1,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Quantity : ${product[index].stock}",
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
                                      (widget.a.type == "Seller")
                                          ? "Customer Name : ${product[index].cname}"
                                          : "Seller Name : ${product[index].sname}",
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
                      if (widget.a.type == "Seller")
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(20),
                                        child: Wrap(
                                          children: <Widget>[
                                            TextField(
                                              controller: _textController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Enter Delivery-ID : ',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_textController.text.isEmpty) {
                                            return;
                                          }
                                          //order here
                                          product[index].ppath.update(
                                            {
                                              "deliver": 1,
                                              "deliveryId":
                                                  _textController.text,
                                            },
                                          );
                                          var pp = await widget.a.firestore
                                              .collection("products")
                                              .get();

                                          for (var i in pp.docs) {
                                            var tmp = i.data();

                                            if (tmp["id"].toString() ==
                                                product[index].id.toString()) {
                                              int v = int.parse(tmp['stock']) -
                                                  int.parse(
                                                    product[index].stock,
                                                  );
                                              i.reference.update(
                                                {
                                                  "stock": v.toString(),
                                                },
                                              );
                                            }
                                          }
                                          getProducts();
                                          String token = "";
                                          widget.a.firestore
                                              .collection("Customer")
                                              .doc(product[index].customer)
                                              .get()
                                              .then((value) {
                                            token = value.data()!["msgid"];
                                          }).whenComplete(() {
                                            widget.a.sendNotification(
                                              "Message from Seller ${widget.a.usrinfo["name"]} !!!",
                                              "Product will reach you soon",
                                              token,
                                            );
                                          });
                                          Navigator.of(context).pop();
                                          FocusScope.of(context).unfocus();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text("Order confirmed"),
                                            ),
                                          );
                                        },
                                        child: const Text("Confirm"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Delivered",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
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
                          "Orders list",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: const Text(
                          "Your Orders List Here",
                          overflow: TextOverflow.ellipsis,
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
                        "assets/icons/orders.png",
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
