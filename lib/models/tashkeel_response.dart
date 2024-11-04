class TashkeelResponse {
  final String original;
  final String diacritized;

  TashkeelResponse({
    required this.original,
    required this.diacritized,
  });

  factory TashkeelResponse.fromJson(Map<String, dynamic> json) {
    return TashkeelResponse(
      original: json['original'],
      diacritized: json['diacritized'],
    );
  }
}
