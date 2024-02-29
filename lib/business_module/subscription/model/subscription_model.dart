class SubscriptionModelData {
/*
{
  "id": 1,
  "subscription_plan": "Monthly",
  "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit hendrerit erat consequat. Fusce dui dui, faucibus id ipsum ac, interdum pretium libero. Vivamus aliquam ipsum vel leo varius aliquet.",
  "price": 10,
  "platform_fee": 0.05,
  "total_amount": 10.05,
  "created_at": "2023-10-24T07:40:06.000000Z",
  "updated_at": "2023-10-24T07:40:06.000000Z"
}
*/

  int? id;
  String? subscriptionPlan;
  String? description;
  int? price;
  double? platformFee;
  double? totalAmount;
  String? createdAt;
  String? updatedAt;

  SubscriptionModelData({
    this.id,
    this.subscriptionPlan,
    this.description,
    this.price,
    this.platformFee,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });
  SubscriptionModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    subscriptionPlan = json['subscription_plan']?.toString();
    description = json['description']?.toString();
    price = json['price']?.toInt();
    platformFee = json['platform_fee']?.toDouble();
    totalAmount = json['total_amount']?.toDouble();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['subscription_plan'] = subscriptionPlan;
    data['description'] = description;
    data['price'] = price;
    data['platform_fee'] = platformFee;
    data['total_amount'] = totalAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SubscriptionModel {
/*
{
  "status": 1,
  "message": "Subscriptions",
  "data": [
    {
      "id": 1,
      "subscription_plan": "Monthly",
      "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit hendrerit erat consequat. Fusce dui dui, faucibus id ipsum ac, interdum pretium libero. Vivamus aliquam ipsum vel leo varius aliquet.",
      "price": 10,
      "platform_fee": 0.05,
      "total_amount": 10.05,
      "created_at": "2023-10-24T07:40:06.000000Z",
      "updated_at": "2023-10-24T07:40:06.000000Z"
    }
  ]
}
*/

  int? status;
  String? message;
  List<SubscriptionModelData?>? data;

  SubscriptionModel({
    this.status,
    this.message,
    this.data,
  });
  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <SubscriptionModelData>[];
      v.forEach((v) {
        arr0.add(SubscriptionModelData.fromJson(v));
      });
      this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    return data;
  }
}
