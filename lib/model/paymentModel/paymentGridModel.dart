class PaymentGridModel {
  PaymentGridModel({
    this.invoiceId,
    this.invoiceNumber,
    this.invoicePaymentNumber,
    this.invoiceType,
    this.invoiceDate,
    this.partyId,
    this.partyName,
    this.grandTotalAmount,
    this.paidAmount,
    this.status,
    this.balanceAmount,
    this.DBInvoiceNumber,
  });

  int invoiceId;
  int DBInvoiceNumber;
  String invoiceNumber;
  String invoicePaymentNumber;
  String invoiceType;
  DateTime invoiceDate;
  int partyId;
  String partyName;
  String status;
  double grandTotalAmount;
  double paidAmount;
  double balanceAmount;

  factory PaymentGridModel.fromJson(Map<String, dynamic> json) => PaymentGridModel(
    invoiceId: json["InvoiceId"],
    DBInvoiceNumber: json["DBInvoiceNumber"],
    invoiceNumber: json["InvoiceNumber"],
    invoicePaymentNumber: json["InvoicePaymentNumber"],
    invoiceType: json["InvoiceType"],
    invoiceDate: DateTime.parse(json["InvoiceDate"]),
    partyId: json["PartyId"],
    partyName: json["PartyName"],
    grandTotalAmount: json["GrandTotalAmount"],
    paidAmount: json["PaidAmount"],
    balanceAmount: json["BalanceAmount"],
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
    "PaidAmount": paidAmount,
  };
}
