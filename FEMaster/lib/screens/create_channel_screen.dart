import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:food_app/screens/manage_streaming_page.dart';

class CreateChannelScreen extends StatefulWidget {
  static final id = "create_channel_name_screen";

  final String channelName;
  final File channelImg;
  final bool editMode;
  final String imageUrl;

  const CreateChannelScreen(
      {Key key,
      this.channelName,
      this.editMode,
      this.channelImg,
      this.imageUrl})
      : super(key: key);
  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  bool showSpinner = true;
  String channel_name;
  String prefferedLanguage;
  bool editFlag = false;

  File file;
  File recipeImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //file = widget.channelImg;
    editFlag = widget.editMode;
    channel_name = widget.channelName;
    getImageByUrl(widget.imageUrl);
  }

  Future<void> getImageByUrl(String imageUrl) async {
    setState(() {
      showSpinner=true;
    });
    file = await urlToFile(imageUrl);
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<File> urlToFile(String imageUrl) async {

    if (imageUrl != null && !imageUrl.isEmpty) {
      var rng = new Random();
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file =
          new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
      http.Response response = await http.get(imageUrl);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    }
    else{
      return null;
    }
  }

  _imgFromCamera() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      file = File(image.path);
      //recipeImage = file;
    });
  }

  _imgFromGallery() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      file = File(image.path);
      //recipeImage = file;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Channel'),
          backgroundColor: Color(0xFF58B76E),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'channel name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Color(0xFF535252)),
                      ),
                      TextFormField(
                        initialValue: widget.channelName,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            channel_name = value.trim();
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'Channel Image',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                  color: Color(0xFF535252)),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  file != null ? Colors.white : Color(0xFFFFDF95),
                              border: Border.all(color: Color(0xFFF16906))),
                          width: double.infinity,
                          height: 200,
                          child: file != null
                              ? ClipRRect(
                                  /*borderRadius: BorderRadius.circular(55.0),*/
                                  child: Image.file(
                                    file,
                                    fit: BoxFit.fitWidth,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 30.0,
                                      color: Color(0xFFF16906),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        'Upload a photo of your dish',
                                        style:
                                            TextStyle(color: Color(0xFFF16906)),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: RoundedButton(
                    buttonColor: Color(0xFF58B76E),
                    buttonAction: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });

                        if (editFlag) {

                          var uri = Uri.parse(create_user_channel);
                          var request = http.MultipartRequest('PUT', uri);

                          request.fields['channel_name'] = channel_name;
                          request.files.add(
                              await http.MultipartFile.fromPath(
                                  'channel_img', file.path
                              )
                          );
                          request.headers['Authorization'] = "Token $token";

                          var response = await request.send();
                          final responseData = await response.stream.bytesToString();

                          setState(() {
                            showSpinner = false;
                          });
                          if (response.statusCode == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, ManageStreamingPage.id);
                            AlertDialogWidget alertWidget = AlertDialogWidget(
                                messages: [
                                  Text("Channel has been successfully edited")
                                ],
                                context: this.context);
                            await alertWidget.showMyDialog();

                          } else {

                            throw Exception();
                          }
                        } else {
                          var uri = Uri.parse(create_user_channel);
                          var request = http.MultipartRequest('POST', uri);

                          request.fields['channel_name'] = channel_name;
                          request.files.add(
                              await http.MultipartFile.fromPath(
                                  'channel_img', file.path
                              )
                          );
                          request.headers['Authorization'] = "Token $token";

                          var response = await request.send();
                          final responseData = await response.stream.bytesToString();

                          setState(() {
                            showSpinner = false;
                            editFlag=!editFlag;
                          });
                          if (response.statusCode == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, ManageStreamingPage.id);
                            AlertDialogWidget alertWidget = AlertDialogWidget(
                                messages: [
                                  Text("Channel has been successfully created")
                                ],
                                context: this.context);
                            await alertWidget.showMyDialog();
                          } else {
                            throw Exception();
                          }
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          showSpinner = false;
                        });
                        AlertDialogWidget alertWidget = AlertDialogWidget(
                            messages: [Text("Something went wrong")],
                            context: this.context);
                        await alertWidget.showMyDialog();
                      }
                    },
                    buttonName: 'Save',
                  ),
                )
                /*_RTMPVideo()*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
