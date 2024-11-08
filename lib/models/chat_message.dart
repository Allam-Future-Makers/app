import 'dart:typed_data';

class ChatMessage {
  String? answer;
  final String? query;
  final Uint8List? imageData;
  final Uint8List? voiceData;

  ChatMessage({
    this.query,
    this.answer,
    this.imageData,
    this.voiceData,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      query: json['query'],
      answer: json['answer'],
      imageData: json['imageUrl'],
      voiceData: json['voiceUrl'],
    );
  }
}
