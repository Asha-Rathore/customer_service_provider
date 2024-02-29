class ChatAttachmentModelData {
/*
{
  "attachUrl": "uploaded_attach/Fw2StNJmk1HTPW0SqLMBA0r1wbu4sGr0pdR6dBtJ.png"
}
*/

  String? attachUrl;

  ChatAttachmentModelData({
    this.attachUrl,
  });
  ChatAttachmentModelData.fromJson(Map<String, dynamic> json) {
    attachUrl = json['attachUrl']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attachUrl'] = attachUrl;
    return data;
  }
}

class ChatAttachmentModel {
/*
{
  "status": 1,
  "message": "Attachment Done",
  "data": {
    "attachUrl": "uploaded_attach/Fw2StNJmk1HTPW0SqLMBA0r1wbu4sGr0pdR6dBtJ.png"
  }
}
*/

  int? status;
  String? message;
  ChatAttachmentModelData? data;

  ChatAttachmentModel({
    this.status,
    this.message,
    this.data,
  });
  ChatAttachmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    data = (json['data'] != null) ? ChatAttachmentModelData.fromJson(json['data']) : null;
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
