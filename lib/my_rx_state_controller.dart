import 'my_rx_state.dart';
import 'my_rx_state_manager.dart';

/// Base controller cho phép quản lý nhiều RxState dễ dàng
abstract class RxStateController {
  final RxStateManager _manager = RxStateManager();
  final Map<String, RxState> _localStates = {};

  /// Khởi tạo một RxState và lưu vào Manager
  RxState<T> addState<T>(String key, T initialValue) {
    if (_localStates.containsKey(key)) {
      throw Exception("State với key '$key' đã tồn tại.");
    }

    final state = RxState<T>(initialValue);
    _localStates[key] = state;
    _manager.addState(key, state);
    return state;
  }

  /// Truy cập state
  RxState<T> getState<T>(String key) {
    final state = _localStates[key] as RxState<T>?;
    if (state == null) {
      throw Exception("Không tìm thấy state với key '$key'.");
    }
    return state;
  }

  /// Cập nhật state bất đồng bộ
  Future<void> updateStateAsync<T>(String key, Future<T> Function() updater) async {
    final state = getState<T>(key);
    await state.updateAsync(updater);
  }

  /// Dispose tất cả state khi không còn sử dụng
  void dispose() {
    for (var key in _localStates.keys) {
      _manager.removeState(key);
    }
    _localStates.clear();
  }
}
