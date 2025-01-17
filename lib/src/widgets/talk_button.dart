import 'package:flutter/material.dart';
import 'package:swara/src/services/audio_recorder.dart';

const _buttonColor = Color(0xffdf2525);
const _recordingButtonColor = Color(0xffab1e1e);
const _buttonSizePercent = 0.15; // 10% of screen height
const _animationDuration = Duration(milliseconds: 1000);
const _pulseScaleFactor = 0.2;

class TalkButton extends StatefulWidget {
  final void Function(String)? onTranscription;

  const TalkButton({super.key, this.onTranscription});

  @override
  State<TalkButton> createState() => TalkButtonState();
}

class TalkButtonState extends State<TalkButton>
    with SingleTickerProviderStateMixin {
  Future<void> stopRecording() async {
    if (_audioRecorder.isRecording) {
      final transcription = await _audioRecorder.stopRecording();
      if (transcription != null) {
        widget.onTranscription?.call(transcription);
      }
      _pulseController.reset();
      setState(() {});
    }
  }

  final _audioRecorder = AudioRecorderService();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Initialize the pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = MediaQuery.of(context).size.height * _buttonSizePercent;
    return SizedBox(
      height: buttonSize,
      width: buttonSize,
      child: ElevatedButton(
        onPressed: () async {
          if (!_audioRecorder.isRecording) {
            await _audioRecorder.startRecording();
            _pulseController.repeat(reverse: true);
          } else {
            final transcription = await _audioRecorder.stopRecording();
            if (transcription != null) {
              widget.onTranscription?.call(transcription);
            }
            _pulseController.reset();
          }
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _audioRecorder.isRecording ? _recordingButtonColor : _buttonColor,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _audioRecorder.isRecording
                      ? 1 + (_pulseController.value * _pulseScaleFactor)
                      : 1.0,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _audioRecorder.isRecording
                            ? _recordingButtonColor
                            : _buttonColor),
                  ),
                );
              },
            ),
            Text(
              _audioRecorder.isRecording ? 'STOP' : 'TALK',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
