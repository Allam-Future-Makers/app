class ChatResponse {
  final String answer;
  String? imageUrl;
  String? voiceUrl;

  ChatResponse({
    required this.answer,
    this.imageUrl,
    this.voiceUrl,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      answer: json['answer'],
      imageUrl: json['image_url'],
      voiceUrl: json['voice_url'],
    );
  }
}
