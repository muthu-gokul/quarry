
class InvoiceGridModel {
  InvoiceGridModel({
    this.invoiceId,
    this.invoiceNumber,
    this.invoiceType,
    this.invoiceDate,
    this.partyId,
    this.partyName,
    this.grandTotalAmount,
    this.status,
    this.plantId,
    this.plantName
  });

  int invoiceId;
  int plantId;
  String plantName;
  String invoiceNumber;
  String invoiceType;
  DateTime invoiceDate;
  int partyId;
  String partyName;
  String status;
  double grandTotalAmount;

  factory InvoiceGridModel.fromJson(Map<String, dynamic> json) => InvoiceGridModel(
    invoiceId: json["InvoiceId"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    invoiceNumber: json["InvoiceNumber"],
    invoiceType: json["InvoiceType"],
    invoiceDate:json["InvoiceDate"]!=null? DateTime.parse(json["InvoiceDate"]):null,
    partyId: json["PartyId"],
    partyName: json["PartyName"],
    grandTotalAmount: json["GrandTotalAmount"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "InvoiceId": invoiceId,
    "InvoiceNumber": invoiceNumber,
    "InvoiceType": invoiceType,
    "InvoiceDate": invoiceDate.toIso8601String(),
    "PartyId": partyId,
    "PartyName": partyName,
    "GrandTotalAmount": grandTotalAmount,
  };
}
