import 'package:intl/intl.dart';

int phoneNoLength=10;
int zipcodeLength=6;
String decimalReg=r'^\d+\.?\d{0,2}';
var formatCurrency = NumberFormat.currency(locale: 'HI',name: "");
RegExp regEx = RegExp('[0-9.]');

String addressReg='[A-Za-z0-9,-_@ ]';