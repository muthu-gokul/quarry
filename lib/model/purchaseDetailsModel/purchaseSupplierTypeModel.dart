class PurchaseSupplierType {
  PurchaseSupplierType({
    this.supplierType,
  });

  String supplierType;

  factory PurchaseSupplierType.fromJson(Map<String, dynamic> json) => PurchaseSupplierType(
    supplierType: json["SupplierType"],
  );

  Map<String, dynamic> toJson() => {
    "SupplierType": supplierType,
  };
}