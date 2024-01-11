import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// class MyChat extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Your App Title',
//       home: Ngobrol("1"), // or any other initial route or widget
//     );
//   }
// }

class Ngobrol extends StatefulWidget {
  final String idJadwal;
  Ngobrol(this.idJadwal);

  @override
  State<Ngobrol> createState() => _NgobrolState();
}

class _NgobrolState extends State<Ngobrol> {
  List<ChatMessages> messages = [];
  final TextEditingController _messageController = TextEditingController();
  String userId = "";
  String error_login = "";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/loadChat.php"),
        body: {'jadwal_id': widget.idJadwal.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var chatMes in json['data']) {
        DateTime dateTimeChat = DateTime.parse(chatMes['tanggal']);
        if (chatMes['users_id'].toString() == userId) {
          String formattedDate =
              DateFormat('dd-MM-yyyy HH:mm').format(dateTimeChat);
          ChatMessages cm = ChatMessages(
              message: chatMes['chat'],
              isUser: true,
              senderName: "You",
              timestamp: formattedDate);
          messages.add(cm);
        } else {
          String formattedDate =
              DateFormat('dd-MM-yyyy HH:mm').format(dateTimeChat);
          ChatMessages cm = ChatMessages(
              message: chatMes['chat'],
              isUser: false,
              senderName: chatMes['nama'],
              timestamp: formattedDate);
          messages.add(cm);
        }
      }
      setState(() {});
    });
  }

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  @override
  void initState() {
    super.initState();
    Future<String> userOnly = checkUser();
    userOnly.then((value) {
      userId = value;
      bacaData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _sendMessage() {
  //   String newMessage = _messageController.text;
  //   if (newMessage.isNotEmpty) {
  //     setState(() {
  //       messages.add(ChatMessages(message: newMessage, isUser: true));
  //       _messageController.clear();
  //     });
  //   }
  // }

  void _sendMessage() async {
    String newMessage = _messageController.text;
    if (newMessage.isNotEmpty) {
      final response = await http.post(
          Uri.parse(
              "https://ubaya.me/flutter/160420002/DolanYuk/sendMessages.php"),
          body: {
            'chat': newMessage,
            'user_id': userId,
            'jadwal_id': widget.idJadwal,
          });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          setState(() {
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);
            messages.add(ChatMessages(
              message: newMessage,
              isUser: true,
              senderName: "You",
              timestamp: formattedDate,
            ));
            _messageController.clear();
          });
        } else {
          print(json['message']);
          setState(() {
            error_login = "Gagal mengunggah pesan";
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    }
  }
}

class ChatMessages extends StatelessWidget {
  final String message;
  final bool isUser;
  final String senderName;
  final String timestamp;

  ChatMessages({
    required this.message,
    required this.isUser,
    required this.senderName,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Text(
              senderName,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            )),
        Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.deepPurple : Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: isUser ? Radius.circular(0) : Radius.circular(16),
                bottomLeft: isUser ? Radius.circular(16) : Radius.circular(0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
