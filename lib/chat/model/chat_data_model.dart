class ChatModelData {
/*
{
  "full_name": "USER",
  "profile_image": null,
  "id": 6,
  "conversation_id": 3,
  "sender_id": 24,
  "receiver_id": 4,
  "type": "text",
  "message": "hi",
  "read_at": null,
  "status": null,
  "created_at": "2023-11-03T09:50:33.000Z",
  "updated_at": null
}
*/

  String? fullName;
  String? profileImage;
  int? id;
  int? conversationId;
  int? senderId;
  int? receiverId;
  String? type;
  String? message;
  String? readAt;
  String? status;
  String? createdAt;
  String? updatedAt;

  ChatModelData({
    this.fullName,
    this.profileImage,
    this.id,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.readAt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
  ChatModelData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name']?.toString();
    profileImage = json['profile_image']?.toString();
    id = json['id']?.toInt();
    conversationId = json['conversation_id']?.toInt();
    senderId = json['sender_id']?.toInt();
    receiverId = json['receiver_id']?.toInt();
    type = json['type']?.toString();
    message = json['message']?.toString();
    readAt = json['read_at']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['profile_image'] = profileImage;
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['type'] = type;
    data['message'] = message;
    data['read_at'] = readAt;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ChatModel {
/*
{
  "object_type": "get_messages",
  "data": [
    {
      "full_name": "USER",
      "profile_image": null,
      "id": 6,
      "conversation_id": 3,
      "sender_id": 24,
      "receiver_id": 4,
      "type": "text",
      "message": "hi",
      "read_at": null,
      "status": null,
      "created_at": "2023-11-03T09:50:33.000Z",
      "updated_at": null
    }
  ]
}
*/

  String? objectType;
  List<ChatModelData?>? data;

  ChatModel({
    this.objectType,
    this.data,
  });
  ChatModel.fromJson(Map<String, dynamic> json) {
    objectType = json['object_type']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <ChatModelData>[];
      v.forEach((v) {
        arr0.add(ChatModelData.fromJson(v));
      });
      this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['object_type'] = objectType;
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
