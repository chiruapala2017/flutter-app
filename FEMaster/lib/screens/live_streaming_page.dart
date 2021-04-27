import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/event_details.dart';
import 'package:food_app/screens/show_live_vide_screen.dart';
import 'package:food_app/screens/rtmp_sender_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'event_details_screen.dart';
import 'meal_planner_screen.dart';

class LiveStreamingScreen extends StatefulWidget {
  static final id = "live_streaming_screen";
  @override
  _LiveStreamingScreenState createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = DateTime(date.year, date.month, date.day);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;

  Map<DateTime, List> _events = Map<DateTime, List>();
  bool showSpinner = true;


  @override
  void initState() {
    super.initState();
    getAllSessionData();
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day);
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  Future<void> initTimezones() async {

  }

  getAllSessionData() async {
    setState(() {
      showSpinner = true;
    });
    try {
      String offset = DateTime.now().timeZoneOffset.toString().split(".")[0];
      Map<String, String> queryParams = {
        'utc_offset': offset,
      };
      String queryString = Uri(queryParameters: queryParams).query;

      Response response = await get(get_all_sessions+"?"+queryString, headers: {"Authorization": "Token $token"});
      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = json.decode(response.body);
        //print(responseData);
        Map<String, dynamic> sessions = responseData["started_sessions"];
        //print(sessions);
        setState(() {
          sessions.forEach((key, value) {
            //print(value["session_url"]);
            DateTime datetime = new  DateTime(int.parse(key.split("-")[0].toString()), int.parse(key.split("-")[1].toString()), int.parse(key.split("-")[2].toString()));
            List<dynamic> sessionsByDate = value;
            List<Map<String,dynamic>> elementsByDate = List<Map<String,dynamic>>();

            sessionsByDate.forEach((element)
            {
              Map<String, dynamic> elementData = element;
              //print(elementData);
              String name = elementData["description"] != null ? elementData["description"] : "Session on some dishes";
              String from = elementData["start_time"].toString().split(":")[0]+":"+elementData["start_time"].toString().split(":")[1];
              String to = elementData["end_time"].toString().split(":")[0]+":"+elementData["end_time"].toString().split(":")[1];
              String url = elementData["session_url"];
              bool isDone = true;

              Map<String, dynamic> sessionData = Map<String, dynamic>();
              sessionData.putIfAbsent('name', () => name);
              sessionData.putIfAbsent('from', () => from);
              sessionData.putIfAbsent('to', () => to);
              sessionData.putIfAbsent('url', () => url);
              sessionData.putIfAbsent('isDone', () => isDone);
              elementsByDate.add(sessionData);
            });
            _events.putIfAbsent(datetime, () => elementsByDate);
          });
          DateTime today = DateTime.now();
          _selectedDay = DateTime(today.year, today.month, today.day);
          _selectedEvents = _events[_selectedDay] ?? [];
        });
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
        backgroundColor: Color(0xFF58B76E),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              //_showPicker(context);
              setState(() {
                EventDetails details = new EventDetails('', DateTime.now().add(new Duration(minutes: 15)), null, null, "");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(
                          eventDetails: details,
                          mode: 'add',
                        )));
              });
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Calendar(
                  startOnMonday: true,
                  weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                  events: _events,
                  initialDate: new DateTime.now(),
                  onRangeSelected: (range) =>
                      print("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _handleNewDate(date),
                  isExpandable: true,
                  eventDoneColor: Colors.green,
                  selectedColor: Colors.pink,
                  todayColor: Colors.blue,
                  eventColor: Colors.grey,
                  dayOfWeekStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 11),
                ),
              ),
              _buildEventList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {

    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedEvents[index]['name'].toString()),
                Text(_selectedEvents[index]['from'].toString().substring(11,16)),
              ],
            ),
            onTap: () async {

              DateTime selectedStartDate = DateTime.parse(_selectedEvents[index]['from'].toString());
              DateTime selectedEndDate = DateTime.parse(_selectedEvents[index]['to'].toString());
              //DateTime selectedEndDate  = new DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, int.parse(_selectedEvents[index]['to'].toString().split(":")[0]), int.parse(_selectedEvents[index]['to'].toString().split(":")[1]));
              print(DateTime.now().isAfter(selectedStartDate));
              print(DateTime.now().isBefore(selectedEndDate));

              if(DateTime.now().isAfter(selectedStartDate) && DateTime.now().isBefore(selectedEndDate)){

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => /*ShowLiveVideoScreen*/RtmpSenderScreen(
                            sessionUrl: _selectedEvents[index]['url'],
                          sessionName: _selectedEvents[index]['name'].toString()
                        )));
              }else{
                if((DateTime.now().isBefore(selectedStartDate))){
                  AlertDialogWidget alertWidget =
                  AlertDialogWidget(messages: [
                    Text("Your streaming session is not ready. Please wait for sometime")
                  ], context: this.context);
                  await alertWidget.showMyDialog();
                }
                else if(DateTime.now().isAfter(selectedEndDate)){
                  AlertDialogWidget alertWidget =
                  AlertDialogWidget(messages: [
                    Text("Your streaming session ended. Please create a new straming session")
                  ], context: this.context);
                  await alertWidget.showMyDialog();
                }

              }


            },
          ),
          ),
        itemCount: _selectedEvents.length,
      ),
    );
  }
}
