import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/models/Product.dart';
import '../services/Dio_api.dart';
part 'ChartStates.dart';

class ChartCubit extends Cubit<ChartState> {
  late DioServices _Products;
  ChartCubit() : super(ChartStateInitial());

  Products() async {
    emit(LoadingState());
      _Products = HiveProducts();
    final result =
    await _Products.GetChart();
    final result2 =
    await _Products.GetCounter();
    if (result == null || result2==null) {
      emit(ChartFailed());
      return null;
    } else {
      emit(ChartSuccess(result,result2));
      return true;
    }
  }
}