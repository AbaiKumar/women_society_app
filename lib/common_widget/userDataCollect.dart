// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDataCollect extends StatefulWidget {
  final String phone, type;
  const UserDataCollect(this.phone, this.type);
  @override
  State<UserDataCollect> createState() => _UserDataCollectState();
}

class _UserDataCollectState extends State<UserDataCollect> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  late TextEditingController name;
  late TextEditingController cname;
  late TextEditingController street;
  late TextEditingController city;
  late TextEditingController state;
  late TextEditingController pin;

  @override
  void dispose() {
    super.dispose();
    street.dispose();
    name.dispose();
    city.dispose();
    state.dispose();
    cname.dispose();
    pin.dispose();
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    cname = TextEditingController();
    street = TextEditingController();
    city = TextEditingController();
    state = TextEditingController();
    pin = TextEditingController();
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  void a(txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
  }

  void save() async {
    try {
      var nm = name.text.toString(),
          workname = (widget.type == "Seller") ? cname.text.toString() : nm,
          strt = street.text.toString(),
          cty = city.text.toString(),
          stat = state.text.toString(),
          code = state.text.toString();

      if ((nm.isEmpty ||
              strt.isEmpty ||
              cty.isEmpty ||
              stat.isEmpty ||
              code.isEmpty) ||
          (widget.type == "Seller" && workname.isEmpty)) {
        a("Fill all details correctly");
        return;
      }
      String url =
          "https://abai-194101.000webhostapp.com/women_innovation_hackathon/datapost.php";
      var response = await http.post(
        Uri.parse(url),
        body: {
          "phone": widget.phone,
          "name": nm,
          "company": workname,
          "street": strt,
          "city": cty,
          "state": stat,
          "code": code
        },
      );

      if (response.body.isNotEmpty) {
        a("Data added Sucessfully");
      } else {
        a("Data not added");
      }
    } catch (error) {
      a("Enter all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: const ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                controlsBuilder: (context, control) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10)),
                          onPressed: (_currentStep == 1) ? save : continued,
                          child: _currentStep == 1
                              ? const Text("submit")
                              : const Text("Continue"),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        TextButton(
                          onPressed: cancel,
                          child: const Text("Back"),
                        ),
                      ],
                    ),
                  );
                },
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: const Text('Personal Details'),
                    content: Column(
                      children: <Widget>[
                        TextField(
                          controller: name,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Residential Address'),
                    content: Column(
                      children: <Widget>[
                        if (widget.type == "Seller")
                          TextField(
                            controller: cname,
                            decoration:
                                const InputDecoration(labelText: 'Work Name'),
                          ),
                        TextField(
                          controller: street,
                          decoration:
                              const InputDecoration(labelText: 'Street'),
                        ),
                        TextField(
                          controller: city,
                          decoration: const InputDecoration(labelText: 'City'),
                        ),
                        TextField(
                          controller: state,
                          decoration: const InputDecoration(labelText: 'State'),
                        ),
                        TextField(
                          controller: pin,
                          decoration:
                              const InputDecoration(labelText: 'Pincode'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
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
