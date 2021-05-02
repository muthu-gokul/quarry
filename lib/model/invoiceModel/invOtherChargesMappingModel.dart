class InvoiceOtherChargesMappingList{

  int  InvoiceOtherChargesMappingId;
  int InvoiceId;
  String  OtherChargesName;
  double OtherChargesAmount;
  int IsActive;

  InvoiceOtherChargesMappingList({
    this.InvoiceOtherChargesMappingId,
    this.InvoiceId,
    this.OtherChargesName,
    this.OtherChargesAmount,
    this.IsActive
  });


  factory InvoiceOtherChargesMappingList.fromJson(Map<String, dynamic> json) => InvoiceOtherChargesMappingList(
    InvoiceId: json["InvoiceId"],
    InvoiceOtherChargesMappingId: json["InvoiceOtherChargesMappingId"],
    OtherChargesName: json["OtherChargesName"],
    OtherChargesAmount: json["OtherChargesAmount"],
    IsActive: json["IsActive"],
  );


  Map<String, dynamic> toJson() => {
    "InvoiceOtherChargesMappingId":InvoiceOtherChargesMappingId,
    "InvoiceId":InvoiceId,
    "OtherChargesName":OtherChargesName,
    "OtherChargesAmount":OtherChargesAmount,
    "IsActive":IsActive??1,
  };

}