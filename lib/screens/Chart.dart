import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/screens/cash_pay.dart';
import '../Bloc/ChartBloc.dart';
import '../models/Product.dart';
import '../services/Dio_api.dart';
import '../widgets/AppButton.dart';
import '../widgets/Product_Widget.dart';

class Charts_list extends StatefulWidget {
  const Charts_list({super.key});


  @override
  State<Charts_list> createState() => _Charts_listState();
}

class _Charts_listState extends State<Charts_list> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,
          title: Text('Chart'),foregroundColor: Colors.white),
      body:RefreshIndicator(
          onRefresh: ()async{setState(() {});},
          child:  BlocProvider(
              create:(_) =>ChartCubit()..Products(),
              child: BlocBuilder<ChartCubit, ChartState>(
                  builder: (context, state) {
                    if(state is LoadingState)
                      return Center(child: CircularProgressIndicator());
                    else if(state is ChartSuccess && state.data.isEmpty)
                      return Center(child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'There Is No Available Products !',
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            speed: const Duration(milliseconds: 200),
                          ),
                        ],
                        totalRepeatCount: 1,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ));
                    else if(state is ChartSuccess) {
                      List<Product> list = state.data;
                      List<Map<String,dynamic>> list2 = state.data2;
                      print("count: ${list2}");
                  Future.microtask(() {value.value=list;value2.value=list2;});
                        return ValueListenableBuilder(valueListenable:value , builder: (_,w,c){
                          return SingleChildScrollView(child: Column(children: value.value.map((e) =>
                              AnimatedContainerProduct(product: e,chart: true,count: list2.firstWhereOrNull((element) => element["id"]==e.id)??{})).toList())
                              .animate().fade(duration: 1000.ms));
                        });
                    }
                    else  if(state is ChartFailed)
                      return Center(child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'There Is No Available Products !',
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            speed: const Duration(milliseconds: 200),
                          ),
                        ],
                        totalRepeatCount: 1,
                        pause: const Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ));
                    return Container();
                  })
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:ValueListenableBuilder(builder: (_,w,c){
        if(value2.value.isEmpty || value.value.isEmpty) return Text('');
        return Padding(padding: EdgeInsets.only(bottom: 20),child:  AppButton(text: "Pay ${value.value.map((e) => e.price!*
            (value2.value.firstWhereOrNull((element) => element["id"]==e.id)==null?0:value2.value.firstWhere((element) => element["id"]==e.id)["count"])).toList()
            .reduce((value, element) => value+element).toStringAsFixed(2)} Rial", pressed: () async {
          var usdConvert = await CurrencyConverter.convert(
            from: Currency.sar,
            to: Currency.usd,
            amount:value.value.map((e) => e.price!*
                (value2.value.firstWhereOrNull((element) => element["id"]==e.id)==null?0:value2.value.firstWhere((element) => element["id"]==e.id)["count"])).toList()
                .reduce((value, element) => value+element).toDouble() );
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => Cash_pay(cost: usdConvert!.toDouble())));}, hasRadius: false,background: Colors.deepOrange,width: MediaQuery.of(context).size.width-20),);
      },valueListenable: value2)
       );
  }

}