
class SupplierMaterialModel {
  SupplierMaterialModel({
    this.materialId,
    this.materialName,
    this.MaterialUnitId,
    this.UnitName,
  });

  int materialId;
  String materialName;
  int MaterialUnitId;
  String UnitName;

  factory SupplierMaterialModel.fromJson(Map<String, dynamic> json) => SupplierMaterialModel(
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
