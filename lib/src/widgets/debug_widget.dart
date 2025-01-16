import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DebugWidget extends StatefulWidget {
  final bool isRecording;
  final String? filePath;

  const DebugWidget({
    super.key,
    required this.isRecording,
    this.filePath,
  });

  @override
  State<DebugWidget> createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  AudioPlayer? _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player?.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (widget.filePath == null || _player == null) return;

    if (_isPlaying) {
      await _player?.stop();
      setState(() => _isPlaying = false);
      return;
    }

    try {
      await _player?.setFilePath(widget.filePath!);
      await _player?.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.filePath != null) ...[
                Text(
                  'File: ${widget.filePath}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                    onPressed: _playAudio,
                  ),
                ),
              ],
              Text(
                'Recording: ${widget.isRecording}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
