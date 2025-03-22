import 'dart:math';
import 'package:expen/bloc/currency/currency_bloc.dart';
import 'package:expen/bloc/currency/currency_state.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/core/currency_symbol.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    //Provider
    var amountList = Provider.of<AmountProvider>(context).amounts;
    double totalAmount = Provider.of<AmountProvider>(context).totalAmount;
    var rangeProvider = Provider.of<AmountProvider>(context);

    //For getting size of screen
    Size mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Spending Chart")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Spending Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: max(7, amountList.length) * 55,
                height: mediaQuery.height * 0.6,
                child: BarChart(
                  BarChartData(
                    maxY:
                        amountList.isNotEmpty
                            ? amountList
                                    .map((e) => e.amount ?? 0)
                                    .reduce(max)
                                    .toDouble() +
                                50
                            : 100,

                    minY: 0,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      getDrawingHorizontalLine:
                          (value) => FlLine(
                            color: AppColors.grey,
                            strokeWidth: 1,
                            dashArray: [10, 10],
                          ),
                    ),
                    alignment: BarChartAlignment.spaceEvenly,
                    barGroups: List.generate(
                      amountList.length,
                      (index) => BarChartGroupData(
                        barsSpace: 20,
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: amountList[index].amount!,
                            width: 25,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                            gradient: LinearGradient(
                              colors: AppColors().gradientColors,
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget:
                              (
                                value,
                                meta,
                              ) => BlocBuilder<CurrencyBloc, CurrencyState>(
                                builder: (context, state) {
                                  return Text(
                                    "${currencySymbol[state.selectedCurrencyIndex]["symbol"]}${value.toInt()}",
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget:
                              (value, meta) => Text(
                                " ${value.toInt() + 1} ",
                                style: const TextStyle(fontSize: 12),
                              ),
                        ),
                      ),
                    ),
                  ),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                ),
              ),
            ),

            const SizedBox(height: 30),

            //Show total expenditure
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Text(
                  "Total Expenditure: ${currencySymbol[state.selectedCurrencyIndex]["symbol"]}${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            //Show target set by the user
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Text(
                  "Target: ${currencySymbol[state.selectedCurrencyIndex]["symbol"]}${rangeProvider.range}",
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        //Change color according to target and expenditure
                        rangeProvider.range == 0
                            ? AppColors.darkGrey
                            : rangeProvider.range < totalAmount
                            ? AppColors.red
                            : AppColors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
