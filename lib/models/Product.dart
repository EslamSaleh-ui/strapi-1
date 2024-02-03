import 'Rating.dart';

class Product{
   int? id;
   num? price;
   String? description,category,image,title;
   Rating? rate;
   
  Product({ this.id, this.price, this.category, this.description, this.image,this.rate,this.title});

  Product.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    title=json['title'];
    price=json['price'];
    description=json['description'];
    category=json['category'];
    image=json['image'];
    rate=Rating.fromJson(json['rating']);
  }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['id']=id;
     data['title']=title;
     data['price']=price;
     data['description']=description;
     data['category']=category;
     data['image']=image;
     data['rating']=rate;
     return data;
  }

}