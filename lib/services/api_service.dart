import 'dart:typed_data';

import 'package:app/constants/constants.dart';
import 'package:app/models/chat_response.dart';
import 'package:app/models/dictionary_response.dart';
import 'package:app/models/enhancer_response.dart';
import 'package:app/models/irab_response.dart';
import 'package:app/models/msa_response.dart';
import 'package:app/models/quran_response.dart';
import 'package:app/models/tashkeel_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  static ApiService? _instance;

  factory ApiService() => _instance ??= ApiService._();

  ApiService._();

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: Constants.baseUrl,
    ));

    return dio;
  }

  final Dio dio = createDio();

  Future<TashkeelResponse> getTashkeel(String sentence) async {
    try {
      final response = await dio.post('/tashkeel', data: {
        "sentence": sentence,
      });
      return TashkeelResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<QuranResponse> getQuran(String query) async {
    try {
      final response = await dio.post('/quran', data: {
        "query": query,
      });
      return QuranResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<IrabResponse> getIrab(String paragraph) async {
    try {
      final response = await dio.post('/irab', data: {
        "paragraph": paragraph,
      });
      return IrabResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<DictionaryResponse> searchDictionary(
      String word, String? helperSentence) async {
    try {
      final response = await dio.post('/mo3gam', data: {
        "word": word,
        "helper_sentence": helperSentence,
      });
      return DictionaryResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SyntaxEnhancerResponse> enhanceSyntax(String sentence) async {
    try {
      final response = await dio.post('/syntax_enhancer', data: {
        "sentence": sentence,
      });
      return SyntaxEnhancerResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<MSAResponse> getMSA(String paragraph) async {
    try {
      final response = await dio.post('/to_msa', data: {
        "paragraph": paragraph,
      });
      return MSAResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatResponse> chat(
      {required String id,
      String? query,
      Uint8List? imageData,
      Uint8List? voiceData}) async {
    try {
      final formData = FormData.fromMap({
          'id': id,
        if(query != null) 'query': query,
        if(imageData != null) 'image': MultipartFile.fromBytes(imageData, filename: 'image.jpg'),
        if(voiceData != null) 'voice': MultipartFile.fromBytes(voiceData, filename: 'voice.wav'),
      });

      final response = await dio.post('/chat',
          data: formData,
          options: Options(
            receiveDataWhenStatusError: true,
            validateStatus: (status) => true,
          ));
      print(response.data);
      return ChatResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
