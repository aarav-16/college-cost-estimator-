import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> feeData = {};

  loadcollegedata() async {
    String data = await rootBundle.loadString("asset/scraped_data.json");
    setState(() {
      feeData = json.decode(data);
    });
  }

  List<SelectedCollege> courselist = [];
  SelectedCollege? selectedcourse;
  String finalCost = "";

  @override
  void initState() {
    super.initState();
    loadcollegedata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Cost Estimator"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background image from the network
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Welcome to my college cost estimator! After collecting data from 100+ current students and alumni from the University of Delhi, I've come up with this tool to estimate your final college costs.",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("College Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: feeData.keys
                          .map<DropdownMenuItem<String>>((String college) {
                        return DropdownMenuItem<String>(
                          value: college,
                          child: Text(college),
                        );
                      }).toList(),
                      onChanged: (val) {
                        List list = feeData[val];
                        courselist.clear();
                        for (var e in list) {
                          courselist.add(SelectedCollege.fromJson(e));
                        }
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 20),
                    Text("Course Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: courselist.map<DropdownMenuItem<String>>((course) {
                        return DropdownMenuItem<String>(
                          value: course.program,
                          child: Text(course.program),
                          onTap: () {
                            selectedcourse = course;
                            setState(() {});
                          },
                        );
                      }).toList(),
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 20),
                    Text("Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: selectedcourse != null
                          ? [
                              DropdownMenuItem(
                                child: Text("SC/ST"),
                                value: "sc",
                                onTap: () {
                                  finalCost = selectedcourse!.sc;
                                  setState(() {});
                                },
                              ),
                              DropdownMenuItem(
                                child: Text("OBC/UR"),
                                value: "urobcminority",
                                onTap: () {
                                  finalCost = selectedcourse!.urobcminority;
                                  setState(() {});
                                },
                              ),
                              DropdownMenuItem(
                                child: Text("PWD"),
                                value: "pwd",
                                onTap: () {
                                  finalCost = (selectedcourse!.pwd);
                                  setState(() {});
                                },
                              )
                            ]
                          : [],
                      onChanged: (val) {},
                    ),
                    SizedBox(height: 20),
                    if (finalCost.isNotEmpty)
                      Card(
                        color: Colors.lightGreenAccent.shade100,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Estimated Final Cost: ₹$finalCost",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Image.asset(
              "asset/test.image.jpg",
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

// SelectedCollege Class remains the same
class SelectedCollege {
  String program;
  String urobcminority;
  String sc;
  String st;
  String pwd;

  SelectedCollege({
    required this.program,
    required this.urobcminority,
    required this.sc,
    required this.st,
    required this.pwd,
  });

  factory SelectedCollege.fromJson(Map<String, dynamic> json) =>
      SelectedCollege(
        program: json["program"],
        urobcminority: json["urobcminority"],
        sc: json["sc"],
        st: json["st"],
        pwd: json["pwd"],
      );

  Map<String, dynamic> toJson() => {
        "program": program,
        "urobcminority": urobcminority,
        "sc": sc,
        "st": st,
        "pwd": pwd,
      };
}
