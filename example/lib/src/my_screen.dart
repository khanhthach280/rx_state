import 'package:flutter/material.dart';
import 'package:my_rx_state/rx_state.dart';

import 'controller.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late final MyScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = MyScreenController();

    // Gắn RxLifeCycle để tự động dispose state
    // attachLifeCycle(controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("RxState Demo")),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sử dụng RxBuilder để tự động cập nhật UI
                  RxBuilder(
                    state: controller.counter,
                    builder: (context, value) {
                      return Text(
                        "Counter: $value",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  RxBuilder<String>(
                    state: controller.message,
                    builder: (context, value) {
                      return Text(
                        "Message: $value",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      controller.incrementCounter();
                    },
                    child: Text("Increment Counter"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.updateMessage("RxState is awesome!");
                    },
                    child: Text("Update Message"),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}