import 'package:flutter/material.dart';
import 'package:root_app/constants/constants.dart';

class CopyrightText extends StatelessWidget {
  const CopyrightText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "© Copyright ${DateTime.now().year},",
              style: const TextStyle(color: kTextColor, fontSize: 10),
              children: const <TextSpan>[
                TextSpan(
                    text: ' All rights reserved Developed & Maintained By',
                    style: TextStyle(color: kTextColor, fontSize: 10)),
                TextSpan(
                    text: ' Recom Consulting Ltd.',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 10,
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
