// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, use_build_context_synchronously, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import '../model/data.dart';

class MyLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white, // #f9fd37
          resizeToAvoidBottomInset:
              true, //Not move widgets up when keyboard appear
          body: SafeArea(
            child: LoginWidget(),
          ),
        );
      },
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  var passwordVis = false;
  var check = 0;
  var formkey = GlobalKey<FormState>();
  var usr = FocusNode();
  var pass = FocusNode();
  var but = FocusNode();
  dynamic usrname, pwd, cnf;
  String? dropDownValue;
  List dropdown = ["Seller", "Customer"]; //types of login

  void change(int val) {
    setState(() {
      check = val;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future show(str1) {
    //show alert dialog box
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(str1),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (str1 == "Sucess!!!") {
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
        content: Text(str1),
      ),
    );
  }

  Future<void> saveLogin(BuildContext context, Data d) async {
    //for login
    FocusScope.of(context).requestFocus(but);
    formkey.currentState!.save();
    if (formkey.currentState!.validate() == false) {
      //form validation
      return;
    }
    try {
      var phone = usrname.toString().trim();
      var password = pwd.toString().trim();
      String url =
          "https://abai-194101.000webhostapp.com/women_innovation_hackathon/login.php?phone=$phone&password=$password";

      var res = await http.get(Uri.parse(url));
      var type = res.body.toString();
      if (type != "Failed ") {
        //redirect page
        final prefs = await SharedPreferences.getInstance(); //cache storage
        final firestore = FirebaseFirestore.instance;
        prefs.setString('phone', phone);
        prefs.setString('type', type);
        var token = await FirebaseMessaging.instance
            .getToken(); //get Messaging token device-id
        firestore.collection(type).doc(phone).update(
          {"msgid": token}, //update token when login to firestore
        );
        d.trigger(phone, type);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text(
                "Failed",
              ),
            ),
          ),
        );
      }
    } catch (error) {
      show("Firebase throws error!!!");
    }
    return;
  }

  Future<void> saveSignup(BuildContext context) async {
    //for signup
    FocusScope.of(context).requestFocus(but);
    formkey.currentState!.save();
    if (formkey.currentState!.validate() == false) {
      //form validate
      return;
    }
    try {
      var phone = usrname.toString().trim();
      var password = pwd.toString().trim();
      final url =
          "https://abai-194101.000webhostapp.com/women_innovation_hackathon/signup.php?phone=$phone&password=$password&type=$dropDownValue";
      var res = await http.get(Uri.parse(url));
      if (res.body == "success") {
        //set login info to mysql
        final firestore = FirebaseFirestore.instance;
        firestore.collection(dropDownValue.toString()).doc(phone).set({
          "phone": phone,
          "type": dropDownValue.toString(),
          "products": []
        }); //set logn info to firestore

        //redirect page
        change(0);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text(
                "Failed",
              ),
            ),
          ),
        );
      }
    } catch (error) {
      show("Firebase throws error!!!");
    }
    return;
  }

  @override
  void dispose() {
    //dipose all widget foces..
    super.dispose();
    usr.dispose();
    formkey.currentState != null ? formkey.currentState!.dispose() : null;
    pass.dispose();
    but.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white),
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.09,
            ),
            SizedBox(
              //image widget
              width: width * 0.45,
              height: height * 0.20,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(width * 0.3),
                  ),
                  child: Image.asset(
                    "assets/images/society.jpeg",
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              //empty space
              height: height * 0.03,
            ),
            //Form Widget.....
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              width: width * 0.85,
              child: Form(
                //form widget start here
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      //for username
                      keyboardType: TextInputType.phone,
                      focusNode: usr,
                      maxLength: 10,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        label: const Text(
                          "Mobile Number",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        prefixIcon: const Icon(
                          Icons.phone,
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(pass);
                      },
                      onSaved: (str) {
                        usrname = str!;
                      },
                      validator: (str) {
                        if (str == null || str == "" || str.length < 10) {
                          return "Enter Mobile Number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    TextFormField(
                      //for password
                      obscureText: !passwordVis,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      focusNode: pass,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        label: const Text(
                          "Password",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(but);
                        pwd = _;
                      },
                      onSaved: (str) {
                        pwd = str!;
                      },
                      validator: (str) {
                        if (str == null || str == "") {
                          return "Enter Password";
                        }
                        return null;
                      },
                    ),
                    if (check == 1) ...[
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Center(
                        //for signup only,selecting login type.
                        child: Container(
                          width: width * 0.6,
                          margin: const EdgeInsets.only(
                            top: 10,
                            bottom: 5,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                              ),
                              iconEnabledColor: Colors.amber,
                              isExpanded: true,
                              hint: const FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Select type of login",
                                ),
                              ),
                              value: dropDownValue,
                              items: [
                                ...dropdown.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                              ],
                              onChanged: (v) {
                                setState(() {
                                  dropDownValue = v.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    Row(
                      //show password widget
                      children: [
                        Checkbox(
                            value: passwordVis,
                            onChanged: (val) {
                              setState(() {
                                passwordVis = !passwordVis;
                              });
                            }),
                        Text(
                          "Show Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                          ),
                        ),
                      ],
                    ),
                    //form button
                    SizedBox(
                      width: width * 0.4,
                      child: ElevatedButton(
                        onPressed: () {
                          if (check == 1) {
                            saveSignup(context);
                          } else {
                            saveLogin(context,
                                Provider.of<Data>(context, listen: false));
                          }
                        },
                        focusNode: but,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // #b3f53b
                          elevation: 0,
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          check == 0 ? "LOGIN" : "REGISTER",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    if (check == 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.033,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.030,
                                ),
                              ),
                              onTap: () => change(1),
                            )
                          ],
                        ),
                      ),
                    if (check != 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.030,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.035,
                                ),
                              ),
                              onTap: () => change(0),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
