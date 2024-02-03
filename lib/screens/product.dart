import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/Product.dart';

class Product_Screen extends StatefulWidget {
  final Product product;
  const Product_Screen({super.key, required this.product});

  @override
  State<Product_Screen> createState() => _Product_ScreenState();
}

class _Product_ScreenState extends State<Product_Screen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(elevation: 0.1, foregroundColor: Colors.black),
    body:SingleChildScrollView(child: Column(
     mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      if(widget.product.image!.contains('http'))
        Container(child: CachedNetworkImage(
          imageUrl: widget.product.image!,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ), color: Colors.white , width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height*0.15)
      , if(!widget.product.image!.contains('http'))
        Image.memory(base64Decode( widget.product.image!),   width:MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height*0.15),
   Row(mainAxisSize: MainAxisSize.min,
   mainAxisAlignment: MainAxisAlignment.start,
   crossAxisAlignment: CrossAxisAlignment.end,
   children: [
     Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox(width: 5),
         Text(widget.product.price.toString(),style: TextStyle(color: Colors.red,fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold),maxLines: 3,textAlign: TextAlign.left),
         Container(alignment: Alignment.bottomLeft
             ,width:MediaQuery.of(context).size.width*0.45,child:
             Text(" Rial",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.w400),maxLines: 3,textAlign: TextAlign.left))
       ],),
     SizedBox(width: MediaQuery.of(context).size.width*0.3),
     Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,
         children: [
           Icon(Icons.star,color: Colors.yellow),
           Text(widget.product.rate!.rate.toString(),style:
           TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.center),
         ])
   ]), SizedBox(height: 20),
Center(child:  Container(height: 1,color: Colors.black,width: MediaQuery.of(context).size.width*0.6)),
          SizedBox(height: 20),
   Padding(padding: EdgeInsets.only(left: 5),child: Text(widget.product.title!,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,
       fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 3, textAlign: TextAlign.left)),
          SizedBox(height: 20),
          Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" Description: ",style: TextStyle(color: Colors.red,fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold),textAlign: TextAlign.left),
              Container(alignment: Alignment.topCenter
                  ,width:MediaQuery.of(context).size.width*0.7,child:
                  Text(widget.product.description!,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.w400),
                      textAlign: TextAlign.left,maxLines: 8,overflow: TextOverflow.ellipsis))
            ],)
    ])) ,
   );
  }

}