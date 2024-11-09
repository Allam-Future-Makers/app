import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/constants/ui.dart';
import 'package:app/models/chat_message.dart';
import 'package:app/providers/state.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/prefs_service.dart';
import 'package:app/ui/intents/new_line_intent.dart';
import 'package:app/ui/widgets/chat_message.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:app/utils/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  XFile? _image;
  Uint8List? _imageData;
  Uint8List? _voiceData;
  bool _isRecording = false;
  bool _recorderIsInited = false;
  Timer? _timer;
  int _recordDuration = 0;
  Stream<RecordingDisposition>? get onProgress => _audioRecorder.onProgress;

  Duration? duration;
  Future<String> getMinutsAndSeconds({
    required AsyncSnapshot snapshot,
  }) async {
    String minutes = Utils.formatNumber(_recordDuration ~/ 60);
    String seconds = Utils.formatNumber(_recordDuration % 60);
    return '$minutes:$seconds';
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _recordDuration++;
    });
  }

  @override
  void initState() {
    super.initState();

    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _audioRecorder.openRecorder();
    await _audioRecorder
        .setSubscriptionDuration(const Duration(milliseconds: 600));
    //stream listener
    setState(() {
      _recorderIsInited = true;
    });
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveRecording() async {
    _stopRecording();
    setState(() {
      _isRecording = false;
    });
  }

  void _sendMessage() async {
    if (_isRecording) {
      await _stopRecording();
      setState(() {
        _isRecording = false;
      });
    }

    if (_messageController.text.isNotEmpty ||
        (_messageController.text.isEmpty && _imageData != null) ||
        (_messageController.text.isEmpty && _voiceData != null)) {
      final message = ChatMessage(
        query: _messageController.text,
      );
      setState(() {
        _messages.add(
          message,
        );
        _messageController.clear();
      });

      AppPrefs.token.then((us) {
        if (us == null) return;
        ApiService()
            .chat(
                id: AppState.user.value!.id,
                query: message.query,
                imageData: _imageData,
                voiceData: _voiceData)
            .then((response) {
          message.answer = response.answer;
          message.imageUrl = response.imageUrl;
          message.voiceUrl = response.voiceUrl;
          //update in the list
          _messages.removeLast();
          _messages.add(message);
          setState(() {});
        });
        setState(() {
          _imageData = null;
          _image = null;
          _voiceData = null;
        });
      });
    }
    _focusNode.requestFocus();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageData = await pickedFile.readAsBytes();
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _recordVoice() async {
    if (!_recorderIsInited) {
      return;
    }

    await _audioRecorder.startRecorder(
      codec: Codec.defaultCodec,
      toFile: "AQSA_REC",
    );
    _recordDuration = 0;
    _startTimer();
    setState(() {
      _isRecording = true;
    });
  }

  Future<String?> _stopRecording() async {
    final filePath = await _audioRecorder.stopRecorder();
    if (filePath == null) return null;
    try {
      final response = await Dio().get(
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );
      String fileName = filePath.split('/').last;
      print(fileName);
      _voiceData = response.data;
    } on Exception catch (e) {
      print(e);
    }

    return filePath;
  }

  //cancel recording
  void _cancelRecording() async {
    await _audioRecorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _pauseResumeRecording() async {
    if (_audioRecorder.isPaused) {
      await _audioRecorder.resumeRecorder();
      _startTimer();
    } else {
      await _audioRecorder.pauseRecorder();
      _timer?.cancel();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat'.tr),
      ),
      backgroundColor: UIConstants.backgroundColor,
      body: Glass(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false, // Start from the bottom for chat experience
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      child: ChatMessageWidget(message: _messages[index]),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_imageData != null)
                    Stack(
                      children: [
                        Image.memory(
                          _imageData!,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            //rounded
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: InkWell(
                                child: const Icon(
                                  Icons.close,
                                  color: UIConstants.primaryColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    _imageData = null;
                                    _image = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(width: 15),
                  if (_voiceData != null)
                    Stack(
                      children: [
                        //play button
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: InkWell(
                              child: const Icon(
                                Icons.play_arrow,
                                color: UIConstants.primaryColor,
                              ),
                              onTap: () async {
                                await _audioPlayer.setSourceBytes(_voiceData!);
                                _audioPlayer.resume();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            //rounded
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: InkWell(
                                child: const Icon(
                                  Icons.close,
                                  color: UIConstants.primaryColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    _voiceData = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (!_isRecording)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image,
                          color: UIConstants.primaryColor),
                      onPressed: () {
                        _pickImage();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic,
                          color: UIConstants.primaryColor),
                      onPressed: () {
                        _recordVoice();
                      },
                    ),
                    Expanded(
                      child: Shortcuts(
                        shortcuts: const {UIConstants.newLine: NewLineIntent()},
                        child: Actions(
                          actions: {
                            NewLineIntent: CallbackAction<NewLineIntent>(
                              onInvoke: (NewLineIntent intent) {
                                _messageController.text += '\n';
                              },
                            )
                          },
                          child: Focus(
                            autofocus: true,
                            focusNode: _focusNode,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.send,
                              controller: _messageController,
                              maxLines: null,
                              onSubmitted: (value) => _sendMessage(),
                              decoration: InputDecoration(
                                hintText: "type".tr,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send,
                          color: UIConstants.primaryColor),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            if (_isRecording)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.stop,
                          color: UIConstants.primaryColor),
                      onPressed: () {
                        _cancelRecording();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          _audioRecorder.isPaused ? Icons.mic : Icons.pause,
                          color: UIConstants.primaryColor),
                      onPressed: () {
                        _pauseResumeRecording();
                      },
                    ),
                    Expanded(
                        child: StreamBuilder<RecordingDisposition>(
                            stream: onProgress,
                            builder: (context, snapshot) {
                              return FutureBuilder(
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> text) {
                                  return Text(
                                    text.data ?? '00:00',
                                  );
                                },
                                future: getMinutsAndSeconds(
                                  snapshot: snapshot,
                                ),
                              );
                            })),
                    IconButton(
                      icon: const Icon(Icons.done,
                          color: UIConstants.primaryColor),
                      onPressed: _saveRecording,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
