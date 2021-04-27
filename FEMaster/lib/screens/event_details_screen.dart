import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/event_details.dart';
import 'package:food_app/screens/show_live_vide_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:http/http.dart';

import 'contact_page_screen.dart';
import 'live_streaming_page.dart';
/*import 'package:language_pickers/languages.dart';
import 'package:language_pickers/language_pickers.dart';*/

class EventDetailsScreen extends StatefulWidget {
  static final id = "event_details_screen";
  final EventDetails eventDetails;
  final String mode;

  const EventDetailsScreen({Key key, this.eventDetails, this.mode})
      : super(key: key);
  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool editFlag = false;
  String mode;
  DateTime fromDate;
  DateTime toDate;
  int fromHr;
  int fromMin;

  int toHr;
  int toMin;

  String sessionName;
  bool showSpinner = false;

  String start_time;
  String end_time;
  String invite_all;
  String invitees;
  String language;

  String sessionUrl;

  @override
  void initState() {
    print(DateTime.now().toString());
    fromDate = widget.eventDetails.getDate();
    toDate = fromDate.add(new Duration(hours: 1));

    start_time = fromDate.year.toString() +
        '-' +
        fromDate.month.toString() +
        '-' +
        fromDate.day.toString() +
        ' ' +
        fromDate.hour.toString() +
        ":" +
        fromDate.minute.toString();

    end_time = toDate.year.toString() +
        '-' +
        toDate.month.toString() +
        '-' +
        toDate.day.toString() +
        ' ' +
        toDate.hour.toString() +
        ":" +
        toDate.minute.toString();

    sessionName = widget.eventDetails.getChannelName();
    mode = widget.mode;
    print(token);
    sessionUrl = widget.eventDetails.getUrl();
    super.initState();
  }

  /*Widget _buildDropdownItem(Language language) {
    return Container(
      width: MediaQuery.of(context).size.width*.3,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text("${language.name} (${language.isoCode})",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Color(0xFF535252)),),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Session Details'),
            backgroundColor: Color(0xFF58B76E),
            centerTitle: true),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: ListView(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  //color: Color(0xFF535252),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Color(0xFF535252)),
                      ),
                      TextFormField(
                        initialValue: sessionName,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            sessionName = value.trim();
                          });
                        },
                      )
                    ],
                  )),
              /*Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width*1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children :[
                    Text('Choose Language',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Color(0xFF535252)),),
                    Container(
                      //margin: EdgeInsets.symmetric(horizontal: 5.0),
                      height: 30.0,
                      decoration: BoxDecoration(
                        //color: const Color(0xff7c94b6),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: LanguagePickerDropdown(
                        initialValue: 'en',
                        itemBuilder: _buildDropdownItem,
                        onValuePicked: (Language lan) {
                          //print(lan.name);
                          setState(() {
                            language=lan.name;
                          });
                          //print(lan.isoCode);
                        },
                      ),
                    ),
                  ]
                ),
              ),*/
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Scheduled From',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF535252)),
                ),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                //initialValue: DateTime.now().toString(),
                initialValue: fromDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                use24HourFormat: false,
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  if (date.weekday == 6 || date.weekday == 7) {
                    return false;
                  }

                  return true;
                },
                onChanged: (val) {
                  print("Date is " + val);
                  setState(() {
                    start_time = val;
                    String date = start_time.split(" ")[0];
                    String time = start_time.split(" ")[1];
                    fromDate = new DateTime(
                        int.parse(date.split("-")[0]),
                        int.parse(date.split("-")[1]),
                        int.parse(date.split("-")[2]),
                        int.parse(time.split(":")[0]),
                        int.parse(time.split(":")[1]));
                  });
                },
                validator: (val) {
                  print(val);
                  return null;
                },
                enabled: true,
                onSaved: (val) => print(val),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Scheduled To',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF535252)),
                ),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                //initialValue: DateTime.now().toString(),
                initialValue: toDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                use24HourFormat: false,
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  if (date.weekday == 6 || date.weekday == 7) {
                    return false;
                  }

                  return true;
                },
                onChanged: (val) {
                  print(val);
                  setState(() {
                    end_time = val;
                    String date = end_time.split(" ")[0];
                    String time = end_time.split(" ")[1];
                    toDate = new DateTime(
                        int.parse(date.split("-")[0]),
                        int.parse(date.split("-")[1]),
                        int.parse(date.split("-")[2]),
                        int.parse(time.split(":")[0]),
                        int.parse(time.split(":")[1]));
                  });
                },
                validator: (val) {
                  print(val);
                  return null;
                },
                enabled: true,
                onSaved: (val) => print(val),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () async {
                  //_showPicker(context);
                  DateTime currentDate = DateTime.now();
                  if (fromDate.isBefore(toDate)) {

                    if (fromDate.isAfter(currentDate)) {
                      if(sessionName!=null && sessionName!=""){
                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          Object body = {
                            'start_time': start_time+":00",
                            'end_time': end_time+":00",
                            'invite_all': 'True',
                            'invitees': '',
                            'description': sessionName,
                            'utc_offset': DateTime.now().timeZoneOffset.toString().split(".")[0],
                            'language': language!=null ? language : 'English'
                          };

                          print(body);
                          Response response = await post(start_live_session,
                              body: body,
                              headers: {"Authorization": "Token $token"});
                          setState(() {
                            showSpinner = false;
                          });
                          if (response.statusCode == 200) {
                            final Map<String, dynamic> responseData =
                            json.decode(response.body);
                            print(responseData);
                            responseData.forEach((key, value) {
                              setState(() {
                                if (key == "url") {
                                  sessionUrl = value;
                                  print(sessionUrl);
                                }
                              });
                            });

                            this.editFlag = !this.editFlag;
                            AlertDialogWidget alertWidget = AlertDialogWidget(
                                messages: [
                                  Text("Your live streaming channel has been successfully created")
                                ],
                                action: goBackToPreviousPage(),
                                context: this.context);
                            await alertWidget.showMyDialog();


                          } else {
                            throw Exception();
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
                      }
                      else{
                        AlertDialogWidget alertWidget =
                        AlertDialogWidget(messages: [
                          Text("Please enter a session name")
                        ], context: this.context);
                        await alertWidget.showMyDialog();
                      }

                    } else {
                      AlertDialogWidget alertWidget =
                          AlertDialogWidget(messages: [
                        Text("Please schedule current date or any next date")
                      ], context: this.context);
                      await alertWidget.showMyDialog();
                    }
                  } else {
                    AlertDialogWidget alertWidget = AlertDialogWidget(
                        messages: [
                          Text("From date can not be less than toDate")
                        ],
                        context: this.context);
                    await alertWidget.showMyDialog();
                  }
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    color: Color(0xFF535252),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save Your Stream',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goBackToPreviousPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, LiveStreamingScreen.id);
  }
}
