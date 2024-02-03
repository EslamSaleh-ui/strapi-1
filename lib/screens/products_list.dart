import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/screens/Chart.dart';
import 'package:payment/screens/product.dart';
import '../Bloc/ProductsBloc.dart';
import '../models/Product.dart';
import '../services/Dio_api.dart';
import '../widgets/Product_Widget.dart';

class Products_list extends StatefulWidget {
  const Products_list({super.key});


  @override
  State<Products_list> createState() => _Products_listState();
}

class _Products_listState extends State<Products_list> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,
      title: Text('Products'),foregroundColor: Colors.white,actions: [IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => Charts_list()));
          }, icon: Icon(Icons.shopping_cart_outlined))]),
      body:RefreshIndicator(
        onRefresh: ()async{setState(() {});},
    child:  BlocProvider(
        create:(_) =>ProductCubit()..Products(),
          child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if(state is LoadingState)
              return Center(child: CircularProgressIndicator());
            else if(state is ProductSuccess) {
              List<Product> list = state.data;
              return SingleChildScrollView(child: Column(children: list.map((
                  e) =>
                  GestureDetector(child: AnimatedContainerProduct(product: e),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => Product_Screen(product: e)));
                      })).toList())
                  .animate().fade(duration: 1000.ms));
            } else  if(state is ProductFailed)
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
    );
  }

}