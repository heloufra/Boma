import 'package:boma/components/bbutton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../type/type.dart';

class Undoable extends StatefulWidget {
  final UndoableType data;

  const Undoable({super.key, required this.data});

  @override
  State<StatefulWidget> createState() {
    return UndoableState();
  }

}

class UndoableState extends State<Undoable> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text(widget.data.message),
            const SizedBox(height: 20,),
             BButton(text: widget.data.buttonText, onTap: () => { context.go(widget.data.path) }),
          ],
        ),
      ),
    );
  }
}