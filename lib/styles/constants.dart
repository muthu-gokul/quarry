import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quarry/model/parameterMode.dart';

int phoneNoLength=10;
int zipcodeLength=6;
String decimalReg=r'^\d+\.?\d{0,2}';
var formatCurrency = NumberFormat.currency(locale: 'HI',name: "");
RegExp regEx = RegExp('[0-9.]');

String addressReg='[A-Za-z0-9,-_@ ]';

List<ParameterModel> parameters=[];

//Multi Date Selector Color
Color headerBg=Color(0xFFFFC010);
Color headerText=Color(0xFF3B3B3D);
Color actionText=Color(0xFF979797);
Color selectedDay=Color(0xFFFFC010);
Color? dayColor=Colors.grey[700];