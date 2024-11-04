class DictionaryResponse {
  final String answer;

  DictionaryResponse({
    required this.answer,
  });

  factory DictionaryResponse.fromJson(Map<String, dynamic> json) {
    return DictionaryResponse(
      answer: json['answer'],
    );
  }
}
