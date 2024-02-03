import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:payment/widgets/Toast.dart';

class Cash_pay extends StatelessWidget{
  final double cost;

  const Cash_pay({super.key, required this.cost});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey,
          title: Text('Cash_Pay'),foregroundColor: Colors.white),
      body:Center(child:SingleChildScrollView(child:   Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment:MainAxisAlignment.spaceAround,children: [
     GestureDetector(onTap: (){Paypal(context, cost);},child:  Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow:
      [ BoxShadow( color: Colors.grey.shade500,
            offset: const Offset(
              5.0,
              5.0,
            ), blurRadius: 10.0,
            spreadRadius: 3.0 )],image: DecorationImage(image: AssetImage("assets/Paypal-logo.png") ))
          ,height: MediaQuery.of(context).size.height*0.3,width:MediaQuery.of(context).size.width-30)),SizedBox(height: 25),
    GestureDetector(onTap: (){},child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow:
            [ BoxShadow( color: Colors.grey.shade500,
                offset: const Offset(
                  5.0,
                  5.0,
                ), blurRadius: 10.0,
                spreadRadius: 3.0 )],image: DecorationImage(image: AssetImage("assets/paymob.png") ))
            ,height: MediaQuery.of(context).size.height*0.3,width:MediaQuery.of(context).size.width-30))
      ]),
    ))
    );

  }

  Paypal(BuildContext context,double cost){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
           Scaffold(body: PaypalCheckout(
            sandboxMode: true,
            clientId: "AbqQ8hxJZjHq_sR8StxpyQC10O0MaoQlJlnWtx1gSfeD_DyyHGBo76QW96oh-fxbZrGIq43xH2wi4h1e",
            secretKey: "EMTopveCF9l5TYEp0xI6IRHpJfNghmdEiNDAWC9elqy-5lHnjItTSETQlT0dndUN2dhvLXVfijcQ1Iwm",
            returnURL: "success.snippetcoder.com",
            cancelURL: "cancel.snippetcoder.com",
            transactions:  [
              {
                "amount": {
                  "total": '$cost',
                  "currency": "USD",
                  "details": {
                    "subtotal": '$cost',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description."
              }
            ],
            note: "PAYMENT_NOTE",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
            },
            onError: (error) {
              print("onError: $error");
              Navigator.pop(context);
            },
            onCancel: () {
              print('cancelled:');
            },
          ),

    )) );
  }
}