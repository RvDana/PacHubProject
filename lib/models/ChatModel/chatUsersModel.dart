import 'package:pachub/models/ChatModel/user.dart';

class Message {
  final User? sender;
  final String? time;
  final DateTime? tim; // Would usually be type DateTime or Firebase Timestamp in production apps
// Would usually be type DateTime or Firebase Timestamp in production apps
  final String? text;
  final bool unread;
  final String? email;
   bool isSelected;
  final bool isSentByMe;


  Message({
    this.sender,
    this.time,
    this.text,
    required this.unread,
    this.email,
    required this.isSelected,
    required this.isSentByMe,
    this.tim,
  });
}



// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: janeCooper,
    time: '4hr ago',
    text: 'In a laoreet purus. Integer turpis quam, laoreet id orci nec.',
    unread: false,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
  Message(
    sender: janeCooper,
    time: '3hr ago',
    text: 'In a laoreet purus. Integer turpis quam, laoreet id orci nec, ultrices lacinia nunc. Aliquam erat volutpat. .',
    unread: false,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,
  ),
];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: janeCooper,
    time: '4hr ago',
    text: 'Amet minim mollit non deseru...',
    unread: true,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,
  ),
  Message(
    sender: ralphEdwards,
    time: '8hr ago',
    text: 'Amet minim mollit non deseru...',
    unread: true,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
  Message(
    sender: brooklynSimmons,
    time: '6hr ago',
    text: 'Amet minim mollit non deseru...',
    unread: false,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
  Message(
    sender: albertFlores,
    time: '5hr ago',
    text: 'Amet minim mollit non deseru...',
    unread: true,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
  Message(
    sender: cameronWilliamson,
    time: '1hr ago',
    text: 'Amet minim mollit non deseru...',
    unread: false,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
  Message(
    sender: kristinWatson,
    time: '45mins ago',
    text: 'Amet minim mollit non deseru...',
    unread: false,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
  Message(
    sender: jennyWilson,
    time: '30mins ago',
    text: 'Amet minim mollit non deseru...',
    unread: false,
    email: '@jane',
    isSelected: false,
    isSentByMe: false,

  ),
];
