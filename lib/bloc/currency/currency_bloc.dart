import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(const CurrencyState(0)) {
    on<SelectCurrency>((event, emit) {
      emit(CurrencyState(event.index));
    });
  }
}
