import 'package:app/constants/ui.dart';
import 'package:app/models/dictionary_response.dart';
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
        title: Text("lookup".tr),
      ),
      backgroundColor: UIConstants.backgroundColor,
      body: Glass(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${"word".tr}: ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: UIConstants.titleFontSize,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 200),
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: "word".tr,
                            hintStyle: const TextStyle(color: Colors.white),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //Helper text
                Row(
                  children: [
                    Text(
                      "${"helper_sentence".tr}:",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: UIConstants.titleFontSize),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: helperTextController,
                  decoration: InputDecoration(
                    hintText: 'helper_enter'.tr,
                    hintStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
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
                        : Text('search'.tr),
                  ),
                ),
                const SizedBox(height: 20),
                //Result
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : Text(
                          "answer".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                            Get.snackbar("copied".tr, "copy_done".tr);
                          },
                          icon: const Icon(Icons.copy),
                          label: Text('copy'.tr),
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
