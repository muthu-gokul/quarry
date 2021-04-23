class PurchaseMaterialsListModel {
  PurchaseMaterialsListModel({
    this.materialId,
    this.materialName,
    this.materialUnitId,
    this.unitName,
  });

  int materialId;
  String materialName;
  int materialUnitId;
  String unitName;

  factory PurchaseMaterialsListModel.fromJson(Map<String, dynamic> json) => PurchaseMaterialsListModel(
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    materialUnitId: json["MaterialUnitId"],
    unitName: json["UnitName"],
  );

  Map<String, dynamic> toJson() => {
    "MaterialId": materialId,
    "MaterialName": materialName,
    "MaterialUnitId": materialUnitId,
    "UnitName": unitName,
  };
}