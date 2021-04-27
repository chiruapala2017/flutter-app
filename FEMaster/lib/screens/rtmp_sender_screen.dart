// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:food_app/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rtmp_publisher/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_incall/flutter_incall.dart';
import 'package:crypto/crypto.dart';

class RtmpSenderScreen extends StatefulWidget {
  static final id = "rtmp_sender_screen";
  final String sessionUrl;
  final String sessionName;

  const RtmpSenderScreen({Key key, this.sessionUrl, this.sessionName}) : super(key: key);

  @override
  _RtmpSenderScreenState createState() {
    return _RtmpSenderScreenState();
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

class _RtmpSenderScreenState extends State<RtmpSenderScreen>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  String url;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;
  bool useOpenGL = true;
  TextEditingController _textFieldController;

  bool get isStreaming => controller?.value?.isStreamingVideoRtmp ?? false;
  bool isVisible = true;
  IncallManager incallManager = new IncallManager();

  @override
  void initState() {
    super.initState();
    _textFieldController =
        TextEditingController(text: widget.sessionUrl);
    //url = widget.sessionUrl+"|"+widget.sessionName;
    url = widget.sessionUrl;
    //url = generateUrl();
    //url = "rtmp://3.16.240.189/live/c.bakchi@tcs.com_masaladosa?sign=1619092200-e7c5b2e51757ce2d31dc251fd7ea21f8";
    print(url);
    WidgetsBinding.instance.addObserver(this);
  }

  String generateUrl(){
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    String hashUrl = "/live/stream_masalaDosa-"+currentTime.toString()+"-5d9900d4168d7451953bd2c662733e774b7ddfbJK2331c32763ac11E3d1231dac0";
    var hashValue = md5.convert(utf8.encode(hashUrl)).toString();

    return "rtmp://3.16.240.189/live/stream_masalaDosa?sign="+currentTime.toString()+"-"+hashValue;

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Wakelock.disable();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // App state changed before we got the chance to initialize.
    print("state is in :"+state.toString());
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.paused) {
      isVisible = false;
      if(isStreaming) {
        await pauseVideoStreaming();
      }
    } else if (state == AppLifecycleState.resumed) {
      isVisible = true;
      if (controller != null) {
        if(isStreaming) {
          print("isInitialized is in :"+controller.value.isInitialized.toString());
          print("isRecordingVideo is in :"+controller.value.isRecordingVideo.toString());
          print("isRecordingPaused is in :"+controller.value.isRecordingPaused.toString());
          //await resumeVideoStreaming();
          //await onVideoStreamingButtonPressed();
          onNewCameraSelectedFuture(controller.description).then((value) async {
            new Future.delayed(const Duration(milliseconds: 2000), () async {
              await onVideoStreamingButtonPressed();
            });
          });
        } else {
          onNewCameraSelected(controller.description);
        }

      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ? Colors.redAccent
                      : Colors.orangeAccent
                      : controller != null &&
                      controller.value.isStreamingVideoRtmp
                      ? Colors.blueAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
          _toggleAudioWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _cameraTogglesRowWidget(),
                  ],
                ),
                //_thumbnailWidget(),
              ],
            ),
          ),
        ],
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
        child: CameraPreview(controller),
      );
    }
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              setState(() {
                print("enableAudio value is :"+value.toString());
                enableAudio = value;
                if(!enableAudio){
                  incallManager.setMicrophoneMute(true);
                }
                else{
                  incallManager.setMicrophoneMute(false);
                }
              });
              /*if (controller != null && !controller.value.isStreamingVideoRtmp) {
                onNewCameraSelected(controller.description);
              }
              else{
                if(controller != null){
                  onNewCameraSelectedFuture(controller.description).then((value) async {
                    new Future.delayed(const Duration(milliseconds: 2000), () async {
                      await onVideoStreamingButtonPressed();
                    });
                  });
                }
              }*/
            },
          ),
        ],
      ),
    );
  }

  Future<void> onNewCameraSelectedFuture(CameraDescription cameraDescription) async {
    if (controller != null) {
      await stopVideoStreaming();
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() async {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
        await stopVideoStreaming();
      } else {
        try {
          final Map<dynamic, dynamic> event =
          controller.value.event as Map<dynamic, dynamic>;
          if (event != null) {
            print('Event details are: $event');
            final String eventType = event['eventType'] as String;
            if (isVisible && isStreaming && eventType == 'rtmp_retry') {
              showInSnackBar('BadName received, endpoint in use.');
              await stopVideoStreaming();
            }
          }
        } catch (e) {
          print(e);
        }
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
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
                  ? Container(child: Center(child: Image.file(File(imagePath)),),)
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null && controller.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
        /*IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),*/
        IconButton(
          icon: const Icon(Icons.watch),
          color: Colors.blue,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isStreamingVideoRtmp
              ? onVideoStreamingButtonPressed
              : null,
        ),
        /*IconButton(
          icon: controller != null &&
                  (controller.value.isRecordingPaused ||
                      controller.value.isStreamingPaused)
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  (controller.value.isRecordingVideo ||
                      controller.value.isStreamingVideoRtmp)
              ? (controller != null &&
                      (controller.value.isRecordingPaused ||
                          controller.value.isStreamingPaused)
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),*/
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              (controller.value.isRecordingVideo ||
                  controller.value.isStreamingVideoRtmp)
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
                title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
                groupValue: controller?.description,
                value: cameraDescription,
                onChanged: (value){
                  if(controller != null){
                    if(controller.value.isRecordingVideo){
                      null;
                    }
                    else if(!controller.value.isStreamingVideoRtmp){
                      onNewCameraSelected(cameraDescription);
                    }
                    else if(controller.value.isStreamingVideoRtmp){
                      onNewCameraSelectedFuture(cameraDescription).then((value) async {
                        new Future.delayed(const Duration(milliseconds: 2000), () async {
                          await onVideoStreamingButtonPressed();
                        });
                      });
                    }
                  }else{
                    onNewCameraSelected(cameraDescription);
                  }
                }
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await stopVideoStreaming();
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() async {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
        await stopVideoStreaming();
      } else {
        try {
          final Map<dynamic, dynamic> event =
          controller.value.event as Map<dynamic, dynamic>;
          if (event != null) {
            print('Event $event');
            final String eventType = event['eventType'] as String;
            if (isVisible && isStreaming && eventType == 'rtmp_retry') {
              showInSnackBar('BadName received, endpoint in use.');
              await stopVideoStreaming();
            }
          }
        } catch (e) {
          print(e);
        }
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
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
        if (filePath != null) {
          Alert(context: context, title: "Image Saved", desc: "File saved in $filePath").show();
        }
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
      if (mounted) setState(() {});
      if (url != null) showInSnackBar('Streaming video to $url');
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

    final Directory extDir = await getExternalStorageDirectory();
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

    return await showDialog(
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
        });
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
      url = myUrl;
      videoPath = filePath;
      await controller.startVideoRecordingAndStreaming(videoPath, url);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return url;
  }

  Future<String> startVideoStreaming() async {
    await stopVideoStreaming();
    if (controller == null) {
      return null;
    }
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (controller?.value?.isStreamingVideoRtmp ?? false) {
      return null;
    }

    // Open up a dialog for the url
    //String myUrl = await _getUrl();
    String myUrl = url;

    try {
      url = myUrl;
      await controller.startVideoStreaming(url);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return url;
  }

  Future<void> stopVideoStreaming() async {

    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (!controller.value.isStreamingVideoRtmp) {
      return;
    }

    try {
      await controller.stopVideoStreaming();
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
    final Directory extDir = await getExternalStorageDirectory();
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