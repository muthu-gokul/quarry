class PlantTypeModel{
  int PlantTypeId;
  String PlantTypeName;

  PlantTypeModel({this.PlantTypeId, this.PlantTypeName});

  factory PlantTypeModel.fromJson(Map<String, dynamic> json) => PlantTypeModel(
    PlantTypeId: json["PlantTypeId"],
    PlantTypeName: json["PlantTypeName"],

  );

}