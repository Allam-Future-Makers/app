import 'package:app/models/dictionary_response.dart';
import 'package:app/models/msa_response.dart';
import 'package:app/models/tashkeel_response.dart';
import 'package:app/services/api_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class LookupScreen extends StatelessWidget {
  LookupScreen({super.key});

  final textController = TextEditingController();
  final helperTextController = TextEditingController();
  final loading = false.obs;
  final Rx<DictionaryResponse?> result = Rx(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary Lookup'),
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
                  'Enter the text you want to lookup',
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
                //Helper text
                const Text("Enter the helper sentence (optional)",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 10),
                TextField(
                  controller: helperTextController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the helper sentence here',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                      onPressed: () {
                        loading.value = true;
                        ApiService()
                            .searchDictionary(
                                textController.text,
                                helperTextController.text.isEmpty
                                    ? null
                                    : helperTextController.text)
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
                          "Answer",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 10),
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
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : ElevatedButton.icon(
                          onPressed: () {
                            //copy the result to the clipboard
                            Clipboard.setData(
                                ClipboardData(text: result.value!.answer));
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
