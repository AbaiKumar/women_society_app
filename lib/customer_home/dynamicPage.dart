// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../model/data.dart';
import '../seller_home/fullDetails.dart';
import '../seller_home/view_menu.dart';

class YellowBanner extends StatefulWidget {
  late String title, url;
  YellowBanner(this.title, this.url);
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
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                        child: const FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Feel free to buy!!!",
                            overflow: TextOverflow.ellipsis,
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
                        widget.url,
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

class CustMenu extends StatefulWidget {
  late String title, url;
  Data a;
  CustMenu(this.title, this.url, this.a);

  @override
  State<CustMenu> createState() => _CustMenuState();
}

class _CustMenuState extends State<CustMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          YellowBanner(widget.title, widget.url),
          Products(widget.title, widget.a)
        ],
      ),
    );
  }
}

class Products extends StatefulWidget {
  String s;
  Data a;
  Products(this.s, this.a);
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> product = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    await widget.a.firestore.collection("products").get().then((value) {
      for (var i in value.docs) {
        Map<String, dynamic> a = i.data();
        if (a['type'] == widget.s) {
          product.add(
            Product(
              a["id"].toString(),
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
        }
      }
    }).whenComplete(() {
      setState(() {});
    });
  }

  void display(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            msg,
          ),
        ),
      ),
    );
  }

  void confirm(Product pro, String txt, BuildContext context) {
    try {
      var doc = widget.a.firestore
          .collection("Customer")
          .doc(widget.a.phone)
          .collection("Orders")
          .doc();
      doc.set(
        {
          "name": pro.name,
          "description": pro.desc,
          "sellername": pro.sname,
          "customername": widget.a.usrinfo["name"],
          "seller": pro.seller,
          "customer": widget.a.phone,
          "imgUrl": pro.imageUrl,
          "id": pro.id,
          "price": pro.price,
          "type": pro.type,
          "quantity_req": _textController.text,
          "deliver": 0,
          "deliveryId": "",
        },
      );
      var d = widget.a.firestore.collection("Seller").doc(pro.seller);
      String token = "";
      d.get().then(
        (value) {
          token = value.data()!["msgid"];
          List a = value.data()!['order'];
          a.add(doc);
          d.update(
            {
              "order": a,
            },
          );
        },
      ).whenComplete(
        () {
          widget.a.sendNotification(
            "Order !!!",
            "Order recieved from ${widget.a.usrinfo["name"]}",
            token,
          );
          display(context, "Success");
        },
      );
    } catch (e) {
      display(context, "Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: (product.isNotEmpty)
          ? ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(20),
                                            child: Text(
                                              //data print
                                              "Name  : ${product[index].name}",
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                fontFamily: "OpenSans",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(20),
                                            child: Wrap(
                                              children: <Widget>[
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _textController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Enter Quantity : ',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_textController
                                                  .text.isEmpty) {
                                                return;
                                              }
                                              if (int.parse(_textController
                                                          .text) <=
                                                      int.parse(product[index]
                                                          .stock) &&
                                                  int.parse(_textController
                                                          .text) >
                                                      0) {
                                                //order here

                                                confirm(
                                                  product[index],
                                                  _textController.text,
                                                  context,
                                                );
                                                Navigator.of(context).pop();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text("Order confirmed"),
                                                  ),
                                                );
                                              }
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
                                "Order",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(),
    );
  }
}
