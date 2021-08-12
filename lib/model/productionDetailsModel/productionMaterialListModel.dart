class ProductionMaterialListModel{
  int? materialId;
  String? materialName;


  ProductionMaterialListModel({this.materialName,this.materialId});

  factory ProductionMaterialListModel.fromJson(Map<String, dynamic> json) => ProductionMaterialListModel(
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],

  );

  Map<String, dynamic> toJson() => {
    "MaterialId":   materialId,
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