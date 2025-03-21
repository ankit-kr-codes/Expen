import 'package:expen/bloc/currency/currency_bloc.dart';
import 'package:expen/bloc/currency/currency_state.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/domain/currency_symbol.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController numController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();

  final UnderlineInputBorder _border = UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: AppColors.grey),
  );

  @override
  Widget build(BuildContext context) {
    var amountProvider = Provider.of<AmountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("Cancel", style: TextStyle(color: AppColors.blue)),
          ),
        ),
        leadingWidth: 70,
        centerTitle: true,
        title: const Text(
          "Add New Expense",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: numController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Enter Amount",
                prefixIcon: BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: 0,
                      child: Center(
                        heightFactor: 0.2,
                        child: Text(
                          currencySymbol[state
                                  .selectedCurrencyIndex]["symbol"] ??
                              "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                prefixStyle: TextStyle(color: AppColors.grey),
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
            const SizedBox(height: 50),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Expense Title"),
              //
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
            const SizedBox(height: 50),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Expense Description"),
              //
            ),
            TextField(
              controller: subTitleController,
              decoration: InputDecoration(
                border: _border,
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (numController.text.isNotEmpty) {
                  double? amount = double.tryParse(numController.text);
                  String title = titleController.text;
                  String subtitle = subTitleController.text;

                  if (amount != null) {
                    amountProvider.addAmount(title, subtitle, amount);
                    context.pop();
                    showDialog<String>(
                      context: context,
                      builder:
                          (BuildContext context) => AlertDialog(
                            title: const Text('Amount added'),
                            content: const Text(
                              "Your expense has been added successfully!\n\nLong press to delete it.",
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid amount"),
                        showCloseIcon: true,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                  numController.clear();
                  titleController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter an amount. Amount cannot be empty.",
                      ),
                      showCloseIcon: true,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
