import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/account_cookbook_screen.dart';
import 'package:food_app/screens/account_preference_screen.dart';
import 'package:food_app/screens/account_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:food_app/utils/urls.dart';
import 'package:food_app/utils/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:food_app/screens/fitbit_screen.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final int tabIndex;

  const ProfileHeaderWidget({Key key, this.tabIndex}) : super(key: key);

  @override
  _ProfileHeaderWidgetState createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  File file;
  final picker = ImagePicker();
  String image_orientation = null;
  bool showSpinner = false;
  String userFullName="Chiranjib Bakchi";
  String followers="1M";
  String following="10K";
  String profileImg/*="https://i.picsum.photos/id/1005/5760/3840.jpg?hmac=2acSJCOwz9q_dKtDZdSB-OIK1HUcwBeXco_RMMTUgfY"*/;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    String url = user_profile_url;
    setState(() {
      showSpinner = true;
    });
    try {
      final Response response = await get(url, headers: {
        "Authorization": "Token $token",
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      setState(() {
        userFullName = responseData['results']['user']['name'];
        followers = responseData['results']['user']['followers'].toString();
        following = responseData['results']['user']['following'].toString();
        profileImg = responseData['results']['user']['profile_img'];
        profileImageUrl = profileImg != null ? profileImg : null;
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }

  _imgFromCamera() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      file = File(image.path);
      profileImage = file;
    });
    
    getImageOrientaion(file);
  }

  getImageOrientaion(File file) async{
    Map<String, IfdTag> data =
        await readExifFromBytes(await file.readAsBytes());
    String orientaion = data['Image Orientation'].toString();
    setState(() {
      if(orientaion.contains('Horizontal')){
        image_orientation = 'Horizontal';
      }
      else{
        image_orientation = 'Vertical';
      }
      profileImageOrientation = image_orientation;
      print(image_orientation);
    });
  }

  _imgFromGallery() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      file = File(image.path);
      profileImage = file;
    });

    getImageOrientaion(file);
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

  Future<bool> isFitbitAccountLinked() async {
    String url = fitbit_user_data_url;
    try {
      Response response = await get(
          url, headers: {"Authorization": "Token $token"});
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        if (responseData['status_code'] == 200) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(url: "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22BZFZ&2Ffitbit_auth&code_challenge=SUkRwWrE0TNdeIjN37WcsFUXzguGFG_jqZ2JZVD9ZNI&code_challenge_method=S256&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight", androidToolbarColor: Colors.deepPurple);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                //color: Colors.green,
                height: 45.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () {
                        // do something
                      },
                    )
                  ],
                ),
              ),
              Container(
                //color: Colors.pink,
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 55.0,
                        backgroundColor: Colors.white,
                        child: profileImg != null ?
                            CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(profileImg),
                            ):
                            file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(55.0),
                                child: Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: image_orientation == 'Horizontal' ? BoxFit.fitHeight : BoxFit.fitWidth,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                      onTap: () {
                        _showPicker(context);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: MediaQuery.of(context).size.width*.42,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$userFullName',
                                style: TextStyle(
                                    color: Color(0xFF535252), fontSize: 15.0),
                              ),
                            ],
                          ),
                          // Text(
                          //   'Kolkata',
                          //   style: TextStyle(color: Color(0xFF535252)),
                          // ),
                          Text(
                            '$followers Followers $following Following',
                            style: TextStyle(color: Color(0xFF535252)),
                          ),
                          GestureDetector(
                            child: Text(
                              'Fitbit Account',
                              style: TextStyle(color: Color(0xFF535252)),
                            ),
                            onTap: () async {
                              bool accountLinked = await isFitbitAccountLinked();
                              if (accountLinked) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FitbitScreen()
                                    )
                                );
                              } else {
                                openBrowserTab();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Edit Profile',
                        style:
                            TextStyle(color: Color(0xFF58B76E), fontSize: 17.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.amber,
                height: 50.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/border_line.png',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Text(
                            'Recipes',
                            style: TextStyle(
                                color: widget.tabIndex == 1
                                    ? Color(0xFF58B76E)
                                    : Color(0xFF535252),
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            if(widget.tabIndex != 1){
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountScreen(
                                        index: 1,
                                      )));
                            }

                          },
                        ),
                        GestureDetector(
                          child: Text(
                            'Preferences',
                            style: TextStyle(
                                color: widget.tabIndex == 2
                                    ? Color(0xFF58B76E)
                                    : Color(0xFF535252),
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            if(widget.tabIndex != 2){
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountPreferenceScreen(
                                        index: 2,
                                      )));
                            }
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            'Cookbook',
                            style: TextStyle(
                                color: widget.tabIndex == 3
                                    ? Color(0xFF58B76E)
                                    : Color(0xFF535252),
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            if(widget.tabIndex != 3){
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountCookbookScreen(
                                        index: 3,
                                      )));
                            }

                          },
                        )
                      ],
                    ),
                    Image.asset(
                      'images/border_line.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
