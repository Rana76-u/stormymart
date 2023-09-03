import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../Components/custom_image.dart';

class ChatScreen extends StatefulWidget {
  //final String sellerId;
  //final String userId;
  String? productId;

  ChatScreen({
    super.key,
    //required this.sellerId,
    //required this.userId,
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
      await _firestore
          .collection('messages')
          .doc(uid)
          .collection('message').add({
        'text': text,
        'senderId': 'user',
        //'receiverId': widget.sellerId,
        'productId': widget.productId ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _firestore
          .collection('messages')
          .doc(uid). set({
        'isSeen': false
      });

      setState(() {
        widget.productId = '';
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
              "Chat with Seller",
              textStyle: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis
              ),
            )
          ],
        ),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        backgroundColor: Colors.blue[400],
      ),
      body: Column(
        children: <Widget>[

          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .doc(uid)
                  .collection('message')
                  //.where('senderId', whereIn: [uid, widget.sellerId])
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
                  final messageTime = message['timestamp'];
                  final messageProductId = message['productId'];
                  final messageWidget = MessageWidget(
                    text: messageText,
                    isMe: messageSender == 'user',
                    timestamp: messageTime,
                    productId: messageProductId,
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
  final Timestamp timestamp;
  final String productId;

  const MessageWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.productId
  });

  @override
  Widget build(BuildContext context) {
    String? userPhoto = FirebaseAuth.instance.currentUser!.photoURL;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        //TimeStamp
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
              DateFormat('EE, dd/MM H:mm').format(timestamp.toDate()).toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey
            ),
          ),
        ),

        //Product Information
        productId != '' ?
          isMe ?
          Row(
            children: [
            const Expanded(child: SizedBox()),

            //product info
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  //Pulls image from variation 1's 1st image
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: FutureBuilder(
                      future: FirebaseFirestore
                          .instance
                          .collection('/Products/$productId/Variations').get(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          String docID = snapshot.data!.docs.first.id;
                          return FutureBuilder(
                            future: FirebaseFirestore
                                .instance
                                .collection('/Products/$productId/Variations').doc(docID).get(),
                            builder: (context, imageSnapshot) {
                              if(imageSnapshot.hasData){
                                return CustomImage(
                                  imageSnapshot.data?['images'][0],
                                  radius: 10,
                                  width: 200,
                                  height: 210,//210
                                );
                              }
                              else if(imageSnapshot.connectionState == ConnectionState.waiting){
                                return const Center(
                                  child: LinearProgressIndicator(),
                                );
                              }
                              else{
                                return const Center(
                                  child: Text(
                                    "Nothings Found",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
                        else if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        }
                        else{
                          return const Center(
                            child: Text(
                              "Nothings Found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  //title, price
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    child: FutureBuilder(
                      future: FirebaseFirestore
                          .instance
                          .collection('/Products')
                          .doc(productId)
                          .get(),
                      builder: (context, productSnapshot) {
                        if(productSnapshot.hasData){
                          String title = productSnapshot.data!.get('title') ?? '';
                          String price = productSnapshot.data!.get('price').toString();
                          return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //title
                                Text(
                                  title,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Urbanist',
                                      color: Colors.black
                                  ),
                                ),
                                //price
                                Text(
                                  'Price: $price',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      fontFamily: 'Urbanist',
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        else if(productSnapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        }
                        else{
                          return const Center(
                            child: Text('Error Loading Data'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

              const SizedBox(width: 15,),
          ],
        )
            :
          Row(
            children: [
              //Space
              const SizedBox(width: 15,),

            //product info
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  //Pulls image from variation 1's 1st image
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: FutureBuilder(
                      future: FirebaseFirestore
                          .instance
                          .collection('/Products/$productId/Variations').get(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          String docID = snapshot.data!.docs.first.id;
                          return FutureBuilder(
                            future: FirebaseFirestore
                                .instance
                                .collection('/Products/$productId/Variations').doc(docID).get(),
                            builder: (context, imageSnapshot) {
                              if(imageSnapshot.hasData){
                                return CustomImage(
                                  imageSnapshot.data?['images'][0],
                                  radius: 10,
                                  width: 200,
                                  height: 210,//210
                                );
                              }
                              else if(imageSnapshot.connectionState == ConnectionState.waiting){
                                return const Center(
                                  child: LinearProgressIndicator(),
                                );
                              }
                              else{
                                return const Center(
                                  child: Text(
                                    "Nothings Found",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
                        else if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        }
                        else{
                          return const Center(
                            child: Text(
                              "Nothings Found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  //title, price
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    child: FutureBuilder(
                      future: FirebaseFirestore
                          .instance
                          .collection('/Products')
                          .doc(productId)
                          .get(),
                      builder: (context, productSnapshot) {
                        if(productSnapshot.hasData){
                          String title = productSnapshot.data!.get('title') ?? '';
                          String price = productSnapshot.data!.get('price').toString();
                          return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //title
                                Text(
                                  title,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Urbanist',
                                      color: Colors.black
                                  ),
                                ),
                                //price
                                Text(
                                  'Price: $price',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      fontFamily: 'Urbanist',
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        else if(productSnapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        }
                        else{
                          return const Center(
                            child: Text('Error Loading Data'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Expanded(child: SizedBox()),
          ],
        )
              :
        const SizedBox(),

        isMe ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //Space from left
            const Expanded(child: SizedBox()),

            //Text Container
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 10),
                  child: Text(
                    FirebaseAuth.instance.currentUser!.displayName ?? '',
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey
                    ),
                  ),
                ),

                //message
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                        overflow: TextOverflow.clip,
                        letterSpacing: 0.3
                    ),
                  ),
                ),
              ],
            ),

            //user image
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 8, bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: userPhoto != null ? Image.network(
                  userPhoto,
                  height: 18,
                  width: 18,
                )
                    :
                const Icon(Icons.person_rounded),
              ),
            )
          ],
        )
            :
        Row(
          children: [
            //Store Icon
            Container(
              padding: const EdgeInsets.all(8.0),
              //margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                  Icons.store,
                color: Colors.grey,
                size: 16,
              ),
            ),

            //Text Container
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                    overflow: TextOverflow.clip,
                    letterSpacing: 0.3
                ),
              ),
            ),

            //Space from left
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}
