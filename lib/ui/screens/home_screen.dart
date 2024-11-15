import 'dart:ui';

import 'package:app/constants/ui.dart';
import 'package:app/providers/state.dart';
import 'package:app/ui/widgets/function_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottom bar with middle fab for chat
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          Get.toNamed('/chat');
        },
        child: const Icon(
          Icons.chat,
          size: 35,
        ),
      ),
      backgroundColor: UIConstants.backgroundColor,
      body: Stack(
        children: [
          Positioned(
              left: -220,
              bottom: -200,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff8369de).withOpacity(0.1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff8369de),
                        spreadRadius: 90,
                        blurRadius: 100,
                      )
                    ]),
              )),
          Positioned(
            top: 130,
            left: 220,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xff744ff9),
                    Color(0xff8369de),
                    Color(0xff8da0cb)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 250,
              right: 150,
              child: Transform.rotate(
                angle: 8,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff744ff9),
                        Color(0xff8369de),
                        Color(0xff8da0cb)
                      ],
                    ),
                  ),
                ),
              )),
          Center(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  "${"hello".tr}, ${AppState.user.value?.name.split(" ").first ?? "N/A"}!",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              //setting icon
                              IconButton(
                                onPressed: () {
                                  Get.toNamed('/settings');
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          //grid containing the 8 function cards
                          GridView.count(
                            crossAxisCount: context.width > 800 ? 5 : 2,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 30,
                            shrinkWrap: true,
                            children: [
                              FunctionCard(
                                icon: Icons.g_translate,
                                title: "irab".tr,
                                onTap: () {
                                  Get.toNamed('/irab');
                                },
                              ),
                              FunctionCard(
                                icon: Icons.spellcheck,
                                title: "tashkeel".tr,
                                onTap: () {
                                  Get.toNamed('/tashkeel');
                                },
                              ),
                              FunctionCard(
                                icon: Icons.language,
                                title: "msa".tr,
                                onTap: () {
                                  Get.toNamed('/msa');
                                },
                              ),
                              FunctionCard(
                                icon: Icons.search,
                                title: "lookup".tr,
                                onTap: () {
                                  Get.toNamed('/lookup');
                                },
                              ),
                              FunctionCard(
                                icon: Icons.record_voice_over,
                                title: "quran".tr,
                                onTap: () {
                                  Get.toNamed('/quran');
                                },
                              ),
                              // FunctionCard(
                              //   icon: Icons.chat,
                              //   title: "Chat",
                              //   onTap: () {
                              //     Get.toNamed('/chat');
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
