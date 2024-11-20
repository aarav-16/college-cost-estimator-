import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> feeData = {};
  Map<String, dynamic> extraExpense = {};

  loadcollegedata() async {
    String data = await rootBundle.loadString("asset/scraped_data.json");
    setState(() {
      feeData = json.decode(data);
    });
  }

  loadExpenseData() async {
    String data = await rootBundle.loadString("asset/add_cost.json");
    setState(() {
      extraExpense = json.decode(data);
    });
  }

  List<SelectedCollege> courselist = [];
  SelectedCollege? selectedcourse;
  int cost = 0;
  String finalCost = "";

  @override
  void initState() {
    super.initState();
    loadcollegedata();
  }

  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Cost Estimator"),
        backgroundColor: Colors.blueAccent,
        actions: [
          _auth != null
              ? Text(
                  _auth.email!.split('@')[0].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login'),
                ),
          const SizedBox(width: 10),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign Out')),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forum');
            },
            child: const Text('Forum'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Welcome to my college cost estimator! After collecting data from 100+ current students and alumni from the University of Delhi, I've come up with this tool to estimate your final college costs.",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("College Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 20),
                    const Text("Course Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 20),
                    const Text("Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: selectedcourse != null
                          ? [
                              DropdownMenuItem(
                                value: "sc",
                                onTap: () {
                                  finalCost = selectedcourse!.sc;
                                  setState(() {});
                                },
                                child: const Text("SC/ST"),
                              ),
                              DropdownMenuItem(
                                value: "urobcminority",
                                onTap: () {
                                  finalCost = selectedcourse!.urobcminority;
                                  setState(() {});
                                },
                                child: const Text("OBC/UR"),
                              ),
                              DropdownMenuItem(
                                value: "pwd",
                                onTap: () {
                                  finalCost = (selectedcourse!.pwd);
                                  setState(() {});
                                },
                                child: const Text("PWD"),
                              )
                            ]
                          : [],
                      onChanged: (val) {},
                    ),
                    const SizedBox(height: 20),
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
                            style: const TextStyle(
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
