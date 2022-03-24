import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderHelper {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  late bool _isRecorderInitialized;
  int flag = 0;

  initRecorder() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Permissions don\'t Granted');
      }

      await _recorder.openRecorder();
      _isRecorderInitialized = true;
      print('initialized');
    } catch (e) {
      print('Exception : ${e.toString()}');
    }
  }

  initPlayer() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Permissions don\'t Granted');
      }
      await _player.openPlayer();
      _isRecorderInitialized = true;
    } catch (e) {
      print('Exception : ${e.toString()}');
    }
  }

  disposeRecorder() async {
    if (_isRecorderInitialized == false) return;
    await _recorder.closeRecorder();
    _isRecorderInitialized = false;
    print('disposed');
  }

  disposePlayer() async {
    if (_isRecorderInitialized == false) return;
    await _player.closePlayer();
    _isRecorderInitialized = false;
  }

  // Recorder
  Future<void> startRecord() async {
    if (_isRecorderInitialized == false) return;
    var tempDir = await getTemporaryDirectory();
    String _storePath = '${tempDir.path}/flutter_sound.aac';
    await _recorder.startRecorder(
      toFile: _storePath,
      codec: Codec.aacADTS,
    );
    print('started');
  }

  Future<String> stopRecord() async {
    if (_isRecorderInitialized == false) return 'no voice';
    final String? url = await _recorder.stopRecorder();
    print('stopped');
    return url ?? 'no voice';
  }

  Future<bool> deleteRecord(String url) async {
    if (_isRecorderInitialized == false) return false;

    bool? b = await _recorder.deleteRecord(fileName: url);
    print('deleted');
    return b ?? false;
  }

//player
  Future<void> playSavedAudio(String url, Function whenFinished) async {
    flag = 1;
    print('started');
    await _player.startPlayer(
        fromURI: url,
        codec: Codec.aacADTS,
        whenFinished: () {
          whenFinished();
        });
  }

  Future<void> resumeSavedAudio() async {
    flag = 3;
    print('resumed');
    await _player.resumePlayer();
  }

  Future<void> pauseSavedAudio() async {
    flag = 2;
    print('paused');
    await _player.pausePlayer();
  }

  bool isPaused() {
    return _player.isPaused;
  }

  bool isStopped() {
    return _player.isStopped;
  }

  bool isPlaying() {
    return _player.isPlaying;
  }
}
