import 'package:app/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageWidget({super.key, required this.message});

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
        if (message.voiceUrl != null)
          ElevatedButton(
            onPressed: () {},
            child: const Text('Play Voice'),
          ),
      ],
    );
  }
}
