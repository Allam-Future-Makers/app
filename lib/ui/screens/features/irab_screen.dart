import 'package:app/constants/ui.dart';
import 'package:app/models/irab_response.dart';
import 'package:app/services/api_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IrabScreen extends StatelessWidget {
  IrabScreen({super.key});

  final textController = TextEditingController();
  final loading = false.obs;
  final Rx<IrabResponse?> result = Rx(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("irab".tr),
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
                  "irab_enter".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "text_here".tr,
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
                        ApiService().getIrab(textController.text).then((value) {
                          result.value = value;
                          loading.value = false;
                        });
                      },
                      child: loading.value
                          ? const CircularProgressIndicator()
                          : Text('do_irab'.tr),
                    )),
                const SizedBox(height: 20),
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : Text(
                          result.value!.diacratizedSentence,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                ),
                Obx(
                  () => result.value == null
                      ? const SizedBox()
                      : DataTable(
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          dataTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          columns: [
                            DataColumn(label: Text('word'.tr)),
                            DataColumn(label: Text('word_irab'.tr)),
                          ],
                          rows: result.value!.irabResults
                              .map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text(e.word)),
                                    DataCell(Text(e.irab)),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => result.value == null ||
                          result.value!.specialSentences.isEmpty
                      ? const SizedBox()
                      : Text(
                          'irab_special'.tr, //تراكيب نحوية
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => result.value == null ||
                          result.value!.specialSentences.isEmpty
                      ? const SizedBox()
                      : DataTable(
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          dataTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          columns: [
                            DataColumn(label: Text('sentence'.tr)),
                            DataColumn(label: Text('word_irab'.tr)),
                          ],
                          rows: result.value!.specialSentences
                              .map(
                                (e) => DataRow(
                                  cells: [
                                    DataCell(Text(e.sentence)),
                                    DataCell(Text(e.irab)),
                                  ],
                                ),
                              )
                              .toList(),
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
