class ProductionInputTypeListModel{
  int? materialId;
  String? materialName;
  int? MaterialUnitId;
  String? UnitName;
  ProductionInputTypeListModel({this.materialId,this.materialName,this.MaterialUnitId,this.UnitName});

  factory ProductionInputTypeListModel.fromJson(Map<String, dynamic> json) => ProductionInputTypeListModel(
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    MaterialUnitId: json["MaterialUnitId"],
    UnitName: json["UnitName"],
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