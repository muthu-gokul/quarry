class PurchaseMaterialsListModel {
  PurchaseMaterialsListModel({
    this.supplierId,
    this.supplierName,
    this.materialId,
    this.materialName,
    this.materialUnitId,
    this.unitName,
    this.materialPrice,
    this.taxValue,
    this.SupplierType,
  });

  int? supplierId;
  String? supplierName;
  int? materialId;
  String? materialName;
  int? materialUnitId;
  String? unitName;
  String? SupplierType;
  double? materialPrice;
  double? taxValue;

  factory PurchaseMaterialsListModel.fromJson(Map<String, dynamic> json) => PurchaseMaterialsListModel(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    materialUnitId: json["MaterialUnitId"],
    unitName: json["UnitName"],
    materialPrice: json["MaterialPrice"],
    taxValue: json["TaxValue"],
    SupplierType: json["SupplierType"],
  );


  Map<String, dynamic> toJson() => {
    "SupplierId": supplierId,
    "SupplierName": supplierName,
    "MaterialId": materialId,
    "MaterialName": materialName,
    "MaterialUnitId": materialUnitId,
    "UnitName": unitName,
    "MaterialPrice": materialPrice,
    "TaxValue": taxValue,
  };


}