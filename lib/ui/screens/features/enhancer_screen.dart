import 'package:app/models/enhancer_response.dart';
import 'package:app/services/api_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EnhancerScreen extends StatelessWidget {
  EnhancerScreen({super.key});

  final textController = TextEditingController();
  final loading = false.obs;
  final Rx<SyntaxEnhancerResponse?> result = Rx(null);

  String constructResult(String text, SyntaxEnhancerResponse response) {
    response.modifications.forEach((key, value) {
      text = text.replaceAll(key, "g${value}w");
    });
    return text;
  }

  List<TextSpan> constructSpans(String text, SyntaxEnhancerResponse response) {
    final textWithMarkers = constructResult(text, response);

    //start letter by letter, if g is found, make the next letters green until w is found, don't include g and w

    final spans = <TextSpan>[];

    var currentWord = '';
    var isGreen = false;
    for (var i = 0; i < textWithMarkers.length; i++) {
      final char = textWithMarkers[i];
      if (char == 'g') {
        if (currentWord.isNotEmpty) {
          spans.add(TextSpan(
              text: currentWord,
              style: const TextStyle(color: Colors.white, fontSize: 21)));
          currentWord = '';
        }
        isGreen = true;
      } else if (char == 'w') {
        isGreen = false;
        spans.add(TextSpan(
            text: currentWord,
            style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 21)));
        currentWord = '';
      } else {
        currentWord += char;
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Text Enhancer'),
      ),
      backgroundColor: const Color(0xff1C1760),
      body: Glass(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              //big text field to enter text
              //button with loading inside
              //result table

              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter the text you want to enhance',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the text here',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 10,
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                      onPressed: () {
                        loading.value = true;
                        ApiService()
                            .enhanceSyntax(textController.text)
                            .then((value) {
                          result.value = value;
                          loading.value = false;
                        });
                      },
                      child: loading.value
                          ? const CircularProgressIndicator()
                          : const Text('Process'),
                    )),
                const SizedBox(height: 20),
                //Result
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : const Text(
                          "Result",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 10),
                //result is array of words (modifications) and their replacements in the original text, words without replacements are not included
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      //السلام عليكم gكيف حالكمw gيا أصدقاءw
                      : RichText(
                          text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: constructSpans(
                                  textController.text, result.value!)),
                        ),
                ),
                //copy button with icon
                const SizedBox(height: 20),
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : ElevatedButton.icon(
                          onPressed: () {
                            //copy the result to the clipboard
                            final finalText =
                                textController.text.split(' ').map((e) {
                              final replacement =
                                  result.value!.modifications[e];
                              if (replacement == null) {
                                return e;
                              }
                              return replacement;
                            }).join(' ');
                            Clipboard.setData(ClipboardData(text: finalText));
                            Get.snackbar('Copied',
                                'The result has been copied to the clipboard');
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
