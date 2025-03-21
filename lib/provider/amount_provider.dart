import 'package:flutter/material.dart';
import 'package:expen/domain/amount.dart';
import 'package:uuid/uuid.dart';

class AmountProvider with ChangeNotifier {
  final List<Amount> _amounts = [];
  double _range = 0;

  double get totalAmount =>
      amounts.fold(0, (sum, item) => sum + (item.amount ?? 0).toDouble());

  void calculateTotalAmount(Amount amount) {
    amounts.add(amount);
    notifyListeners();
  }

  double get range => _range;

  void setRange(double newRange) {
    _range = newRange;
    notifyListeners();
  }

  List<Amount> get amounts => _amounts;

  void addAmount(String title, double? amount) {
    _amounts.add(
      Amount(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        //
      ),
    );
    notifyListeners();
  }

  void deleteAmount(String id) {
    _amounts.removeWhere((amounts) => amounts.id == id);
    notifyListeners();
  }
}
