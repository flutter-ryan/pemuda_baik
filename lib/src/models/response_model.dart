ResponseModel responseModelFromJson(dynamic str) => ResponseModel.fromJson(str);

class ResponseModel {
  ResponseModel({
    this.message,
  });

  String? message;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        message: json["message"],
      );
}
