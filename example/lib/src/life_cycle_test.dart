import 'package:flutter/material.dart';
import 'package:rx_state/rx_state.dart';

class CounterAppWithLifecycle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Counter with RxLifecycle')),
        body: RxLifecycle(
          onDispose: () {
            print('Widget is being disposed. Clean up here!');
          },
          child: CounterScreen(),
        ),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  final counterState = RxState<int>(0);

  @override
  Widget build(BuildContext context) {
    RxLifecycle.register(context, counterState); // Đăng ký state vào lifecycle

    return Center(
      child: RxBuilder<int>(
        state: counterState,
        builder: (context, value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Counter: $value', style: TextStyle(fontSize: 24)),
              ElevatedButton(
                onPressed: () => counterState.value += 1,
                child: Text('Increment'),
              ),
            ],
          );
        },
      ),
    );
  }
}
