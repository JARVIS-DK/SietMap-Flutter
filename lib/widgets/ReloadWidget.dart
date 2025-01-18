import 'package:flutter/material.dart';

class ReloadFAB extends StatelessWidget {
  final VoidCallback onReload;

  const ReloadFAB({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 150 //67
            ,
            left: 5),
        child: FloatingActionButton.small(
          onPressed: onReload,
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),

          //splashColor: Colors.grey,
        ),
      ),
    );
  }
}
