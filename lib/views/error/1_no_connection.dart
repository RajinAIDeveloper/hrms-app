// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/1_No Connection.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: SizeConfig.isTabeDevice ? 140 : 100,
            left: SizeConfig.isTabeDevice ? 65 : 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1, color: Colors.white),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Retry".toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}
