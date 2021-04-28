class ProductionInputTypeListModel{
  int materialId;
  String materialName;
  int MaterialUnitId;
  String UnitName;
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
}