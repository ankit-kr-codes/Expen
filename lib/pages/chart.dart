import 'dart:math';
import 'package:expen/bloc/currency/currency_bloc.dart';
import 'package:expen/bloc/currency/currency_state.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/domain/currency_symbol.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    var amountList = Provider.of<AmountProvider>(context).amounts;
    double totalAmount = Provider.of<AmountProvider>(context).totalAmount;
    var rangeProvider = Provider.of<AmountProvider>(context);
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
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: max(7, amountList.length) * 55,
                height: mediaQuery.height * 0.7,
                child: BarChart(
                  BarChartData(
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: rangeProvider.range,
                          color: AppColors.red,
                        ),
                        //
                      ],
                    ),
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
                            dashArray: [5, 5],
                          ),
                    ),
                    alignment: BarChartAlignment.spaceEvenly,
                    barGroups: List.generate(
                      amountList.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: amountList[index].amount!,
                            width: 20,
                            borderRadius: BorderRadius.circular(8),
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
                          reservedSize: 40,
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
                                " Day ${value.toInt()} ",
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
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Text(
                  "Total spent: ${currencySymbol[state.selectedCurrencyIndex]["symbol"]}${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Text(
                  "Limit: ${currencySymbol[state.selectedCurrencyIndex]["symbol"]}${rangeProvider.range}",
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        rangeProvider.range < totalAmount
                            ? Colors.red
                            : Colors.green,
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
