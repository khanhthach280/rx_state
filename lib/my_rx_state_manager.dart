import 'my_rx_state.dart';

/// Lớp quản lý toàn cục các RxState
class RxStateManager {
  // Một Map để lưu trữ tất cả các RxState
  final Map<String, RxState> _states = {};

  // Singleton instance
  static final RxStateManager _instance = RxStateManager._internal();

  factory RxStateManager() {
    return _instance;
  }

  RxStateManager._internal();

  /// Thêm một RxState vào quản lý
  void addState<T>(String key, RxState<T> state) {
    _states[key] = state;
  }

  /// Lấy một RxState từ manager dựa trên key
  RxState<T>? getState<T>(String key) {
    return _states[key] as RxState<T>?;
  }

  /// Xóa state và dispose nếu tồn tại
  void removeState(String key) {
    print('========  delete');
    final state = _states.remove(key);
    state?.dispose(); // Dispose state khi xóa
  }
}