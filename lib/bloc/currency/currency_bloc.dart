import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(const CurrencyState(0)) {
    on<SelectCurrency>(_onSelectCurrency);

    _loadCurrencySymbol();
  }

  Future<void> _onSelectCurrency(
    SelectCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyState(event.index));

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('currencySymbol', event.index.toString());
  }

  Future<void> _loadCurrencySymbol() async {
    var prefs = await SharedPreferences.getInstance();
    String savedSymbol = prefs.getString('currencySymbol') ?? "0";

    int savedSymbolInt = int.tryParse(savedSymbol) ?? 0;

    add(SelectCurrency(savedSymbolInt));
  }
}
