import 'package:rtmp_publisher/camera.dart';
import 'package:flutter/material.dart';
// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:food_app/components/alert_dialog_widget.dart';
import 'package:food_app/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class ShowLiveVideoScreen extends StatefulWidget {
  static final id = "show_live_video_screen";
  final String sessionUrl;

  const ShowLiveVideoScreen({Key key,@required this.sessionUrl}) : super(key: key);
  @override
  _ShowLiveVideoScreenState createState() => _ShowLiveVideoScreenState();
}

class _ShowLiveVideoScreenState extends State<ShowLiveVideoScreen> with WidgetsBindingObserver{
  CameraController controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  String message='';
  String imagePath;
  String videoPath;
  String url;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  bool useOpenGL = true;
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
  int ts = DateTime.now().millisecondsSinceEpoch;
  String signedValue = "";
  TextEditingController _textFieldController;
  Timer _timer;
  String rtmpStr = "";

  bool startMode=true;
  bool isfront= true;
  bool isMute=false;

  @override
  void initState() {
    //initializeCameras();
    /*var tobeSignedStr = '/live/stream-'+ts.toString()+'-nodemedia2017privatekey';
    signedValue = generateMd5(tobeSignedStr);
    rtmpStr = "rtmp://3.17.56.170:1935/live/stream?sign="+ts.toString()+"-"+signedValue;*/

    //_initializeCamera();
    _textFieldController = TextEditingController(
        text: widget.sessionUrl);
    super.initState();
    onNewCameraSelected(cameraDescriptions[1]);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    controller = CameraController(firstCamera,ResolutionPreset.high);
    _initializeControllerFuture = controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // App state changed before we got the chance to initialize.
    print("state is "+state.toString());
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
    } else if (state == AppLifecycleState.resumed) {
      print("controller.description is");
      print(controller.description);
      if (controller != null) {
        //_initializeControllerFuture = controller.initialize();
        //onNewCameraSelected(controller.description);

        print("is video streaming :"+controller.value.isStreamingVideoRtmp.toString()+" controller.value.isInitialized "+controller.value.isInitialized.toString());
        if(controller.value.isStreamingVideoRtmp && controller.value.isInitialized) {
          //await reInitializeCameraWithRtmp();
          await resumeVideoStreaming();
        }else{
          onNewCameraSelected(controller.description);
        }
        //startVideoStreaming();
      }else{
        null;
      }
    }
  }

  Future<void> reInitializeCameraWithRtmp() async {
    await controller.dispose();
    controller = CameraController(
      isfront ? cameraDescriptions[1] :  cameraDescriptions[0],
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
    );

    controller.addListener(() {
      //print("mounted before");
      //print(mounted);
      if (mounted) setState(() {return;});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
        if (_timer != null) {
          _timer.cancel();
          _timer = null;
        }
        Wakelock.disable();
      }
    });

    try {
      await controller.initialize();
      //_initializeControllerFuture = controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    new Future.delayed(const Duration(milliseconds: 2000), () async {
      String myUrl = await _getUrl();

      try {
        if (_timer != null) {
          _timer.cancel();
          _timer = null;
        }
        url = myUrl;
        //await controller.startVideoStreaming(url);
        await controller.startVideoStreaming(url);

        _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
          //var stats = await controller.getStreamStatistics();
          //print(stats);
        });
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Camera example'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: _cameraPreviewWidget(),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: controller != null && controller.value.isRecordingVideo
                        ? controller.value.isStreamingVideoRtmp
                        ? Colors.orangeAccent
                        : Colors.orangeAccent
                        : controller != null &&
                        controller.value.isStreamingVideoRtmp
                        ? Colors.grey
                        : Colors.grey,
                    width: 3.0,
                  ),
                ),
              ),
            ),
            Container(
              color: Color(0xFF404040),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _captureControlRowWidget(),
                  _toggleAudioWidget(),
                  _cameraTogglesRowWidget(),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          children: [
            CameraPreview(controller),
            Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(message, style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),),
            ))
          ],
        ),
      );
    }
  }

  Future<void> reInitializeCameraWith(bool isAudioEnable) async {
    await controller.dispose();
    controller = CameraController(
      isfront ? cameraDescriptions[1] :  cameraDescriptions[0],
      ResolutionPreset.medium,
      enableAudio: isAudioEnable,
      androidUseOpenGL: useOpenGL,
    );

    controller.addListener(() {
      //print("mounted before");
      //print(mounted);
      if (mounted) setState(() {return;});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
        if (_timer != null) {
          _timer.cancel();
          _timer = null;
        }
        Wakelock.disable();
      }
    });

    try {
      await controller.initialize();
      //_initializeControllerFuture = controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

  }

  Future<void> reInitializeStream(){
    new Future.delayed(const Duration(milliseconds: 2000), () async {
      String myUrl = await _getUrl();

      try {
        if (_timer != null) {
          _timer.cancel();
          _timer = null;
        }
        url = myUrl;
        //await controller.startVideoStreaming(url);
        await controller.startVideoStreaming(url);

        _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
          //var stats = await controller.getStreamStatistics();
          //print(stats);
        });
        //enableAudio=!enableAudio;
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
    });
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return enableAudio ? MaterialButton(
      onPressed: () {
        setState(() async {
          if (controller != null && !controller.value.isStreamingVideoRtmp) {
            onNewCameraSelected(controller.description);
            enableAudio=!enableAudio;
          }
          else{
            //onNewCameraSelected(controller.description);
            //enableAudio=!enableAudio;

            //reInitializeCameraWith(false).then((value) => reInitializeStream());

            AlertDialogWidget alertWidget =
            AlertDialogWidget(messages: [
              Text("Please stop the streaming and change the settings.")
            ], context: this.context);
            await alertWidget.showMyDialog();

            //reInitializeCameraWithRtmpWithAudioControl(false);

            /*reInitializeCameraWithRtmp();
            enableAudio=!enableAudio;*/
          }
        });
      },
      color: Colors.white,
      textColor: Colors.blue,
      child: Icon(
        Icons.volume_up,
        size: 30,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    ) : MaterialButton(
      onPressed: () {
        setState(() async{
          if (controller != null && !controller.value.isStreamingVideoRtmp) {
            onNewCameraSelected(controller.description);
            enableAudio=!enableAudio;
          }
          else{
            /*onNewCameraSelected(controller.description);
            enableAudio=!enableAudio;*/
            //reInitializeCameraWith(true).then((value) => reInitializeStream());

            //reInitializeCameraWithRtmpWithAudioControl(true);

            AlertDialogWidget alertWidget =
            AlertDialogWidget(messages: [
              Text("Please stop the streaming and change the settings")
            ], context: this.context);
            await alertWidget.showMyDialog();
          }
        });
      },
      color: Colors.white,
      textColor: Colors.blue,
      child: Icon(
        Icons.volume_off,
        size: 30,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );

  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imagePath == null
                ? Container()
                : SizedBox(
              child: (videoController == null)
                  ? Image.file(File(imagePath))
                  : Container(
                child: Center(
                  child: AspectRatio(
                      aspectRatio:
                      videoController.value.size != null
                          ? videoController.value.aspectRatio
                          : 1.0,
                      child: VideoPlayer(videoController)),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink)),
              ),
              width: 64.0,
              height: 64.0,
            ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {

    return startMode ?
      MaterialButton(
        onPressed: controller != null &&
            controller.value.isInitialized &&
            !controller.value.isStreamingVideoRtmp
            ? onVideoStreamingButtonPressed
            : null,
        color: Colors.white,
        textColor: Colors.blue,
        child: Icon(
          Icons.play_circle_outline,
          size: 30,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      )
     :
      MaterialButton(
        onPressed: controller != null &&
            controller.value.isInitialized &&
            (controller.value.isRecordingVideo ||
                controller.value.isStreamingVideoRtmp)
            ? onStopButtonPressed
            : null,
        color: Colors.red,
        textColor: Colors.white,
        child: Icon(
          Icons.stop,
          size: 30,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      );

  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];
    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      return !isfront ? MaterialButton(
          onPressed: () async{

            print("isStreamingVideoRtmp "+this.controller.value.isStreamingVideoRtmp.toString());
            setState(() {
              isfront = !isfront;
            });
            if(controller != null && controller.value.isStreamingVideoRtmp){
              AlertDialogWidget alertWidget =
              AlertDialogWidget(messages: [
                Text("Please stop the streaming before switching camera.")
              ], context: this.context);
              await alertWidget.showMyDialog();
            }else{
              onNewCameraSelected(cameraDescriptions[1]);
            }

            //onStopButtonPressed();
          },
          color: Colors.white,
          textColor: Colors.blue,
          child: Icon(getCameraLensIcon(cameraDescriptions[1].lensDirection), size: 30,),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ) :
      MaterialButton(
        onPressed: () async{

          print("isStreamingVideoRtmp "+this.controller.value.isStreamingVideoRtmp.toString());
          setState(() {
            isfront = !isfront;
          });
          if(controller != null && controller.value.isStreamingVideoRtmp){
            AlertDialogWidget alertWidget =
            AlertDialogWidget(messages: [
              Text("Please stop the streaming before switching camera.")
            ], context: this.context);
            await alertWidget.showMyDialog();
          }else{
            onNewCameraSelected(cameraDescriptions[0]);
          }
        },
        color: Colors.white,
        textColor: Colors.blue,
        child: Icon(getCameraLensIcon(cameraDescriptions[0].lensDirection), size: 30,),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      );

    }

    //return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      print("controller is active");
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,

    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      //print("mounted before");
      //print(mounted);
      if (mounted) setState(() {return;});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
        if (_timer != null) {
          _timer.cancel();
          _timer = null;
        }
        Wakelock.disable();
      }
    });

    try {
      //await controller.initialize();
      _initializeControllerFuture = controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    //print("mounted after");
    //print(mounted);
    if (!mounted) {
      setState(() {return;});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
      Wakelock.enable();
    });
  }

  void onVideoStreamingButtonPressed() {
    startVideoStreaming().then((String url) {
      new Future.delayed(const Duration(milliseconds: 2000), () async {
        print("after init :"+controller.value.isStreamingVideoRtmp.toString());
        if(controller.value.isStreamingVideoRtmp){
          setState(() {
            startMode = !startMode;
            message='';
          });
        }
      });
      if (mounted) setState(() {

      });
      //if (url != null) showInSnackBar('Streaming video to $url');
      Wakelock.enable();
    });
  }

  void onRecordingAndVideoStreamingButtonPressed() {
    startRecordingAndVideoStreaming().then((String url) {
      if (mounted) setState(() {});
      if (url != null) showInSnackBar('Recording streaming video to $url');
      Wakelock.enable();
    });
  }

  void onStopButtonPressed() {
    if (this.controller.value.isStreamingVideoRtmp) {
      stopVideoStreaming().then((_) {
        if (mounted) setState(() {});
        showInSnackBar('Video streamed to: $url');
      });
    } else {
      stopVideoRecording().then((_) {
        if (mounted) setState(() {});
        showInSnackBar('Video recorded to: $videoPath');
      });
    }

    setState(() {
      startMode = !startMode;
    });
    Wakelock.disable();
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  void onStopStreamingButtonPressed() {
    stopVideoStreaming().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video not streaming to: $url');
    });
  }

  void onPauseStreamingButtonPressed() {
    pauseVideoStreaming().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video streaming paused');
    });
  }

  void onResumeStreamingButtonPressed() {
    resumeVideoStreaming().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video streaming resumed');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    try {
      if (controller.value.isRecordingVideo) {
        await controller.pauseVideoRecording();
      }
      if (controller.value.isStreamingVideoRtmp) {
        await controller.pauseVideoStreaming();
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    try {
      if (controller.value.isRecordingVideo) {
        await controller.resumeVideoRecording();
      }
      if (controller.value.isStreamingVideoRtmp) {
        await controller.resumeVideoStreaming();
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<String> _getUrl() async {
    // Open up a dialog for the url
    String result = _textFieldController.text;

    return result;/*await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Url to Stream to'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Url to Stream to"),
              onChanged: (String str) => result = str,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                    MaterialLocalizations.of(context).cancelButtonLabel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
                onPressed: () {
                  Navigator.pop(context, result);
                },
              )
            ],
          );
        });*/
  }

  Future<String> startRecordingAndVideoStreaming() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (controller.value.isStreamingVideoRtmp ||
        controller.value.isStreamingVideoRtmp) {
      return null;
    }

    String myUrl = await _getUrl();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    try {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      url = myUrl;
      videoPath = filePath;
      await controller.startVideoRecordingAndStreaming(videoPath, url);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        var stats = await controller.getStreamStatistics();
        print(stats);
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return url;
  }

  Future<String> startVideoStreaming() async {

    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (controller.value.isStreamingVideoRtmp) {
      return null;
    }

    // Open up a dialog for the url
    String myUrl = await _getUrl();

    try {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      url = myUrl;
      await controller.startVideoStreaming(url);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        print('controller.value.isStreamingVideoRtmp is '+controller.value.isStreamingVideoRtmp.toString());
        if(!controller.value.isStreamingVideoRtmp){
          setState(() {
            message='Streaming services is temporary unavailable. Please retry after sometime.';
          });
        }
        //var stats = await controller.getStreamStatistics();
        //print(stats);
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return url;
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
              if (_timer != null)
              {
                _timer.cancel();
              }
              controller.removeListener(() { });
            } ,
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  Future<void> stopVideoStreaming() async {
    if (!controller.value.isStreamingVideoRtmp) {
      return null;
    }

    try {
      await controller.stopVideoStreaming();
      setState(() {
        message='';
      });
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoStreaming() async {
    if (!controller.value.isStreamingVideoRtmp) {
      return null;
    }

    try {
      await controller.pauseVideoStreaming();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoStreaming() async {
    if (!controller.value.isStreamingVideoRtmp) {
      return null;
    }

    try {
      await controller.resumeVideoStreaming();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
    VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');