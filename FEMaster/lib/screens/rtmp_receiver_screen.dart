import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RtmpReceiverScreen extends StatefulWidget {
  final String liveUrl;
  static final id = "rtmp_receiver_screen";

  const RtmpReceiverScreen({Key key, this.liveUrl}) : super(key: key);

  @override
  _RtmpReceiverScreenState createState() => _RtmpReceiverScreenState();
}

class _RtmpReceiverScreenState extends State<RtmpReceiverScreen> {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  Timer _timer;
  String message = '';

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      widget.liveUrl,
    );
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    // Use the controller to loop the video.
    _controller.setLooping(true);

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        print("_controller.value.isPlaying is :"+_controller.value.isPlaying.toString());
        if(_controller.value.initialized){
          if(!_controller.value.isPlaying){
            //_controller.play();
            isPlaying = false;
            //print('Controller inactive');
            message = 'Streaming is not active';
          }
          else{
            isPlaying = true;
          }

          //print('Controller active');
        }
        else{
          isPlaying = false;
          message = 'Streaming is not active';
          _controller.pause();
          /*if(_controller.value.isPlaying){
            //_controller.play();
            isPlaying = false;
            //print('Controller inactive');
            message = 'Streaming is not active';
          }else{
            isPlaying = false;
            //print('Controller inactive');
            message = 'Streaming is not active';
          }*/

        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit live session'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
              _timer.cancel();
              _controller.removeListener(() { });
            } ,
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Butterfly Video'),
        ),
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            print('snapshot.connectionState :'+snapshot.connectionState.toString());
            print('_controller.value.initialized :'+_controller.value.initialized.toString());

            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                //aspectRatio: _controller.value.size.width/_controller.value.size.height,
                aspectRatio: _controller.value.size !=null ? _controller.value.size.width/_controller.value.size.height : _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Center(child: VideoPlayer(_controller)),
                    ClosedCaption(text: _controller.value.caption.text),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                    !isPlaying ? Center(child: Text('$message', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)) : Container()
                  ],
                ),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            setState(() {
              print('_controller.value.initialized in FloatingActionButton:'+_controller.value.initialized.toString());
              if(!_controller.value.initialized){
                _controller = VideoPlayerController.network(
                  widget.liveUrl,
                );
                _initializeVideoPlayerFuture = _controller.initialize();
                _controller.setLooping(true);
              }

              // If the video is playing, pause it.
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                // If the video is paused, play it.
                _controller.play();
              }
            });
          },
          // Display the correct icon depending on the state of the player.
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  /*VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.liveUrl,
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('Connected'),
        backgroundColor: Color(0xFF58B76E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(padding: const EdgeInsets.only(top: 20.0)),
            *//*const Text('RTMP Video'),*//*
            Container(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                    ClosedCaption(text: _controller.value.caption.text),
                    _PlayPauseOverlay(controller: _controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }*/
}

/*class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No streaming', style: TextStyle(color: Colors.white, fontSize: 17.0,)),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 100.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print("controller.value.isBuffering :"+controller.value.isBuffering.toString());
            print("controller.value.isPlaying :"+controller.value.isPlaying.toString());
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}*/
