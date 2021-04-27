class GoodsReceivedGridModel {
  GoodsReceivedGridModel({
    this.goodsReceivedId,
    this.grnNumber,
    this.purchaseOrderId,
    this.purchaseOrderNumber,
    this.date,
    this.plantId,
    this.plantName,
    this.status,
  });

  int goodsReceivedId;
  int grnNumber;
  int purchaseOrderId;
  String purchaseOrderNumber;
  String date;
  int plantId;
  String plantName;
  String status;

  factory GoodsReceivedGridModel.fromJson(Map<String, dynamic> json) => GoodsReceivedGridModel(
    goodsReceivedId: json["GoodsReceivedId"],
    grnNumber: json["GRNNumber"],
    purchaseOrderId: json["PurchaseOrderId"],
    purchaseOrderNumber: json["PurchaseOrderNumber"],
    date: json["Date"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "GoodsReceivedId": goodsReceivedId,
    "GRNNumber": grnNumber,
    "PurchaseOrderId": purchaseOrderId,
    "PurchaseOrderNumber": purchaseOrderNumber,
    "Date": date,
    "PlantId": plantId,
    "PlantName": plantName,
    "Status": status,
  };
}
