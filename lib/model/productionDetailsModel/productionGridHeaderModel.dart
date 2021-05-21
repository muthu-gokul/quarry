class ProductionGridHeaderModel {
  ProductionGridHeaderModel({
    this.materialId,
    this.materialName,
    this.unitName,
    this.totalQuantity,
    this.materialType,
  });

  int materialId;
  int materialType;
  String materialName;
  String unitName;
  double totalQuantity;

  factory ProductionGridHeaderModel.fromJson(Map<String, dynamic> json) => ProductionGridHeaderModel(
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    unitName: json["UnitName"],
    totalQuantity: json["TotalQuantity"],
    materialType: json["MaterialType"],
  );

  Map<String, dynamic> toJson() => {
    "MaterialId": materialId,
    "MaterialName": materialName,
    "UnitName": unitName,
    "TotalQuantity": totalQuantity,
  };
}
