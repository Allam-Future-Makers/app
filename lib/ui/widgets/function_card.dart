import 'package:flutter/material.dart';

class FunctionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final GestureTapCallback? onTap;

  const FunctionCard(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Color(0xff1C1760),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff1C1760),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
