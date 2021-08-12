class PlantTypeModel{
  int? PlantTypeId;
  String? PlantTypeName;

  PlantTypeModel({this.PlantTypeId, this.PlantTypeName});

  factory PlantTypeModel.fromJson(Map<String, dynamic> json) => PlantTypeModel(
    PlantTypeId: json["PlantTypeId"],
    PlantTypeName: json["PlantTypeName"],

  );
  Map<String, dynamic> toJson() => {
    "PlantTypeId": PlantTypeId,
    "PlantTypeName": PlantTypeName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}