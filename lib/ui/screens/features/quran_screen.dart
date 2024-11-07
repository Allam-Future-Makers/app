import 'package:app/constants/ui.dart';
import 'package:app/models/enhancer_response.dart';
import 'package:app/models/quran_response.dart';
import 'package:app/services/api_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:app/ui/widgets/sound_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QuranScreen extends StatelessWidget {
  QuranScreen({super.key});

  final textController = TextEditingController();
  final loading = false.obs;
  final Rx<QuranResponse?> result = Rx(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
      ),
      backgroundColor: UIConstants.backgroundColor,
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
                  'Enter your question',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the question here',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 10,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      loading.value = true;
                      ApiService().getQuran(textController.text).then((value) {
                        print(value);
                        result.value = value;
                        loading.value = false;
                      });
                    },
                    child: loading.value
                        ? const CircularProgressIndicator()
                        : const Text('Search'),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : const Text(
                          "Answer",
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
                      : Text(
                          result.value!.answer,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                ),
                //copy button with icon
                const SizedBox(height: 20),
                //The sound urls found in result.links using flutter_sound
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            for (var link in result.value!.links)
                              SoundPlayer(url: link)
                          ],
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
