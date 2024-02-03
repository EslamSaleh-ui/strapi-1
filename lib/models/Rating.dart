
class Rating{
  num? rate,count;

  Rating({ this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate=json['rate'];
    count=json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count']=count;
    data['rate']=rate;
    return data;
  }

}