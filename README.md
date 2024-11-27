
# Tài Liệu Thiết kế `RxState`

## 1. Giới thiệu
### Tổng quan về package

Package của chúng tôi mang đến một giải pháp quản lý state đơn giản nhưng mạnh mẽ cho các ứng dụng Flutter. Dựa trên mô hình Reactive **Programming (Rx)**, package giúp bạn dễ dàng lắng nghe, cập nhật, và quản lý các state trong ứng dụng với hiệu suất cao.

(https://baoflutter.com/wp-content/uploads/2020/05/rx-programming.png)

Các thành phần chính trong package bao gồm:

- RxState: Lớp quản lý từng state riêng lẻ với khả năng lắng nghe thay đổi thông qua Stream.
- RxBuilder: Widget cho phép tự động cập nhật giao diện khi một state thay đổi.
- MultiRxBuilder: Widget đặc biệt giúp lắng nghe và phản hồi với nhiều state cùng lúc, phù hợp cho các giao diện phức tạp.
- RxStateManager: Công cụ quản lý state toàn cục, giúp tổ chức và chia sẻ state giữa các màn hình hoặc thành phần khác nhau.
- RxLifecycle: Tự động quản lý vòng đời của state, đảm bảo không gây rò rỉ bộ nhớ.
- RxStateController: Cho phép nhóm nhiều state lại trong một controller để tổ chức và sử dụng dễ dàng hơn.

Với cấu trúc rõ ràng và khả năng mở rộng cao, package này phù hợp cho cả dự án nhỏ lẻ và ứng dụng phức tạp.

### Lợi ích khi sử dụng package

#### 1. Đơn giản và dễ tích hợp:
- Cung cấp **API thân thiện**, không đòi hỏi thay đổi lớn trong cấu trúc dự án.
- Tích hợp nhanh chóng với các widget và cơ chế hiện tại của Flutter.

#### 2. Hiệu suất cao:
- Chỉ cập nhật UI khi **state thực sự thay đổi**, giúp tối ưu hóa việc render.
- `MultiRxBuilder` hỗ trợ quản lý nhiều state đồng thời mà vẫn đảm bảo hiệu suất ổn định.

#### 3. Linh hoạt trong quản lý state:
- Hỗ trợ cả state **đơn giản** (biến) và **phức tạp** (map, list, nested state).
- Quản lý state linh hoạt theo dạng **cục bộ** và **toàn cục**.

#### 4. Tự động hóa vòng đời state:
- `RxLifecycle` đảm bảo không rò rỉ bộ nhớ và quản lý tài nguyên hiệu quả hơn.

#### 5. Hỗ trợ cập nhật theo thời gian thực:
- Dựa trên **Stream**, giúp ứng dụng phản hồi ngay lập tức với các thay đổi dữ liệu.

### Các trường hợp sử dụng phù hợp

#### 1. Quản lý state cục bộ:
- Khi bạn cần lắng nghe và cập nhật một hoặc nhiều state trong một màn hình hoặc widget cụ thể.

#### 2. Quản lý nhiều state đồng thời:
- Sử dụng MultiRxBuilder để cập nhật UI khi bất kỳ một trong nhiều state thay đổi (ví dụ: 	Màn hình với nhiều bộ lọc dữ liệu, giao diện tổng hợp dữ liệu từ nhiều nguồn khác nhau)

#### 3. Quản lý state toàn cục:
- Chia sẻ state giữa các màn hình, chẳng hạn như thông tin người dùng hoặc cài đặt ứng dụng.

#### 4. Ứng dụng thời gian thực:
- Các ứng dụng chat, streaming dữ liệu hoặc dashboard cần phản hồi tức thì với dữ liệu mới.

#### 5. Ứng dụng lớn hoặc cần tổ chức rõ ràng:
- Sử dụng RxStateController để nhóm và quản lý logic state phức tạp trong một lớp duy nhất.


## 2. Hướng dẫn sử dụng cơ bản

### Khởi tạo RxState

**RxState** là lớp cốt lõi để quản lý state. Bạn có thể khởi tạo và sử dụng như sau:

#### Khởi tạo một state đơn giản

```dart
import 'package:my_rx_package/my_rx_state.dart';

final counterState = RxState<int>(0); // Giá trị khởi tạo là 0
```

#### Cập nhật state

```dart
counterState.value = counterState.value + 1;
```

#### Lắng nghe thay đổi

```dart
counterState.stream.listen((value) {
  print("State updated: $value");
});
```

#### Reset lại state

```dart
counterState.reset();
```

### Sử dụng RxBuilder để cập nhật giao diện

**RxBuilder** giúp bạn lắng nghe thay đổi từ một state và tự động cập nhật UI.

```dart
import 'package:flutter/material.dart';
import 'package:my_rx_package/my_rx_state.dart';

class CounterApp extends StatelessWidget {
  final counterState = RxState<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: RxBuilder<int>(
          state: counterState,
          builder: (context, value) {
            return Text('Counter: $value', style: TextStyle(fontSize: 24));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counterState.value += 1,
        child: Icon(Icons.add),
      ),
    );
  }
}
```
### Sử dụng MultiRxBuilder

**MultiRxBuilder** cho phép bạn lắng nghe nhiều state cùng lúc và cập nhật UI khi bất kỳ state nào thay đổi.

```dart
import 'package:flutter/material.dart';
import 'package:my_rx_package/my_rx_state.dart';

class MultiCounterApp extends StatelessWidget {
  final counterA = RxState<int>(0);
  final counterB = RxState<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi Counter App')),
      body: MultiRxBuilder(
        states: [counterA, counterB],
        builder: (context, values) {
          final valueA = values[0] as int;
          final valueB = values[1] as int;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Counter A: $valueA', style: TextStyle(fontSize: 24)),
              Text('Counter B: $valueB', style: TextStyle(fontSize: 24)),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => counterA.value += 1,
            child: Icon(Icons.add),
            heroTag: 'btnA',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => counterB.value += 1,
            child: Icon(Icons.add),
            heroTag: 'btnB',
          ),
        ],
      ),
    );
  }
}
```

### Quản lý state toàn cục với RxStateManager

#### Thêm state vào RxStateManager

```dart
import 'package:my_rx_package/my_rx_state_manager.dart';

final counterState = RxState<int>(0);
RxStateManager().addState('counter', counterState);

```

#### Lấy state từ RxStateManager

```dart
final counter = RxStateManager().getState<int>('counter');
counter?.value += 1; // Cập nhật giá trị
```

#### Xóa state khỏi RxStateManager:

```dart
RxStateManager().removeState('counter');
```

### Sử dụng RxStateController

```dart
import 'package:my_rx_package/my_rx_state_controller.dart';

class CounterController extends RxStateController {
  late final counterA = registerState<int>('counterA', 0);
  late final counterB = registerState<int>('counterB', 0);

  void incrementA() {
    counterA.value += 1;
  }

  void incrementB() {
    counterB.value += 1;
  }
}
```

#### Sử dụng trong UI

```dart
final controller = CounterController();

controller.incrementA();
final valueA = controller.getState<int>('counterA')?.value ?? 0;
print('Counter A: $valueA');
```

## 3. Hướng dẫn sử dụng RxLifecycle

RxLifecycle giúp bạn tự động dispose các state khi Widget bị hủy bỏ. Chỉ cần bọc Widget của bạn bằng **RxLifecycle** và đăng ký các state muốn theo dõi.

### Tích hợp RxLifecycle vào Widget

import 'package:flutter/material.dart';
import 'package:my_rx_package/my_rx_state.dart';
import 'package:my_rx_package/rx_lifecycle.dart';

class CounterAppWithLifecycle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter with RxLifecycle')),
      body: RxLifecycle(
        onDispose: () {
          print('Widget is being disposed. Clean up here!');
        },
        child: CounterScreen(),
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

## 4. Hướng phát triển thêm
- Tạo thêm 1 class baseView để hiện kiểm soát rendeUI mà không cần phải truyền biến vào lắng nghe
- Cải tiến lại controller có thêm phần init() và dispose() để tạo thuận lợi cho việc kiểm soát dữ liệu

