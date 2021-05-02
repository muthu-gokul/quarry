
class InvoiceGridModel {
  InvoiceGridModel({
    this.invoiceId,
    this.invoiceNumber,
    this.invoiceType,
    this.invoiceDate,
    this.partyId,
    this.partyName,
    this.grandTotalAmount,
  });

  int invoiceId;
  String invoiceNumber;
  String invoiceType;
  DateTime invoiceDate;
  int partyId;
  String partyName;
  double grandTotalAmount;

  factory InvoiceGridModel.fromJson(Map<String, dynamic> json) => InvoiceGridModel(
    invoiceId: json["InvoiceId"],
    invoiceNumber: json["InvoiceNumber"],
    invoiceType: json["InvoiceType"],
    invoiceDate: DateTime.parse(json["InvoiceDate"]),
    partyId: json["PartyId"],
    partyName: json["PartyName"],
    grandTotalAmount: json["GrandTotalAmount"],
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
