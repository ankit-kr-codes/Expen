import 'package:flutter/material.dart';
import 'package:expen/model/amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AmountProvider with ChangeNotifier {
  //Variables
  final List<Amount> _amounts = [];
  double _range = 2000; //Default target is set to 2000
  final Uuid _uuid =
      const Uuid(); //This will generate a unique id for the expense

  //Constructor
  AmountProvider() {
    _loadRange();
  }

  //Getters
  List<Amount> get amounts =>
      _amounts.reversed
          .toList(); //.reversed the list to get latest expense at top of home screen

  double get range => _range;
  double get totalAmount =>
      _amounts.fold(0, (sum, item) => sum + (item.amount ?? 0).toDouble());

  //Functions

  //This function calculates total amount to show in home screen and chart screen
  void calculateTotalAmount(Amount amount) {
    _amounts.add(amount);
    notifyListeners();
  }

  //This function sets a target for spending money
  Future<void> setRange(double newRange) async {
    _range = newRange;
    notifyListeners();

    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble('targetLimit', newRange);
  }

  //This function loads the range when its called
  Future<void> _loadRange() async {
    var prefs = await SharedPreferences.getInstance();
    _range = prefs.getDouble('targetLimit') ?? 0; // Default to 0 if not set
    notifyListeners();
  }

  //This function adds expense to the list(shows in home screen)
  void addAmount(String title, String subtitle, double? amount) {
    _amounts.add(
      Amount(id: _uuid.v4(), title: title, subtitle: subtitle, amount: amount),
    );
    notifyListeners();
  }

  //This function delete a specific expense
  void deleteAmount(String id) {
    _amounts.removeWhere((amount) => amount.id == id);
    notifyListeners();
  }

  //This function delets all the expenses
  void deleteAllExpenses() {
    _amounts.clear();
    notifyListeners();
  }
}
