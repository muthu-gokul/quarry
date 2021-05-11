class MaterialModel {
  MaterialModel({
    this.materialId,
    this.materialName,
    this.isActive
  });

  int materialId;
  String materialName;
  bool isActive;

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    isActive: true
  );

  Map<String, dynamic> toJson() => {
    "MaterialId": materialId,
    "MaterialName": materialName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
