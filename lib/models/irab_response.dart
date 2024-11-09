class IrabResponse {
  final String originalSentence;
  final List<IrabResult> irabResults;
  final List<SpecialSentence> specialSentences;
  final String diacratizedSentence;

  IrabResponse({
    required this.originalSentence,
    required this.irabResults,
    required this.specialSentences,
    required this.diacratizedSentence,
  });

  factory IrabResponse.fromJson(Map<String, dynamic> json) {
    return IrabResponse(
      originalSentence: json['original_sentence'],
      irabResults: List<IrabResult>.from(
          json['irab_results'].map((x) => IrabResult.fromJson(x))),
      specialSentences: List<SpecialSentence>.from(
          json['special_sentences'].map((x) => SpecialSentence.fromJson(x))),
      diacratizedSentence: json['diacratized_sentence'],
    );
  }
}

class IrabResult {
  final String word;
  final String irab;

  IrabResult({
    required this.word,
    required this.irab,
  });

  factory IrabResult.fromJson(Map<String, dynamic> json) {
    return IrabResult(
      word: json['word'],
      irab: json['irab'],
    );
  }
}

class SpecialSentence {
  final String sentence;
  final String irab;

  SpecialSentence({
    required this.sentence,
    required this.irab,
  });

  factory SpecialSentence.fromJson(Map<String, dynamic> json) {
    return SpecialSentence(
      sentence: json['sentence'],
      irab: json['special_irab'],
    );
  }
}
