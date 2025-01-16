import 'package:flutter/material.dart';
import 'package:swara/src/services/audio_recorder.dart';

class TalkButton extends StatefulWidget {
  const TalkButton({super.key});

  @override
  State<TalkButton> createState() => _TalkButtonState();
}

class _TalkButtonState extends State<TalkButton> {
  final _audioRecorder = AudioRecorderService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: ElevatedButton(
        onPressed: () async {
          if (!_audioRecorder.isRecording) {
            await _audioRecorder.startRecording();
          } else {
            await _audioRecorder.stopRecording();
          }
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: const SizedBox(),
      ),
    );
  }
}
