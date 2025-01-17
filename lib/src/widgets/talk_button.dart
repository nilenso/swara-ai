import 'package:flutter/material.dart';
import 'package:swara/src/services/audio_recorder.dart';

const _buttonColor = Color(0xfffd6969);
const _buttonSize = 100.0;
const _animationDuration = Duration(milliseconds: 1000);
const _pulseScaleFactor = 0.2;

class TalkButton extends StatefulWidget {
  const TalkButton({super.key});

  @override
  State<TalkButton> createState() => _TalkButtonState();
}

class _TalkButtonState extends State<TalkButton>
    with SingleTickerProviderStateMixin {
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
    return SizedBox(
      height: _buttonSize,
      width: _buttonSize,
      child: ElevatedButton(
        onPressed: () async {
          if (!_audioRecorder.isRecording) {
            await _audioRecorder.startRecording();
            _pulseController.repeat(reverse: true);
          } else {
            await _audioRecorder.stopRecording();
            _pulseController.reset();
          }
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
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
                    width: _buttonSize,
                    height: _buttonSize,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: _buttonColor),
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
