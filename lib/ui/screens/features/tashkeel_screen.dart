import 'package:app/constants/ui.dart';
import 'package:app/models/tashkeel_response.dart';
import 'package:app/services/api_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class TashkeelScreen extends StatelessWidget {
  TashkeelScreen({super.key});

  final textController = TextEditingController();
  final loading = false.obs;
  final Rx<TashkeelResponse?> result = Rx(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tashkeel'.tr),
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
                Text(
                  "tashkeel_enter".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'text_here'.tr,
                    hintStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(
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
                            .getTashkeel(textController.text)
                            .then((value) {
                          result.value = value;
                          loading.value = false;
                        });
                      },
                      child: loading.value
                          ? const CircularProgressIndicator()
                          : Text('process'.tr),
                    )),
                const SizedBox(height: 20),
                //Result
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : Text(
                          "result".tr,
                          style: const TextStyle(
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
                          result.value!.diacritized,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 23),
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
                                ClipboardData(text: result.value!.diacritized));
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
