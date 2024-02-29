class Content {

  int? id;
  String? type;
  String? content;
  String? createdAt;
  String? updatedAt;

  Content({
    this.id,
    this.type,
    this.content,
    this.createdAt,
    this.updatedAt,
  });
  Content.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    type = json['type']?.toString();
    content = json['content']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ContentResponseModel {

  int? status;
  String? message;
  Content? data;

  ContentResponseModel({
    this.status,
    this.message,
    this.data,
  });
  ContentResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    data = (json['data'] != null) ? Content.fromJson(json['data']) : null;
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
