class QuranResponse {
  final String answer;
  final List<String> links;

  QuranResponse({
    required this.answer,
    required this.links,
  });

  factory QuranResponse.fromJson(Map<String, dynamic> json) {
    return QuranResponse(
      answer: json['answer'],
      links: List<String>.from(json['links']),
    );
  }
}
