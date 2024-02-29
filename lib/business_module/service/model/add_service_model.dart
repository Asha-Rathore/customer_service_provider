class Service {
  int? id;
  int? userId;
  String? serviceImage;
  String? name;
  String? location;
  String? description;
  String? createdAt;
  String? updatedAt;

  Service({
    this.id,
    this.userId,
    this.serviceImage,
    this.name,
    this.location,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
  Service.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    userId = json['user_id']?.toInt();
    serviceImage = json['service_image']?.toString();
    name = json['name']?.toString();
    location = json['location']?.toString();
    description = json['description']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['service_image'] = serviceImage;
    data['name'] = name;
    data['location'] = location;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ServiceResponseModel {
  int? status;
  String? message;
  Service? data;

  ServiceResponseModel({
    this.status,
    this.message,
    this.data,
  });
  ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    data = (json['data'] != null) ? Service.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
