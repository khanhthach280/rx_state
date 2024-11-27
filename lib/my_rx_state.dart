import 'package:rxdart/rxdart.dart';

/// Lớp RxState để quản lý trạng thái
class RxState<T> {
  final T _defaultValue; // Giá trị mặc định
  final BehaviorSubject<T> _subject; // Stream để quản lý giá trị

  /// Constructor, nhận giá trị mặc định
  RxState(T initialValue)
      : _defaultValue = initialValue,
        _subject = BehaviorSubject<T>.seeded(initialValue);

  /// Stream để lắng nghe giá trị thay đổi
  Stream<T> get stream => _subject.stream;

  /// Lấy giá trị hiện tại của state
  T get value => _subject.value;

  /// Cập nhật giá trị mới
  set value(T newValue) {
    if (newValue != _subject.value) {
      _subject.add(newValue);
    }
  }

  /// Cập nhật giá trị từ Future (bất đồng bộ)
  Future<void> updateAsync(Future<T> futureValue) async {
    try {
      final result = await futureValue; // Chờ đợi tác vụ bất đồng bộ
      value = result; // Cập nhật giá trị sau khi hoàn thành
    } catch (e) {
      print("Error while updating state: $e"); // Handle error nếu có
    }
  }

  /// Reset state về giá trị mặc định
  void reset() {
    // Reset lại giá trị về giá trị mặc định
    if (!_subject.isClosed) {
      value = _defaultValue;
    }
  }

  /// Hủy state, giải phóng tài nguyên
  void dispose() {
    _subject.close();
  }
}
