/*
{
    "original_sentence": "الحمدلله رب العالمين",
    "irab_results": [
        {
            "word": "الحمد",
            "irab": "مبتدأ مرفوع وعلامة رفعه الضمة الظاهرة"
        },
        {
            "word": "لله",
            "irab": "اللام حرف جر، ولفظ الجلالة اسم مجرور وعلامة جره الكسرة. وشبه الجملة \"لله\" في محل رفع خبر"
        },
        {
            "word": "رب",
            "irab": "بدل من \"الله\" مجرور وعلامة جره الكسرة"
        },
        {
            "word": "العالمين",
            "irab": "مضاف إليه مجرور وعلامة جره الياء لأنه جمع مذكر سالم"
        }
    ],
    "special_sentences": []
}
*/

class IrabResponse {
  final String originalSentence;
  final List<IrabResult> irabResults;
  final List<IrabResult> specialSentences;

  IrabResponse({
    required this.originalSentence,
    required this.irabResults,
    required this.specialSentences,
  });

  factory IrabResponse.fromJson(Map<String, dynamic> json) {
    return IrabResponse(
      originalSentence: json['original_sentence'],
      irabResults: List<IrabResult>.from(
          json['irab_results'].map((x) => IrabResult.fromJson(x))),
      specialSentences: List<IrabResult>.from(
          json['special_sentences'].map((x) => IrabResult.fromJson(x))),
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
