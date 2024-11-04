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
        title: const Text('Iraab'),
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
                  'Enter the text you want to analyze',
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
                        ApiService().getIrab(textController.text).then((value) {
                          result.value = value;
                          loading.value = false;
                        });
                      },
                      child: loading.value
                          ? const CircularProgressIndicator()
                          : const Text('Analyze'),
                    )),
                const SizedBox(height: 20),
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
                          columns: const [
                            DataColumn(label: Text('Word')),
                            DataColumn(label: Text('Irab')),
                          ],
                          rows: result.value!.irabResults
                              .map((e) => DataRow(cells: [
                                    DataCell(Text(e.word)),
                                    DataCell(Text(e.irab)),
                                  ]))
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
