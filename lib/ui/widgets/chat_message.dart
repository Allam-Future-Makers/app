import 'package:app/constants/ui.dart';
import 'package:app/models/chat_message.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  ChatMessageWidget({super.key, required this.message});
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.imageUrl != null || message.voiceUrl != null)
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (message.imageUrl != null)
                  Image.network(
                    message.imageUrl!,
                    width: 100,
                  ),
                if (message.voiceUrl != null)
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
                          await _audioPlayer.setSourceUrl(message.voiceUrl!);
                          _audioPlayer.resume();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (message.query != null)
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message.query!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        if (message.answer != null)
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Text(
              message.answer!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        if (message.answer == null) const LinearProgressIndicator(),
      ],
    );
  }
}
