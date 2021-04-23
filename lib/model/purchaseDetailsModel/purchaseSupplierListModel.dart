
class PurchaseSupplierList {
  PurchaseSupplierList({
    this.supplierId,
    this.supplierName,
    this.supplierType,
  });

  int supplierId;
  String supplierName;
  String supplierType;

  factory PurchaseSupplierList.fromJson(Map<String, dynamic> json) => PurchaseSupplierList(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
    supplierType: json["SupplierType"],
  );

  Map<String, dynamic> toJson() => {
    "SupplierId": supplierId,
    "SupplierName": supplierName,
    "SupplierType": supplierType,
  };
}