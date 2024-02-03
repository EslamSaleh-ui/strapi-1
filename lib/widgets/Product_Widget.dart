import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:counter/counter.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:payment/models/Product.dart';
import 'package:payment/services/Dio_api.dart';
import 'package:payment/widgets/Toast.dart';

final hive=HiveProducts();
ValueNotifier<List<Product> > value=ValueNotifier<List<Product> >([]);
ValueNotifier<List<Map<String,dynamic>> > value2=ValueNotifier<List<Map<String,dynamic>> >([]);

class AnimatedContainerProduct extends StatefulWidget {
  final Product product;
  final Map<String,dynamic> count;
  final bool chart;
  const AnimatedContainerProduct({super.key,required this.product,this.chart=false,this.count=const {}});

  @override
  State<AnimatedContainerProduct> createState() => _AnimatedContainerProductState();
}

class _AnimatedContainerProductState extends State<AnimatedContainerProduct> {

  @override
  Widget build(BuildContext context) {
    return   AnimatedContainer(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            width: (MediaQuery.of(context).size.width)-20,
            height: MediaQuery.of(context).size.height*0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    offset: const Offset(
                      5.0,
                      5.0,
                    ), blurRadius: 10.0,
                    spreadRadius: 3.0 )
              ]),
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
 child: Row(mainAxisSize: MainAxisSize.min,
     mainAxisAlignment:   MainAxisAlignment.start,
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Divider(height: 5,color: Colors.transparent),
       if(widget.product.image!.contains('http'))
         Container(child: CachedNetworkImage(
           imageUrl: widget.product.image!,
           placeholder: (context, url) => Center(child: CircularProgressIndicator()),
           errorWidget: (context, url, error) => Icon(Icons.error),
         ), color: Colors.white , width: MediaQuery.of(context).size.width*0.25, height: MediaQuery.of(context).size.height*0.15)
      , if(!widget.product.image!.contains('http'))
         Image.memory(base64Decode( widget.product.image!),   width:MediaQuery.of(context).size.width*0.25, height: MediaQuery.of(context).size.height*0.15),
       SizedBox(width: 5),
       Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             SizedBox(width:MediaQuery.of(context).size.width*0.6,child:
             Text(widget.product.title!,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04,fontWeight: FontWeight.w400),maxLines: 2
                 ,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left))
             ,   SizedBox(width: 5),
             Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("Category: ",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.left),
                 SizedBox(width:MediaQuery.of(context).size.width*0.45,child:
                 Text(widget.product.category!,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w400),maxLines: 1,textAlign: TextAlign.left))
               ],),
             SizedBox(width: 5),
             Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(widget.product.price.toString(),style: TextStyle(color: Colors.red,fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold),maxLines: 3,textAlign: TextAlign.left),
                 Container(alignment: Alignment.bottomLeft
                     ,width:MediaQuery.of(context).size.width*0.45,child:
                     Text(" Rial",style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.w400),maxLines: 3,textAlign: TextAlign.left))
               ],),
             SizedBox(width: 5),
             Row(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Icon(Icons.star,color: Colors.yellow),
                   Text(widget.product.rate!.rate.toString(),style:
                   TextStyle(color: Colors.grey,fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.center),
                 ]),
   Expanded(flex: 1,child:  Footer(child:widget.chart?
   Flex(
       direction: Axis.horizontal,
       mainAxisSize: MainAxisSize.min,
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.center,children: [   IconButton(onPressed: ()async{
       await hive.DeleteFromChart([widget.product]).then((value) async{
         if(value==true)
         {await hive.DeleteFromCounter([widget.count]);
           showToast(context, "Product Deleted From Chart"); }
         else
           showToast(context, "SomeThing Went Wrong Try Again Later");
       });
       value.value=(await HiveProducts().GetChart())! ;
       value2.notifyListeners();
     }, icon: Icon(Icons.delete,color: Colors.red)),
     Container(
    decoration: BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
          color: Colors.grey.shade500,
          offset: const Offset(10.0, 10.0), blurRadius: 40.0,
          spreadRadius: 3.0 )
    ]),height: 25,width: 70,child:  Counter(
       min: 1,
       max: 10,
       initial:widget.count["count"],
       step: 1,
       configuration: DefaultConfiguration(),
       onValueChanged: (i) async {
        if(mounted) {  await  hive.SaveCounter([{"id":widget.count["id"],"count":i}],update: true);value2.value=(await HiveProducts().GetCounter())!;}
         },
     )) ] )
       : IconButton(onPressed: ()async{
     await hive.AddToChart([widget.product]).then((value) async {
       if(value==true)
         {
             await  hive.SaveCounter([{"id":widget.product.id,"count":1}]);
         showToast(context, "Product Added To Chart");}
       else
         showToast(context, "SomeThing Went Wrong Try Again Later");
     });
   }, icon: Icon(Icons.shopping_cart_outlined)),backgroundColor: Colors.white,
     alignment: Alignment.centerRight
   ))
           ])
     ]),
    );
  }
}