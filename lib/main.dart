import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(TodoApp());
}

class GroupMember {
  String name;
  String mobileNumber;
  String? subTitle;
  String? profileImage;
  bool isAdmin;

  GroupMember({
    required this.name,
    required this.mobileNumber,
    this.subTitle ='',
    this.profileImage ='',
    this.isAdmin = false,
  });
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<GroupMember> groupMembers = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  AudioPlayer audioPlayer = AudioPlayer();

  void addGroupMember(GroupMember member) {
    setState(() {
      groupMembers.add(member);
    });
  }

  void deleteGroupMember(int index) {
    setState(() {
      groupMembers.removeAt(index);
    });
  }

  void viewGroupMember(GroupMember member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(member.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mobile Number: ${member.mobileNumber}'),
              Text('Subtitle: ${member.subTitle ?? ''}'),
              if (member.profileImage != null)
                Image.network(member.profileImage!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<GroupMember> searchGroupMembers(String query) {
    return groupMembers.where((member) {
      final name = member.name.toLowerCase();
      final mobileNumber = member.mobileNumber.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          mobileNumber.contains(query.toLowerCase());
    }).toList();
  }

  // Future<void> playAudio(String audioUrl) async {
  //   int result = await audioPlayer.play(audioUrl);
  //   if (result == 1) {
  //     print('Audio played successfully');
  //   } else {
  //     print('Error playing audio');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Members',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Group Members'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      String name = _nameController.text.trim();
                      String mobile = _mobileController.text.trim();
                      if (name.isNotEmpty && mobile.isNotEmpty) {
                        addGroupMember(
                          GroupMember(name: name, mobileNumber: mobile),
                        );
                        _nameController.clear();
                        _mobileController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groupMembers.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = groupMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: member.profileImage != null
                          ? NetworkImage(member.profileImage!)
                          : null,
                    ),
                    title: Text(member.name),
                    subtitle: Text(member.subTitle ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteGroupMember(index),
                    ),
                    onTap: () => viewGroupMember(member),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
