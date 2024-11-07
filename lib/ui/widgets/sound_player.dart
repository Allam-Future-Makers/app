import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class SoundPlayer extends StatefulWidget {
  final String url;

  const SoundPlayer({super.key, required this.url});

  @override
  _SoundPlayerState createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  late StreamSubscription? _playerProgressSubscription;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _duration = 0.0;
  bool _playerIsInited = false;

  @override
  void initState() {
    super.initState();
    init().then((value) {
      setState(() {
        _playerIsInited = true;
      });
    });
  }

  Future<void> init() async {
    await _player.openPlayer();
    _playerProgressSubscription = _player.onProgress!.listen((e) {
      _currentPosition = e.position.inMilliseconds.toDouble();
      _duration = e.duration.inMilliseconds.toDouble();
    });
  }

  @override
  void dispose() {
    _player.stopPlayer();
    cancelPlayerSubscriptions();

    _player.closePlayer();

    super.dispose();
  }

  void cancelPlayerSubscriptions() {
    if (_playerProgressSubscription != null) {
      _playerProgressSubscription!.cancel();
      _playerProgressSubscription = null;
    }
  }

  void _playPause() async {
    if (_isPlaying) {
      await _player.pausePlayer();
    } else {
      await _player.startPlayer(
        fromURI: widget.url,
        codec: Codec.mp3,
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _player.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: _playPause,
          ),
          Text(
            '${_formatTime(_currentPosition)} / ${_formatTime(_duration)}',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          Expanded(
            child: Slider(
              activeColor: Colors.blue,
              inactiveColor: Colors.grey.shade300,
              value: _currentPosition,
              max: _duration,
              onChanged: (value) async {
                await _player
                    .seekToPlayer(Duration(milliseconds: value.toInt()));
                setState(() {
                  _currentPosition = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(double millis) {
    Duration duration = Duration(milliseconds: millis.toInt());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigitMinutes}:${twoDigitSeconds}';
  }
}
