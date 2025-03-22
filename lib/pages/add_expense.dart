import 'package:expen/bloc/currency/currency_bloc.dart';
import 'package:expen/bloc/currency/currency_state.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/core/currency_symbol.dart';
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
  //Controllers
  TextEditingController numController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();

  //Border design
  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    //Provider
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
            //Getting amount from user
            SizedBox(
              width: 150,
              child: TextField(
                controller: numController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightTransparent,
                  // labelText: "Enter Amount",
                  hintText: "0.00",
                  prefixIcon: BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: 0,
                        child: Center(
                          heightFactor: 0.2,
                          child: Text(
                            currencySymbol[state
                                    .selectedCurrencyIndex]["symbol"] ??
                                "", //This will show selected currency symbol
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
                  border: _outlineInputBorder,
                  enabledBorder: _outlineInputBorder,
                  focusedBorder: _outlineInputBorder,
                  hoverColor: AppColors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 50),

            //Getting title from the user
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Expense Title"),
              //
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.lightTransparent,
                border: _outlineInputBorder,
                enabledBorder: _outlineInputBorder,
                focusedBorder: _outlineInputBorder,
                hoverColor: AppColors.transparent,
              ),
            ),
            const SizedBox(height: 30),

            //Getting description from the user
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Expense Description"),
              //
            ),
            const SizedBox(height: 10),
            TextField(
              controller: subTitleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.lightTransparent,
                border: _outlineInputBorder,
                enabledBorder: _outlineInputBorder,
                focusedBorder: _outlineInputBorder,
                hoverColor: AppColors.transparent,
              ),
            ),
            const SizedBox(height: 40),

            //Saving expense data
            ElevatedButton(
              //This will add expense to the list(it will be shown in home screen)
              onPressed: () {
                //Check if the textfield is empty or not
                if (numController.text.isNotEmpty) {
                  double? amount = double.tryParse(numController.text);
                  String title = titleController.text;
                  String subtitle = subTitleController.text;

                  if (amount != null) {
                    amountProvider.addAmount(title, subtitle, amount);
                    context.pop();
                    //User will go to home screen and get a dialog box to notify that expense is added
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
                    //Inform user that entered amout in invalid (means its not double value)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid amount"),
                        showCloseIcon: true,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                  numController.clear(); // This will clear the textfield
                  titleController.clear(); // This will clear the textfield
                } else {
                  //If textfield is empty then user will get this snackbar
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
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0),
                overlayColor: WidgetStatePropertyAll(AppColors.transparent),
              ),
              child: const Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
