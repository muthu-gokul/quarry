class InvoiceMaterialModel {
  InvoiceMaterialModel({
    this.supplierId,
    this.supplierName,
    this.materialId,
    this.materialName,
    this.materialUnitId,
    this.unitName,
    this.taxValue,
    this.materialPrice,
    this.taxValue1,
    this.supplierType,
  });

  int supplierId;
  String supplierName;
  int materialId;
  String materialName;
  int materialUnitId;
  String unitName;
  double taxValue;
  double materialPrice;
  double taxValue1;
  String supplierType;

  factory InvoiceMaterialModel.fromJson(Map<String, dynamic> json) => InvoiceMaterialModel(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    materialUnitId: json["MaterialUnitId"],
    unitName: json["UnitName"],
    taxValue: json["TaxValue"],
    materialPrice: json["MaterialPrice"],
    taxValue1: json["TaxValue1"],
    supplierType: json["SupplierType"],
  );

  Map<String, dynamic> toJson() => {
    "SupplierId": supplierId,
    "SupplierName": supplierName,
    "MaterialId": materialId,
    "MaterialName": materialName,
    "MaterialUnitId": materialUnitId,
    "UnitName": unitName,
    "TaxValue": taxValue,
    "MaterialPrice": materialPrice,
    "TaxValue1": taxValue1,
    "SupplierType": supplierType,
  };
}
