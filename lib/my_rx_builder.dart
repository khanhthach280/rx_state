import 'package:flutter/material.dart';

import 'my_rx_state.dart';

class RxBuilder<T> extends StatelessWidget {
  /// State cần lắng nghe
  final RxState<T> state;

  /// Hàm builder nhận giá trị và trả về UI
  final Widget Function(BuildContext context, T value) builder;

  /// Constructor
  const RxBuilder({
    Key? key,
    required this.state,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: state.stream, // Lắng nghe stream của RxState
      initialData: state.value, // Giá trị ban đầu
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!); // Gọi builder với giá trị hiện tại
        } else {
          return const SizedBox(); // Widget trống nếu không có dữ liệu
        }
      },
    );
  }
}
