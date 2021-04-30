class FuelSupplierModel {
  FuelSupplierModel({
    this.supplierId,
    this.supplierName,
  });

  int supplierId;
  String supplierName;

  factory FuelSupplierModel.fromJson(Map<String, dynamic> json) => FuelSupplierModel(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
  );

  Map<String, dynamic> toJson() => {
    "SupplierId": supplierId,
    "SupplierName": supplierName,
  };
}