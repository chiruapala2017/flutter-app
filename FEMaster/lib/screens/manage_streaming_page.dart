import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/screens/create_channel_screen.dart';
import 'package:food_app/screens/join_live_streaming_page.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';

import 'live_streaming_page.dart';

class ManageStreamingPage extends StatefulWidget {
  static final id = "manage_streaming_screen";

  @override
  _ManageStreamingPageState createState() => _ManageStreamingPageState();
}

class _ManageStreamingPageState extends State<ManageStreamingPage> {

  Map<String,dynamic> _channelData = Map<String,dynamic>();
  bool showSpinner = true;
  String channel_name='';
  String channel_image='';
  bool editMode = false;
  File channelImg=null;

  @override
  void initState() {
    super.initState();
    getChannelData();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {

    });*/
  }

  void getChannelData() async{
    setState(() {
      showSpinner = true;
    });
    try {
      //print('token :'+token);
      Response response = await get(get_user_channel, headers: {"Authorization": "Token $token"});
      if(response.statusCode == 200) {
        _channelData = json.decode(response.body);
        print(_channelData);
        if(_channelData!=null && !_channelData.isEmpty){
          channel_name = _channelData['channel_name'];
          channel_image  = _channelData['channel_img'];
          editMode = true;
        }
        setState(() {
          showSpinner = false;
        });
      }
    }
    catch (e) {
      print(e);
      AlertDialogWidget alertWidget = AlertDialogWidget(messages: [
        Text("Server error occurs.")
      ], context: this.context);
      await alertWidget.showMyDialog();
      setState(() {
        showSpinner = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Event'),
          backgroundColor: Color(0xFF58B76E),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: (){
                    //Navigator.pushNamed(context, CreateChannelScreen.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateChannelScreen(
                              channelName: channel_name,
                                channelImg: channelImg,
                              editMode: editMode,
                                imageUrl: channel_image,
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    color: Color(0xFF535252),
                    child: Center(
                      child: Text(
                        'Create Channel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, LiveStreamingScreen.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    color: Color(0xFF535252),
                    child: Center(
                      child: Text(
                        'Schedule Live Streaming',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: (){
                    //Navigator.pushNamed(context, LiveStreamingScreen.id);
                    Navigator.pushNamed(context, JoinLiveStramingPage.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    color: Color(0xFF535252),
                    child: Center(
                      child: Text(
                        'Join Session',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
