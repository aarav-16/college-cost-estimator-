import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_cost_estimator/auth/usermodel.dart';
import 'package:college_cost_estimator/forum/forum_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  var selectedforum = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance.currentUser;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _replyController = TextEditingController();

  ForumModel? currentForum;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to log in to add a forum post.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addForumFunction() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      try {
        var forum = ForumModel(
            title: title,
            description: description,
            userId: _auth!.uid,
            addedDate: Timestamp.fromDate(DateTime.now()));

        await FirebaseFirestore.instance.collection('forum').add(forum.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Forum post added successfully!')),
          );
        }
        _titleController.clear();
        _descriptionController.clear();
      } catch (e) {
        log(e.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Something went wrong while adding the Forum')),
          );
        }
      }
    }
  }

  Future<void> _addReplyFunction(String forumId) async {
    if (_formKey.currentState!.validate()) {
      final reply = _replyController.text.trim();

      try {
        var req = ReplyModel(
            replyText: reply,
            forumId: forumId,
            userId: _auth!.uid,
            addedDate: Timestamp.fromDate(DateTime.now()));

        await FirebaseFirestore.instance
            .collection('forumReply')
            .add(req.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Forum reply added successfully!')),
          );
        }
        _replyController.clear();
      } catch (e) {
        log(e.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Something went wrong while adding the forum reply')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Community Forum"),
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Home'),
          ),
          const SizedBox(width: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (FirebaseAuth.instance.currentUser != null) {
            setState(() {
              selectedforum = false;
            });
          } else {
            _showLoginDialog(context);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('forum').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    var forumList = snapshot.data!.docs
                        .map((forum) => ForumModel.fromMap(forum))
                        .toList();
                    if (forumList.isEmpty) {
                      return const Center(
                          child: Text('No Forum Added, add a forum to see'));
                    }
                    return ListView.builder(
                      itemCount: forumList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(forumList[index].title),
                          subtitle: Text(
                            forumList[index].description,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                          ),
                          onTap: () {
                            setState(() {
                              currentForum = forumList[index];
                              selectedforum = true;
                            });
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No Data!!'));
                  }
                }),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 4,
            child: (selectedforum && currentForum != null)
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            currentForum!.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Text(currentForum!.description),
                          const SizedBox(height: 10),
                          const Text(
                            'Replies',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('forumReply')
                                .where('forumId',
                                    isEqualTo: currentForum!.forumId.toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                var replies = snapshot.data!.docs
                                    .map((reply) => ReplyModel.fromMap(reply))
                                    .toList();
                                if (replies.isEmpty) {
                                  return const Text(
                                      'No Replies yet, add your reply');
                                }
                                return Column(
                                  children: List.generate(
                                    replies.length,
                                    (index) => StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(replies[index].userId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            var user = Usermodel.fromMap(
                                                snapshot.data!);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 12,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(user.username),
                                                        Text(replies[index]
                                                            .replyText),
                                                        const Divider(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return const Text('Loading');
                                        }),
                                  ),
                                );
                              }
                              return const Text('No Replies yet');
                            },
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Add your reply',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _replyController,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    _addReplyFunction(currentForum!.forumId!);
                                  },
                                  child: const Text('Comment'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Add a forum',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: _addForumFunction,
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
