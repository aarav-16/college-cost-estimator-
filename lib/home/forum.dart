import 'dart:math';

import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  var selectedforum = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Great forum"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("How was the experience at SRCC"),
                  onTap: () {
                    setState(() {
                      selectedforum = true;
                    });
                  },
                );
              },
            ),
          ),
          VerticalDivider(),
          Expanded(
              flex: 2,
              child: selectedforum
                  ? Column(
                      children: [Text("How is the experience")],
                    )
                  : Text("there is no forum"))
        ],
      ),
    );
  }
}
