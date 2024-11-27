import 'package:rx_state/rx_state.dart';

class MyScreenController extends RxStateController {
  late final RxState<int> counter;
  late final RxState<String> message;

  MyScreenController() {
    // Khởi tạo state
    counter = addState<int>("counter", 0);
    message = addState<String>("message", "Hello RxState!");
  }

  // Hàm tăng giá trị counter
  void incrementCounter() {
    // updateState<int>("counter", (current) => current + 1);
    counter.value++;
  }

  // Hàm cập nhật message
  void updateMessage(String newMessage) {
    // updateState<String>("message", (_) => newMessage);
    message.value = newMessage;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
