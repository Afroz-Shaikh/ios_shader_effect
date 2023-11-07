import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  double time = 0;
  late Ticker? ticker;

  @override
  void initState() {
    super.initState();
    runTicker();
  }

  runTicker() {
    ticker = createTicker((elapsed) {
      print(elapsed);
      if (time > 5) {
        time = 0;
        setState(() {});
        ticker?.stop();
      } else {
        time += 0.015;
        setState(() {});
      }
    });
    ticker?.start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ticker?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: ShaderBuilder(
          assetKey: 'shader/ios_effect.glsl',
          (context, shader, child) {
            return AnimatedSampler(
              enabled: true,
              (ui.Image image, size, canvas) {
                shader.setFloat(0, time);
                shader.setFloat(1, size.width * 3);
                shader.setFloat(2, size.height * 3);
                shader.setImageSampler(0, image);
                canvas.drawPaint(Paint()..shader = shader);
              },
              child: child!,
            );
          },
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.blue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 300,
                    backgroundColor: Colors.blueAccent,
                    foregroundImage: NetworkImage(
                        'https://i.pinimg.com/564x/c7/4c/66/c74c665ea9bb0c7cdc5dc67f7711e3c2.jpg'),
                  ),
                  const Text(
                    'Shaikh Afroz',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Flutter Developer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              runTicker();
                            },
                            child: Container(
                              // width: size.width / 2.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: Text('Recieve Only')),
                              ),
                            ),
                          ),
                          Container(
                            // width: size.width / 2.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Save Contact')),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // This shader was taken from ShaderToy
// // Origin of Shader: https://www.shadertoy.com/view/tsXBzS
// class PyramidShader extends StatefulWidget {
//   const PyramidShader({Key? key}) : super(key: key);

//   @override
//   State<PyramidShader> createState() => _PyramidShaderState();
// }

// class _PyramidShaderState extends State<PyramidShader>
//     with SingleTickerProviderStateMixin {
//   double time = 0;

//   late final Ticker _ticker;

//   @override
//   void initState() {
//     super.initState();
//     _ticker = createTicker((elapsed) {
//       time += 0.015;
//       setState(() {});
//     });
//     _ticker.start();
//   }

//   @override
//   void dispose() {
//     _ticker.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fractal Pyramid Shader'),
//       ),
//       backgroundColor: Colors.black,
//       body: ShaderBuilder(
//         assetKey: 'shader/pyramid.glsl',
//         child: SizedBox(width: size.width, height: size.height),
//         (context, shader, child) {
//           return AnimatedSampler(
//             child: child!,
//             (ui.Image image, Size size, Canvas canvas) {
//               shader
//                 ..setFloat(0, time)
//                 ..setFloat(1, size.width)
//                 ..setFloat(2, size.height);
//               canvas.drawPaint(Paint()..shader = shader);
//             },
//           );
//         },
//       ),
//     );
//   }
// }


//   // body: 