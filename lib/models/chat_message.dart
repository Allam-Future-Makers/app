class ChatMessage {
  String? query;
  String? answer;
  String? imageUrl;
  String? voiceUrl;

  ChatMessage({
    this.query,
    this.answer,
    this.imageUrl,
    this.voiceUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      query: json['query'],
      answer: json['answer'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
    );
  }
}
