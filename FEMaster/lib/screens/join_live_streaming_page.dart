import 'dart:convert';

import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/components/event_details.dart';
import 'package:food_app/components/rounded_button.dart';
import 'package:food_app/screens/rtmp_receiver_screen.dart';
import 'package:food_app/utils/constants.dart';
import 'package:food_app/utils/urls.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'contact_page_screen.dart';
import 'event_details_screen.dart';

class JoinLiveStramingPage extends StatefulWidget {
  static final id = "join_live_streaming_screen";

  @override
  _JoinLiveStramingPageState createState() => _JoinLiveStramingPageState();
}

class _JoinLiveStramingPageState extends State<JoinLiveStramingPage> {
  String liveUrl;
  bool showSpinner = true;

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = DateTime(date.year, date.month, date.day);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;
  List<String> channelList = List<String>();
  Map<DateTime, List> _events = Map<DateTime, List>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSessionData();
    DateTime today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day);
    _selectedEvents = _events[_selectedDay] ?? [];
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
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        //print(responseData);
        Map<String, dynamic> sessions = responseData["invited_sessions"];
        setState(() {
          sessions.forEach((key, value) {
            //print(value["session_url"]);
            DateTime datetime = new DateTime(
                int.parse(key.split("-")[0].toString()),
                int.parse(key.split("-")[1].toString()),
                int.parse(key.split("-")[2].toString()));
            List<dynamic> sessionsByDate = value;
            List<Map<String, dynamic>> elementsByDate =
                List<Map<String, dynamic>>();
            sessionsByDate.forEach((element) {
              Map<String, dynamic> elementData = element;
              //print(elementData);
              String name = elementData["description"] != null
                  ? elementData["description"]
                  : "Session on some dishes";
              String from = elementData["start_time"].toString().split(":")[0] +
                  ":" +
                  elementData["start_time"].toString().split(":")[1];
              String to = elementData["end_time"].toString().split(":")[0] +
                  ":" +
                  elementData["end_time"].toString().split(":")[1];
              String url = elementData["session_url"];
              bool isDone = true;
              String language = elementData["language"] != null ? elementData["language"] : 'English';
              var channelImg = elementData['channel_img'];
              var encodedChannelImg = Uri.encodeFull(channelImg);

              Map<String, dynamic> sessionData = Map<String, dynamic>();
              sessionData.putIfAbsent('name', () => name);
              sessionData.putIfAbsent('from', () => from);
              sessionData.putIfAbsent('to', () => to);
              sessionData.putIfAbsent('url', () => url);
              sessionData.putIfAbsent('isDone', () => isDone);
              sessionData.putIfAbsent('language', () => language);
              //var uri = new Uri.http(imgName,channelImg.toString());
              sessionData.putIfAbsent('channelImg', () => channelImg);
              elementsByDate.add(sessionData);
            });
            _events.putIfAbsent(datetime, () => elementsByDate);
            print(elementsByDate);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Join Events'),
          backgroundColor: Color(0xFF58B76E),
          centerTitle: true,
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
          //padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Container(
            height: 100.0,
            color: Color(0xFF404040),
            child: ListTile(
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*.65,
                      //color: Colors.brown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Channel: "+_selectedEvents[index]['name'].toString()+" ("+_selectedEvents[index]['language'].toString()+")",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "From: "+_selectedEvents[index]['from'].toString().substring(11,16),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            ),
                          ),
                          Text(
                            "To: "+_selectedEvents[index]['to'].toString().substring(11,16),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*.20,
                      margin: EdgeInsets.only(bottom: 8.0),
                      height: 75,
                      //color: Colors.amberAccent,
                      child: _selectedEvents[index]['channelImg']!=null ? Image.network(_selectedEvents[index]['channelImg']) : Image.asset("images/cooking_skill4.png"),
                    )
                  ],
                ),
              ),
              onTap: () async {
                /*DateTime selectedStartDate = new DateTime(
                    _selectedDay.year,
                    _selectedDay.month,
                    _selectedDay.day,
                    int.parse(_selectedEvents[index]['from']
                        .toString()
                        .split(":")[0]),
                    int.parse(_selectedEvents[index]['from']
                        .toString()
                        .split(":")[1]));
                DateTime selectedEndDate = new DateTime(
                    _selectedDay.year,
                    _selectedDay.month,
                    _selectedDay.day,
                    int.parse(
                        _selectedEvents[index]['to'].toString().split(":")[0]),
                    int.parse(
                        _selectedEvents[index]['to'].toString().split(":")[1]));*/
                DateTime selectedStartDate = DateTime.parse(_selectedEvents[index]['from'].toString());
                DateTime selectedEndDate = DateTime.parse(_selectedEvents[index]['to'].toString());

                //int timediff = todayDate.millisecondsSinceEpoch - selectedDate.millisecondsSinceEpoch;
                //Duration timediff = selectedStartDate.difference(DateTime.now());
                print(DateTime.now().isAfter(selectedStartDate));
                print(DateTime.now().isBefore(selectedEndDate));

                if (DateTime.now().isAfter(selectedStartDate) &&
                    DateTime.now().isBefore(selectedEndDate)) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RtmpReceiverScreen(
                                liveUrl: _selectedEvents[index]['url'],
                              )));
                } else {
                  AlertDialogWidget alertWidget = AlertDialogWidget(messages: [
                    Text("The selected live streaming is not currently active")
                  ], context: this.context);
                  await alertWidget.showMyDialog();
                }
              },
            ),
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }

  List<Container> generateChannelList() {
    List<Container> roundedBtns = List<Container>();

    channelList.forEach((element) {
      roundedBtns.add(Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: RoundedButton(
          buttonColor: Colors.black54,
          buttonAction: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RtmpReceiverScreen(
                          liveUrl: element,
                        )));
          },
          buttonName: element,
        ),
      ));
    });

    return roundedBtns;
  }
}
