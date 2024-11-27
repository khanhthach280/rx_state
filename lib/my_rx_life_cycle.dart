import 'package:flutter/material.dart';
import 'my_rx_state.dart';
import 'my_rx_state_controller.dart';

/// Widget hỗ trợ quản lý vòng đời của RxState và RxStateController.
class RxLifecycle extends StatefulWidget {
  /// Widget con được bọc bởi RxLifecycle.
  final Widget child;

  /// Hàm callback được gọi khi Widget bị dispose.
  final VoidCallback? onDispose;

  const RxLifecycle({
    Key? key,
    required this.child,
    this.onDispose,
  }) : super(key: key);

  @override
  _RxLifecycleState createState() => _RxLifecycleState();

  /// Hàm tiện ích để đăng ký state với RxLifecycle
  static void register(BuildContext context, RxState state) {
    final _RxLifecycleState? lifecycle =
        context.findAncestorStateOfType<_RxLifecycleState>();
    lifecycle?._registerState(state);
  }

  /// Hàm tiện ích để đăng ký controller với RxLifecycle
  static void registerController(BuildContext context, RxStateController controller) {
    final _RxLifecycleState? lifecycle =
        context.findAncestorStateOfType<_RxLifecycleState>();
    lifecycle?._registerController(controller);
  }
}

class _RxLifecycleState extends State<RxLifecycle> {
  final List<RxState> _states = [];
  final List<RxStateController> _controllers = [];

  /// Đăng ký một state
  void _registerState(RxState state) {
    if (!_states.contains(state)) {
      _states.add(state);
    }
  }

  /// Đăng ký một controller
  void _registerController(RxStateController controller) {
    if (!_controllers.contains(controller)) {
      _controllers.add(controller);
    }
  }

  @override
  void dispose() {
    // Dispose tất cả các state được đăng ký
    for (var state in _states) {
      state.dispose();
    }
    // Dispose tất cả các controller được đăng ký
    for (var controller in _controllers) {
      controller.dispose();
    }

    // Gọi callback nếu có
    widget.onDispose?.call();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
