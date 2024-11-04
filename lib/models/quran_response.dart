class QuranResponse {
  final String answer;

  QuranResponse({
    required this.answer,
  });

  factory QuranResponse.fromJson(Map<String, dynamic> json) {
    return QuranResponse(
      answer: json['answer'],
    );
  }
}
