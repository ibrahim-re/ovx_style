import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  late bool _isRecorderInitialized;
  int flag = 0;

  init() async {
    try {
      await _player.openPlayer();

      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Permissions don\'t Granted');
      }

      await _recorder.openRecorder();
      _isRecorderInitialized = true;
    } catch (e) {
      print('Exception : ${e.toString()}');
    }
  }

  dispose() async {
    if (_isRecorderInitialized == false) return;
    await _recorder.closeRecorder();
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
  }

  Future<String> stopRecord() async {
    if (_isRecorderInitialized == false) return 'no voice';
    final String? url = await _recorder.stopRecorder();
    return url!;
  }

//player
  Future<void> playSavedAudio(String url) async {
    flag = 1;
    await _player.startPlayer(
        fromURI: url,
        codec: Codec.aacADTS,
        whenFinished: () {
          flag = 0;
        });
  }

  // Future<void> stopSavedAudio() async {
  //   await _player.stopPlayer();
  //   flag = 0;
  // }

  Future<void> resumeSavedAudio() async {
    flag = 3;
    await _player.resumePlayer();
  }

  Future<void> pauseSavedAudio() async {
    flag = 2;
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
