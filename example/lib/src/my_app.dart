import 'package:example/src/life_cycle_test.dart';
import 'package:example/src/my_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_rx_state/rx_state.dart';

class MyApp extends StatelessWidget {
  // Tạo một RxState để quản lý biến đếm
  final RxState<int> counterState = RxState<int>(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Async RxState Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lắng nghe state và hiển thị giá trị
              RxBuilder<int>(
                state: counterState,
                builder: (context, value) {
                  return Text(
                    'Counter: $value',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Nút để tăng giá trị đồng bộ
              ElevatedButton(
                onPressed: () {
                  counterState.value++;
                },
                child: const Text('Increment Counter'),
              ),
              const SizedBox(height: 16),
              // Nút để cập nhật giá trị bất đồng bộ
              ElevatedButton(
                onPressed: () async {
                  await counterState.updateAsync(() async {
                    await Future.delayed(
                        const Duration(seconds: 2)); // Giả lập tải dữ liệu
                    return counterState.value + 10; // Tăng thêm 10
                  });
                },
                child: const Text('Increment Counter Async'),
              ),
              const SizedBox(height: 16),
              // Nút để reset giá trị
              ElevatedButton(
                onPressed: () {
                  counterState.reset();
                },
                child: const Text('Reset Counter'),
              ),

              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyScreen()),
                    );
                  },
                  child: const Text('Using controller page'),
                );
              }),

              Builder(builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CounterAppWithLifecycle()),
                    );
                  },
                  child: const Text('Using life cycle page'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
