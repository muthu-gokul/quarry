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
Color headerBg=Color(0xFF1990e6);
Color headerText=Color(0xFFffffff);
Color actionText=Color(0xFF979797);
Color selectedDay=Color(0xFF1990e6);
Color? dayColor=Colors.grey[700];


Color invPaidText=Color(0xFF78AD97);
Color invUnPaidText=Color(0xFFC27573);
Color invPartiallyPaidText=Color(0xFFF1AC42);

Color theme=Color(0xff1990e6);