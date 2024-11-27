import 'package:flutter/material.dart';
import 'dart:async';

import 'my_rx_state.dart';

class MultiRxBuilder extends StatelessWidget {
  /// Danh sách các state cần lắng nghe
  final List<RxState> states;

  /// Hàm builder nhận danh sách các giá trị và trả về UI
  final Widget Function(BuildContext context, List<dynamic> values) builder;

  /// Constructor
  const MultiRxBuilder({
    Key? key,
    required this.states,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kết hợp tất cả các stream thành một stream duy nhất
    final combinedStream = Stream<List<dynamic>>.multi((controller) {
      final subscriptions = <StreamSubscription>[];
      final currentValues = List<dynamic>.filled(states.length, null);

      for (int i = 0; i < states.length; i++) {
        final index = i;
        subscriptions.add(
          states[i].stream.listen((value) {
            currentValues[index] = value;
            controller.add(currentValues.toList());
          }),
        );
      }

      // Dispose các stream subscription khi không cần thiết
      controller.onCancel = () {
        for (var subscription in subscriptions) {
          subscription.cancel();
        }
      };
    });

    return StreamBuilder<List<dynamic>>(
      stream: combinedStream,
      initialData: states.map((e) => e.value).toList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!); // Gọi builder với danh sách giá trị
        } else {
          return const SizedBox(); // Widget trống nếu không có dữ liệu
        }
      },
    );
  }
}
