class MSAResponse {
  final String result;

  MSAResponse({
    required this.result,
  });

  factory MSAResponse.fromJson(Map<String, dynamic> json) {
    return MSAResponse(
      result: json['result'],
    );
  }
}
