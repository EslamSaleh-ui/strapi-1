part of 'ProductsBloc.dart';

abstract class ProductState {}

class ProductStateInitial extends ProductState {}

class LoadingState extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Product> data;

  ProductSuccess(this.data);
}

class ProductFailed extends ProductState {}