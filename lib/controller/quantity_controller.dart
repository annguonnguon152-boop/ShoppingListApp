import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityNotifier extends Notifier<int> {
  @override
  int build() {
    return 1;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 1) {
      state--;
    }
  }

  void reset() {
    state = 1;
  }
}

final quantityProvider = NotifierProvider<QuantityNotifier, int>(
  QuantityNotifier.new,
);
