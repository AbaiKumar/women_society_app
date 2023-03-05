// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:society_app_for_women/common_widget/orders.dart';
import 'package:society_app_for_women/seller_home/addProduct.dart';
import 'package:society_app_for_women/seller_home/fullDetails.dart';
import '../model/data.dart';

class ViewMenu extends StatelessWidget {
  late Data a;
  ViewMenu(this.a);

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: null,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductsAdd("Add Product!", const {}, a),
              ),
            );
          },
          icon: const Icon(
            Icons.add,
            color: Colors.red,
          ),
        ),
      ),
      body: Column(
        children: [YellowBanner(), MyProducts(a)],
      ),
    );
  }
}

class Product {
  final String id, desc, seller, name, stock, type, imageUrl, price, sname;
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
    var a =
        await widget.a.firestore.collection("Seller").doc(widget.a.phone).get();
    var b = widget.a.firestore.collection("products");
    List<dynamic> c = a.data()!['products'];
    if (c.isEmpty) {
      return;
    }
    for (String i in c) {
      b.doc(i).get().then((value) {
        Map<String, dynamic>? a = value.data();
        product.add(
          Product(
            a!["id"].toString(),
            a["description"].toString(),
            a["seller"].toString(),
            a["name"].toString(),
            a["stock"].toString(),
            a["type"].toString(),
            a["imgurl"].toString(),
            a["price"].toString(),
            a["sellername"].toString(),
          ),
        );
      }).whenComplete(() {
        setState(() {});
      });
    }
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    //data print
                                    "Name  : ${product[index].name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: "OpenSans",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    //data print
                                    "Stock : ${product[index].stock}",
                                    overflow: TextOverflow.ellipsis,
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
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: "OpenSans",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              Product a = product[index];
                              return ProductsAdd(
                                "Edit Product!",
                                {
                                  "name": a.name,
                                  "description": a.desc,
                                  "stock": a.stock,
                                  "price": a.price,
                                },
                                widget.a,
                              );
                            }),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Product"),
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
                          "View Your Products",
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
