import 'package:boma/routing/notifiers.dart';
import 'package:boma/routing/routing.dart';
import 'package:boma/theme/theme.dart';
import 'package:flutter/material.dart';

import 'routing/loading.dart';


void main() {

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {


  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: godRouter,
      title: 'Boma',
      theme: lightMode,
      darkTheme: darkMode,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            ValueListenableBuilder<bool>(
              valueListenable: theIsLoading,
              builder: (context, value, child) {
                return LoadingOverlay(isLoading: value);
              },
            ),
          ],
        );
      },
    );
  }
}

// main.dart
// void main() {
//   // Initialize June state
  
//   runApp(MaterialApp(
//     home: LoginPage(),
//   ));
// }
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Flutter Animation')),
//         body: Center(
//           child: MyAnimatedBox(),
//         ),
//       ),
//     );
//   }
// }

// class MyAnimatedBox extends StatefulWidget {
//   @override
//   _MyAnimatedBoxState createState() => _MyAnimatedBoxState();
// }

// class _MyAnimatedBoxState extends State<MyAnimatedBox> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the AnimationController
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     // Define a Tween and attach it to the controller
//     _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
//       ..addListener(() {
//         setState(() {});
//       });

//     // Start the animation
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     // Dispose the controller when the widget is removed
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: _animation.value),
//       width: 50,
//       height: 50,
//       color: Colors.blue,
//     );
//   }
// }