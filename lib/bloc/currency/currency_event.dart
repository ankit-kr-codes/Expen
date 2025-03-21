import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();
}

class SelectCurrency extends CurrencyEvent {
  final int index;

  const SelectCurrency(this.index);

  @override
  List<Object?> get props => [index];
}
