import 'package:expen/bloc/currency/currency_bloc.dart';
import 'package:expen/bloc/currency/currency_state.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/domain/currency_symbol.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    var amountProvider = Provider.of<AmountProvider>(context);
    double totalAmount = Provider.of<AmountProvider>(context).totalAmount;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: mediaQuery.height * 0.3,
            child: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${currencySymbol[state.selectedCurrencyIndex]["symbol"]} $totalAmount ",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Spent in total",
                      style: TextStyle(color: AppColors.darkGrey),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: amountProvider.amounts.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                var amount = amountProvider.amounts[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        amount.title.isEmpty ? "Random" : amount.title,
                      ),
                      trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
                        builder: (context, state) {
                          return Text(
                            "${currencySymbol[state.selectedCurrencyIndex]["symbol"]}${amount.amount.toString()}",
                            style: const TextStyle(fontSize: 14),
                          );
                        },
                      ),
                      subtitle: const Text("dsf"),
                      isThreeLine: true,
                      minVerticalPadding: 15,
                    ),
                    Divider(
                      color: AppColors.grey,
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.darkGrey,
        unselectedItemColor: AppColors.darkGrey,
        onTap: (value) {
          if (value == 0) {
            context.push('/chart');
          } else if (value == 2) {
            context.push('/settings');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "",
          ),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 16,
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () => context.push('/addexpense'),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
