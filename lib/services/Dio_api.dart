import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
import 'package:payment/models/Product.dart';

abstract class DioServices{
  Future<List<Product>?> GetProducts();
  Future<List<Product>?> GetChart();
  Future<List<Map<String,dynamic>>?> GetCounter();
  Future SaveCounter(List<Map<String,dynamic>> data);
  Future AddToChart(List<Product> data);
}

class DioProducts implements DioServices{

  final dio=Dio();

  @override
  Future<List<Product>?> GetProducts() async{
    try {
      final result = await dio.get("https://fakestoreapi.com/products",
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      if(result.statusCode==200)
        {
          List<Product> list=List.from(result.data).map((e) => Product.fromJson(e)).toList();
          list.forEach((element) async {String? base=await networkImageToBase64(element.image!); element.image=base!;
          print(element.image);
          });
          await _saveToHive(list);
          return list;
        }
      else
        return null;
    } on Exception catch (e){
      print(e.toString());
      return null;
    }
  }

  Future _saveToHive(List<Product> data) async {
    Directory directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'Product', // Name of your database
      {'Products'}, // Names of your boxes
      path: directory.path,
    );

    final Products = await collection.openBox<String>('Products');

    await Products.put("Products_",json.encode( data));
  }

  @override
  Future AddToChart(List<Product> data) {
    // TODO: implement AddToChart
    throw UnimplementedError();
  }

  @override
  Future<List<Product>?> GetChart() {
    // TODO: implement GetChart
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>?> GetCounter() {
    // TODO: implement GetCounter
    throw UnimplementedError();
  }

  @override
  Future SaveCounter(List<Map<String, dynamic>> data) {
    // TODO: implement SaveCounter
    throw UnimplementedError();
  }

}

class HiveProducts implements DioServices{
  @override
  Future<List<Product>?> GetProducts() async {
    List<Product>? list2;
    Directory directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'Product', // Name of your database
      {'Products'}, // Names of your boxes
      path: directory.path,
    );

    final Products = await collection.openBox<String>('Products');
    String? res=await Products.get("Products_");
    if(res!=null){
    List<dynamic> list1= await json.decode(res);
     list2=list1.map((e) => Product.fromJson(e)).toList();}
   return res==null?null: list2;
  }

  @override
  Future AddToChart(List<Product> data,{bool re_back=false})async{
    List<Product> list= await GetChart()??[];
    print(list);
    Directory directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'Chart', // Name of your database
      {'Chart'}, // Names of your boxes
      path: directory.path,
    );
      data.forEach((element) async {if(element.image!.startsWith("http")) {String? base=await networkImageToBase64(element.image!); element.image=base!;}});
    data.forEach((element) {  if(list.isEmpty || (list.isNotEmpty && list.firstWhereOrNull((element2) => element2.id==element.id)==null) ) list.addAll([element]); });
    final Products = await collection.openBox<String>('Chart');
    if(re_back)  await Products.clear();
    await Products.put("Charts_",json.encode(re_back?data: list));
    return true;
  }

  Future DeleteFromChart(List<Product> data)async{
    List<Product> list= await GetChart()??[];
    print(list);
    list.removeWhere((element) => element.id==data.first.id);
    print(list);
    await AddToChart(list,re_back: true);
    return true;
  }

  Future DeleteFromCounter(List<Map<String,dynamic>> data)async{
    List<Map<String,dynamic>> list= await GetCounter()??[];
    print(list);
    list.removeWhere((element) => element["id"]==data.first["id"]);
    print(list);
    await SaveCounter(list,re_back: true);
    return true;
  }

  @override
  Future<List<Product>?> GetChart() async {
    try{
    List<Product>? list2;
    Directory directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'Chart', // Name of your database
      {'Chart'}, // Names of your boxes
      path: directory.path,
    );
    final Products = await collection.openBox<String>('Chart');
    String? res=await Products.get("Charts_");
    if(res!=null){
      List<dynamic> list1= await json.decode(res);
      list2=list1.map((e) => Product.fromJson(e)).toList();}
    return res==null?null: list2;
    }
  catch(e){return null;}
  }

  @override
  Future<List<Map<String, dynamic>>?> GetCounter() async {
    try{
    List<Map<String, dynamic>>? list2;
    Directory directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'Counter', // Name of your database
      {'Counter'}, // Names of your boxes
      path: directory.path,
    );

    final Products = await collection.openBox<String>('Counter');
    String? res=await Products.get("Counters_");
    if(res!=null){
      List<dynamic> list1= await json.decode(res);
      list2=list1.map((e) => Map<String,dynamic>.from(e)).toList();}
    return res==null?null: list2;}
        catch(e){return null;}
  }

  @override
  Future SaveCounter(List<Map<String, dynamic>> data,{bool re_back=false,bool update=false}) async {
    List<Map<String,dynamic>> list= await GetCounter()??[];
    Directory directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'Counter', // Name of your database
      {'Counter'}, // Names of your boxes
      path: directory.path,
    );
    final Products = await collection.openBox<String>('Counter');
    if(update)
     list.firstWhereOrNull((element) => element["id"]==data.first["id"])!.update("count", (value) => data.first["count"]);
    else
    data.forEach((element) {  if( list.isEmpty || (list.isNotEmpty && list.firstWhereOrNull((element2) => element["id"]==element2["id"])==null) ) list.addAll([element]); });
    if(re_back) await Products.clear();
    await Products.put("Counters_",json.encode(re_back?data: list));
    print("saved");
    return true;
  }
}

Future<String?> networkImageToBase64(String imageUrl) async {
  http.Response response = await http.get(Uri.parse(imageUrl));
  final bytes = response.bodyBytes;
  return  base64Encode(bytes) ;
}