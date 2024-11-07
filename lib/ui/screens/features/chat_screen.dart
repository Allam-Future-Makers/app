import 'package:app/constants/ui.dart';
import 'package:app/models/irab_response.dart';
import 'package:app/services/api_service.dart';
import 'package:app/ui/widgets/glass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final textController = TextEditingController();
  final loading = false.obs;
  final Rx<IrabResponse?> result = Rx(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
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

              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
