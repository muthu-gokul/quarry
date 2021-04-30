class PlantUserModel {
  PlantUserModel({
    this.userId,
    this.plantId,
    this.plantName,
  });

  int userId;
  int plantId;
  String plantName;

  factory PlantUserModel.fromJson(Map<String, dynamic> json) => PlantUserModel(
    userId: json["UserId"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "PlantId": plantId,
    "PlantName": plantName,
  };
}