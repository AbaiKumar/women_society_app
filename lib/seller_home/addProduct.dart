// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/data.dart';

class ProductsAdd extends StatefulWidget {
  String txt, id;
  Map data;
  Data obj;
  ProductsAdd(this.txt, this.data, this.obj, this.id);
  @override
  State<ProductsAdd> createState() => _ProductsAddState();
}

class _ProductsAddState extends State<ProductsAdd> {
  final _url = FocusNode(),
      _price = FocusNode(),
      _quantity = FocusNode(),
      _describe = FocusNode(),
      _measure = FocusNode(),
      _glob = GlobalKey<FormState>();
  late File uploadimage = File(""); //variable for choosed file
  late Data obj;
  late String name = "",
      price = "",
      quantity = "",
      desc = "",
      measure = "Painting";

  @override
  void initState() {
    super.initState();
    obj = widget.obj;
    if (widget.data.isEmpty) {
      return;
    }
    var m = widget.data;
    name = m['name'];
    quantity = m['stock'];
    price = m['price'];
    desc = m['description'];
  }

  @override
  void dispose() {
    _url.dispose();
    _price.dispose();
    _quantity.dispose();
    _measure.dispose();
    super.dispose();
  }

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = File(choosedimage!.path.toString());
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

  Future<List> uploadImage(context) async {
    //show your own loading or progressing code here

    String uri =
        "https://abai-194101.000webhostapp.com/women_innovation_hackathon/uploadImage.php";

    try {
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(Uri.parse(uri), body: {
        'image': baseimage,
      });
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["error"]) {
          //check error sent from server
          return [false, jsondata["msg"]];
          //if error return from server, show message from server
        } else {
          return [true, jsondata["msg"]];
        }
      } else {
        return [false, "Error during connection to server"];
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      return [false, "Error during converting to Base64"];
      //there is error during converting file image to base64 encoding.
    }
  }

  Future<void> uploadContent(BuildContext c) async {
    bool val = _glob.currentState!.validate();
    if (widget.data.isEmpty && (!val || uploadimage.path == "")) {
      display(context, "Pick Image and fill details.");
      return;
    }
    _glob.currentState?.save();
    late bool res;
    if (widget.data.isEmpty) {
      //new add
      display(context, "Please wait image uploading...");
      List resp = await uploadImage(context);
      if (resp[0]) {
        var doc = obj.firestore.collection("products").doc();
        doc.set({
          "id": DateTime.now(),
          "name": name,
          "seller": obj.phone,
          "price": price,
          "stock": quantity,
          "description": desc,
          "imgurl": resp[1],
          "type": measure,
          "sellername": obj.usrinfo["name"],
        });
        var path = obj.firestore.collection("Seller").doc(widget.obj.phone);
        path.get().then((value) {
          List a = value.data()!["products"];
          a.add(doc.id);
          value.reference.update(
            {
              "products": a,
            },
          );
        });
        res = true;
      }
    } else {
      var a = await obj.firestore.collection("products").get();
      for (var i in a.docs) {
        var v = i.data();
        if (v["id"].toString() == widget.id) {
          i.reference.update({
            "name": name,
            "price": price,
            "stock": quantity,
            "description": desc,
          });
        }
      }
      res = true;
    }
    if (res) {
      display(context, "Data added.");
      Navigator.of(context).pop();
    } else {
      display(context, "Data not added.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.txt,
            style: const TextStyle(
              color: Colors.black,
            )),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            onPressed: () => uploadContent(context),
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _glob,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 30,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                initialValue: name,
                onChanged: (_) {
                  name = _.toString();
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_describe);
                },
                onSaved: (_) {
                  name = _.toString();
                },
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return "Please mention name ";
                  } else if (str.length > 30) {
                    return "Enter name below 20 characters";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 150,
                focusNode: _describe,
                maxLines: 2,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                initialValue: desc,
                onChanged: (_) {
                  desc = _.toString();
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_measure);
                },
                onSaved: (_) {
                  desc = _.toString();
                },
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return "Please mention name ";
                  } else if (str.length > 150) {
                    return "Enter name below 150 characters";
                  }
                  return null;
                },
              ),
              if (widget.data.isEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: DropdownButtonFormField(
                    value: measure,
                    itemHeight: 50,
                    items: const [
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: "Beauty Product",
                        child: Text("Beauty Product"),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: "Painting",
                        child: Text("Painting"),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: "Food Products",
                        child: Text("Food Products"),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: "Tailoring",
                        child: Text("Tailoring"),
                      )
                    ],
                    onChanged: (_) {
                      measure = _.toString();
                      FocusScope.of(context).requestFocus(_quantity);
                    },
                    onSaved: (str) {
                      measure = str.toString();
                    },
                    validator: (str) {
                      if (str == null || str.toString().isEmpty) {
                        return "Select a type of product";
                      }
                      return null;
                    },
                    focusNode: _measure,
                    hint: const Text("Product Type"),
                  ),
                ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Stock",
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_price);
                },
                onSaved: (str) {
                  quantity = str.toString();
                },
                initialValue: quantity,
                validator: (str) {
                  if (str == null || str.isEmpty || double.parse(str) <= 0) {
                    return "Mention Quantity ";
                  }
                  return null;
                },
                focusNode: _quantity,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Price of 1 piece",
                ),
                initialValue: price,
                onSaved: (str) {
                  price = str.toString();
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_url);
                },
                validator: (str) {
                  if (str == null || str.isEmpty || double.parse(str) <= 0) {
                    return "Mention price ";
                  }
                  return null;
                },
                focusNode: _price,
              ),
              const SizedBox(
                height: 10,
              ),
              //show image here after choosing image
              if (widget.data.isEmpty) ...[
                Container(
                    margin: const EdgeInsets.all(5),
                    height: 150,
                    width: 150,
                    child: Image.file(
                      uploadimage,
                      errorBuilder: (context, error, stackTrace) => Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Choose Image to Upload",
                        ),
                      ),
                      fit: BoxFit.contain,
                    ) //load image from file
                    ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      chooseImage(); // call choose image function
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text("CHOOSE IMAGE"),
                  ),
                ),
              ],
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () {
                          _glob.currentState?.reset();
                        },
                        icon: const Icon(Icons.clear, color: Colors.red),
                        label: const Text('Clear'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () {
                          uploadContent(context);
                        },
                        icon: Icon(
                          Icons.done_outlined,
                          color: Colors.green[800],
                        ),
                        label: widget.data.isEmpty
                            ? const Text('Submit')
                            : const Text('Update'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
