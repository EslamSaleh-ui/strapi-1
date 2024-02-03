import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:payment/models/Product.dart';
import '../services/Dio_api.dart';
part 'ProductsStates.dart';

class ProductCubit extends Cubit<ProductState> {
  late DioServices _Products;
  ProductCubit() : super(ProductStateInitial());

  Products() async {
    emit(LoadingState());
    if (await InternetConnectionChecker().hasConnection) {
      _Products = DioProducts();
    } else {
      _Products = HiveProducts();
    }
    final result =
    await _Products.GetProducts();
    if (result == null) {
      emit(ProductFailed());
      return null;
    } else {
      emit(ProductSuccess(result));
      return true;
    }
  }
}