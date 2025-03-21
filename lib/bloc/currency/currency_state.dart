import 'package:equatable/equatable.dart';

class CurrencyState extends Equatable {
  final int selectedCurrencyIndex;

  const CurrencyState(this.selectedCurrencyIndex);

  @override
  List<Object> get props => [selectedCurrencyIndex];
}
