import 'dart:io';

import 'package:rtmp_publisher/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String channel_name;
String appUserId;
String token;
String email;
String profileImageUrl;
File profileImage;
File recipeImage;
String profileImageOrientation;
var recipeObject = {};
var channelObj = {};
var mealPlans = [];
List<CameraDescription> cameras = [];
String timezone;
List<CameraDescription> cameraDescriptions = List<CameraDescription>();
//Map<String,dynamic> channelData = Map<String,dynamic>();

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputDecoration = InputDecoration(
  fillColor: Color(0xFFF2F0F0),
  filled: true,
  hintText: 'Enter your value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF2F0F0), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF2F0F0), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);

const kInputFieldDecoration = InputDecoration(
  fillColor: Color(0xFFF2F0F0),
  filled: true,
  hintText: 'Enter your value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF2F0F0), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF2F0F0), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Map<String,String> timeZones = {
  "IST" : "Asia/Kolkata",
  "AWST" : "Australia/Perth",
  "ACST" : "Australia/Darwin",
  "AEST" : "Australia/Brisbane"
};