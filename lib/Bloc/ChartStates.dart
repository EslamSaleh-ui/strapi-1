part of 'ChartBloc.dart';

abstract class ChartState {}

class ChartStateInitial extends ChartState {}

class LoadingState extends ChartState {}

class ChartSuccess extends ChartState {
  final List<Product> data;
  final List<Map<String,dynamic>> data2;

  ChartSuccess(this.data,this.data2);
}

class ChartFailed extends ChartState {}