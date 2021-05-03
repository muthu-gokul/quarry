class PaymentSupplierModel {
  PaymentSupplierModel({
    this.supplierId,
    this.supplierName,
    this.supplierType,
  });

  int supplierId;
  String supplierName;
  String supplierType;

  factory PaymentSupplierModel.fromJson(Map<String, dynamic> json) => PaymentSupplierModel(
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