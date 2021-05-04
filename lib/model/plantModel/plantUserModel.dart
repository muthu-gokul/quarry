class PlantUserModel {
  PlantUserModel({
    this.userId,
    this.plantId,
    this.plantName,
    this.isActive
  });

  int userId;
  int plantId;
  String plantName;
  bool isActive;

  factory PlantUserModel.fromJson(Map<String, dynamic> json) => PlantUserModel(
    userId: json["UserId"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    isActive: true
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "PlantId": plantId,
    "PlantName": plantName,
  };


  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

}