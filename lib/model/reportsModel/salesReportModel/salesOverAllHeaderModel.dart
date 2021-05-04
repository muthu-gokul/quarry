class SaleReportTotalValuesModel {
  SaleReportTotalValuesModel({
    this.plantId,
    this.totalSale,
    this.totalQuantity,
    this.totalAmount,
  });

  int plantId;
  int totalSale;
  double totalQuantity;
  double totalAmount;

  factory SaleReportTotalValuesModel.fromJson(Map<String, dynamic> json) => SaleReportTotalValuesModel(
    plantId: json["PlantId"],
    totalSale: json["TotalSale"],
    totalQuantity: json["TotalQuantity"].toDouble(),
    totalAmount: json["TotalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "PlantId": plantId,
    "TotalSale": totalSale,
    "TotalQuantity": totalQuantity,
    "TotalAmount": totalAmount,
  };
}
