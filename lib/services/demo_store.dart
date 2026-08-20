import 'package:flutter/foundation.dart';

import '../models.dart';

class DemoStore extends ChangeNotifier {
  DemoStore._();

  static final DemoStore instance = DemoStore._();

  DemoOrder? activeOrder;

  void createDemoOrder() {
    activeOrder = const DemoOrder(
      id: 'FH-0001',
      merchantName: 'FoodHub Kitchen',
      itemTotal: 45000,
      deliveryFee: 10000,
      customerTotal: 55000,
      status: OrderStatus.created,
    );

    notifyListeners();
  }

  void merchantAccept() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.accepted,
    );

    notifyListeners();
  }

  void startPreparing() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.preparing,
    );

    notifyListeners();
  }

  void markReady() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.ready,
    );

    notifyListeners();
  }

  void assignDriver() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.assigned,
      driverName: 'Driver FoodHub',
    );

    notifyListeners();
  }

  void pickup() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.pickedUp,
    );

    notifyListeners();
  }

  void onTheWay() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.onTheWay,
    );

    notifyListeners();
  }

  void delivered() {
    if (activeOrder == null) return;

    activeOrder = activeOrder!.copyWith(
      status: OrderStatus.delivered,
    );

    notifyListeners();
  }
}
