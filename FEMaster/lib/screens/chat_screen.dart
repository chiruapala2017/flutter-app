import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:food_app/utils/constants.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChatScreen extends StatefulWidget {
  static final id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /*FirebaseUser user;
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  String messageText;
  String email;
  bool showSpinner = false;

  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      user = await _auth.currentUser();
      email = user.email;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog(List<Text> messages) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: messages,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: ()async {
                await deleteAllMessage();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void messageStream() async {
    await for (var snapshot in _fireStore.collection('flashchat').snapshots()) {
      for (var document in snapshot.documents) {
        print(document.data);
      }
    }
  }

  Future<void> deleteAllMessage() async{
    await for (var snapshot in _fireStore.collection('flashchat').snapshots()) {
      for (var document in snapshot.documents) {
        if(document.data['sender'].toString() == email){
          document.reference.delete();
        }
      }
    }
    Navigator.of(context).pop();
  }*/

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  List<Text> texts = List<Text>();
                  texts.add(Text('All the messages will be deleted'));
                  texts.add(Text('Do you want to proceed'));
                  await _showMyDialog(texts);
                  //await deleteAllMessage();
                } catch (e) {
                  print(e);
                }
              }
          ),
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              }
          )

        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('flashchat').orderBy('time', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.amber,
                    ),
                  );
                } else {
                  final messages = snapshot.data.documents;
                  List<MessageBubble> messageWidget = [];
                  for (var message in messages) {
                    var messageText = message.data['text'];
                    var messageSender = message.data['sender'];
                    var messageTime = message.data['time'];

                    bool isMe;
                    if(email == messageSender){
                      isMe = true;
                    }else{
                      isMe = false;
                    }
                    final messagewidget = MessageBubble(messageSender: messageSender,messageText: messageText,isMe: isMe,);
                    messageWidget.add(messagewidget);
                  }

                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      children: messageWidget,
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        setState(() {
                          messageText = value;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                      if(messageText!=null){
                        textEditingController.clear();
                        _fireStore
                            .collection('flashchat')
                            .add({'text': messageText, 'sender': email, 'time' : Timestamp.now()});
                      }else{

                        List<Text> texts = List<Text>();
                        texts.add(Text('Message is empty'));
                        AlertDialogWidget alertWidget = AlertDialogWidget(
                            messages: texts,
                            action: (){
                              Navigator.of(context).pop();
                            },
                            context: this.context
                        );
                        await  alertWidget.showMyDialog();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );*/
  }


}

class MessageBubble extends StatelessWidget {
  final messageText;
  final messageSender;
  final isMe;

  const MessageBubble({Key key, this.messageText, this.messageSender, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe != true?CrossAxisAlignment.start :  CrossAxisAlignment.end,
        children: [
          Text('$messageSender', style: TextStyle(fontSize: 15.0),),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: isMe != true ? Colors.lightBlueAccent : Colors.orange.shade500,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Text(
                '$messageText',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
