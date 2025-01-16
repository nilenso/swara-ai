import 'package:flutter/material.dart';
import 'package:swara/src/services/audio_recorder.dart';
import 'package:swara/src/widgets/debug_widget.dart';

class TalkButton extends StatefulWidget {
  const TalkButton({super.key});

  @override
  State<TalkButton> createState() => _TalkButtonState();
}

class _TalkButtonState extends State<TalkButton>
    with SingleTickerProviderStateMixin {
  final _audioRecorder = AudioRecorderService();
  late AnimationController _pulseController;
  String? _currentFilePath;

  @override
  void initState() {
    super.initState();
    // Initialize the pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              if (!_audioRecorder.isRecording) {
                _currentFilePath = await _audioRecorder.startRecording();
                _pulseController.repeat(reverse: true);
              } else {
                await _audioRecorder.stopRecording();
                _pulseController.reset();
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _audioRecorder.isRecording
                  ? Colors.red
                  : Colors.green, // Red when recording, green when not
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
                          ? 1 + (_pulseController.value * 0.2)
                          : 1.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
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
        ),
        DebugWidget(
          isRecording: _audioRecorder.isRecording,
          filePath: _currentFilePath,
        ),
      ],
    );
  }
}
