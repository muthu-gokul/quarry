class InvoiceTypeModel {
  InvoiceTypeModel({
    this.invoiceType,
  });

  String invoiceType;

  factory InvoiceTypeModel.fromJson(Map<String, dynamic> json) => InvoiceTypeModel(
    invoiceType: json["InvoiceType"],
  );

  Map<String, dynamic> toJson() => {
    "InvoiceType": invoiceType,
  };
}