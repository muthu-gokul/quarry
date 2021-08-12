class PurchaseOrderOtherChargesMappingList{

 int?  PurchaseOrderOtherChargesMappingId;
 int? PurchaseOrderId;
String?  OtherChargesName;
 double? OtherChargesAmount;
 int? IsActive;

 PurchaseOrderOtherChargesMappingList({
      this.PurchaseOrderOtherChargesMappingId,
      this.PurchaseOrderId,
      this.OtherChargesName,
      this.OtherChargesAmount,
     this.IsActive
 });


 factory PurchaseOrderOtherChargesMappingList.fromJson(Map<String, dynamic> json) => PurchaseOrderOtherChargesMappingList(
   PurchaseOrderId: json["PurchaseOrderId"],
   OtherChargesName: json["OtherChargesName"],
   OtherChargesAmount: json["OtherChargesAmount"],
 );


 Map<String, dynamic> toJson() => {
   "PurchaseOrderOtherChargesMappingId":PurchaseOrderOtherChargesMappingId,
   "PurchaseOrderId":PurchaseOrderId,
   "OtherChargesName":OtherChargesName,
   "OtherChargesAmount":OtherChargesAmount,
   "IsActive":IsActive??1,
 };

}