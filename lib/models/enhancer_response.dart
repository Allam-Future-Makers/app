class SyntaxEnhancerResponse {
  final String originalSentence;
  final Map<String, String> modifications;

  SyntaxEnhancerResponse({
    required this.originalSentence,
    required this.modifications,
  });

  factory SyntaxEnhancerResponse.fromJson(Map<String, dynamic> json) {
    return SyntaxEnhancerResponse(
      originalSentence: json['original_sentence'],
      modifications: Map<String, String>.from(json['modifications']),
    );
  }
}
