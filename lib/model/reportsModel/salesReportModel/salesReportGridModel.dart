class SaleReportGridModel {
  SaleReportGridModel({
    this.saleId,
    this.plantId,
    this.plantName,
    this.createdDate,
    this.saleNumber,
    this.vehicleNumber,
    this.materialId,
    this.materialName,
    this.outputMaterialQty,
    this.outputQtyAmount,
    this.paymentCategoryId,
    this.paymentCategoryName,
    this.customerId,
    this.customerName,
    this.unitName
  });

  int saleId;
  int plantId;
  String plantName;
  DateTime createdDate;
  int saleNumber;
  String vehicleNumber;
  int materialId;
  String materialName;
  double outputMaterialQty;
  double outputQtyAmount;
  int paymentCategoryId;
  String paymentCategoryName;
  int customerId;
  String customerName;
  String unitName;

  factory SaleReportGridModel.fromJson(Map<String, dynamic> json) => SaleReportGridModel(
    saleId: json["SaleId"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    saleNumber: json["SaleNumber"],
    vehicleNumber: json["VehicleNumber"],
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],
    outputMaterialQty:json["OutputMaterialQty"]==null?0.0: json["OutputMaterialQty"].toDouble(),
    outputQtyAmount: json["OutputQtyAmount"],
    paymentCategoryId: json["PaymentCategoryId"],
    paymentCategoryName: json["PaymentCategoryName"],
    customerId: json["CustomerId"],
    customerName: json["CustomerName"],
    unitName: json["UnitName"],
  );

  Map<String, dynamic> toJson() => {
    "SaleId": saleId,
    "PlantId": plantId,
    "PlantName": plantName,
    "CreatedDate": createdDate.toIso8601String(),
    "SaleNumber": saleNumber,
    "VehicleNumber": vehicleNumber,
    "MaterialId": materialId,
    "MaterialName": materialName,
    "OutputMaterialQty": outputMaterialQty,
    "OutputQtyAmount": outputQtyAmount,
    "PaymentCategoryId": paymentCategoryId,
    "PaymentCategoryName": paymentCategoryName,
    "CustomerId": customerId,
    "CustomerName": customerName,
  };
}
