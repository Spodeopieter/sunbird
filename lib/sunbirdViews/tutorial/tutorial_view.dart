import 'package:flutter/material.dart';

import '../../../globalValues/global_colours.dart';

//TODO: Implement app tutorial.
class TutorialView extends StatefulWidget {
  const TutorialView({Key? key}) : super(key: key);

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brightOrange,
        title: const Text(
          'Tutorial',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}