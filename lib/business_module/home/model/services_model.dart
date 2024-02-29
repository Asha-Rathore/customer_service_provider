///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ServicesListData {
/*
{
  "id": 1,
  "user_id": 4,
  "service_image": "service_image/g5MyqmHPMLHwLfz1hDm36oyLqnzLTD1wg3J3bDWX.png",
  "name": "eyr",
  "location": "E C Stoner Building, Woodhouse, Leeds, UK",
  "description": "v",
  "created_at": "2023-10-24T07:48:47.000000Z",
  "updated_at": "2023-10-25T11:47:57.000000Z"
}
*/

  int? id;
  int? userId;
  String? serviceImage;
  String? name;
  String? location;
  String? description;
  String? createdAt;
  String? updatedAt;

  ServicesListData({
    this.id,
    this.userId,
    this.serviceImage,
    this.name,
    this.location,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
  ServicesListData.fromJson(Map<String, dynamic> json) {
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

class ServicesList {
/*
{
  "status": 1,
  "message": "Services",
  "data": [
    {
      "id": 1,
      "user_id": 4,
      "service_image": "service_image/g5MyqmHPMLHwLfz1hDm36oyLqnzLTD1wg3J3bDWX.png",
      "name": "eyr",
      "location": "E C Stoner Building, Woodhouse, Leeds, UK",
      "description": "v",
      "created_at": "2023-10-24T07:48:47.000000Z",
      "updated_at": "2023-10-25T11:47:57.000000Z"
    }
  ]
}
*/

  int? status;
  String? message;
  List<ServicesListData?>? data;

  ServicesList({
    this.status,
    this.message,
    this.data,
  });
  ServicesList.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <ServicesListData>[];
      v.forEach((v) {
        arr0.add(ServicesListData.fromJson(v));
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
