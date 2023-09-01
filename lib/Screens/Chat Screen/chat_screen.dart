import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String sellerId;
  final String userId;
  final String? productId;

  const ChatScreen({
    super.key,
    required this.sellerId,
    required this.userId,
    this.productId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  //FirebaseAuth.User? _user;
  String uid = '';

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    uid = _auth.currentUser!.uid;
  }

  void _sendMessage(String text) async {
    if (uid != '') {
      await _firestore.collection('messages').add({
        'text': text,
        'senderId': uid,
        'receiverId': widget.sellerId,
        'productId': widget.productId ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'isSeen': false
      });
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
                'Chat with Seller',
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  overflow: TextOverflow.clip,
                  letterSpacing: 0.3
              ),
              curve: Curves.bounceIn,
              speed: const Duration(milliseconds: 100)
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .where('senderId', whereIn: [uid, widget.sellerId])
                  //.where('receiverId', whereIn: [uid, widget.sellerId])
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<DocumentSnapshot> messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['text'];
                  final messageSender = message['senderId'];
                  final messageWidget = MessageWidget(
                    text: messageText,
                    isMe: messageSender == uid,
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),

          //Typing Doc
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      maxHeight: 150,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       color: Colors.grey.shade200
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        child: TextField(
                          controller: _messageController,
                          maxLines: null,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            hintText: ' Aa . . .',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade200,
                  ),
                  child: IconButton(
                    icon: const Icon(
                        Icons.send,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(_messageController.text);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;

  const MessageWidget({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              text,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  overflow: TextOverflow.clip,
                  letterSpacing: 0.3
              ),
            )
          ],
        ),
      ),
    );
  }
}
