import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quarry/model/parameterMode.dart';
import 'package:quarry/model/userAccessModel.dart';

import 'app_theme.dart';

int phoneNoLength=10;
int zipcodeLength=6;
int gstLength=15;
String decimalReg=r'^\d+\.?\d{0,2}';
var formatCurrency = NumberFormat.currency(locale: 'HI',name: "");
RegExp regEx = RegExp('[0-9.]');
RegExp numberRegEx = RegExp('[0-9]');

String addressReg='[A-Za-z0-9,-_@ ]';

List<ParameterModel> parameters=[];
List<UserAccessModel> userAccessList=[];
Map userAccessMap={
  "1":true
};

int? userGroupId;
String? userGroupName;

//Multi Date Selector Color
Color headerBg=Color(0xFFFFC010);
Color headerText=Color(0xFF3B3B3D);
Color actionText=Color(0xFF979797);
Color selectedDay=Color(0xFFFFC010);
Color? dayColor=Colors.grey[700];
Color invPaidText=Color(0xFF78AD97);
Color invUnPaidText=Color(0xFFC27573);
Color invPartiallyPaidText=Color(0xFFF1AC42);

Duration animeDuration = Duration(milliseconds: 300);

TableBorder tableBorder=TableBorder.all(
    color: AppTheme.addNewTextFieldBorder,
    style: BorderStyle.solid,
    width: 1,
    borderRadius: BorderRadius.circular(3)
);

String appVersion="v - 1.0.21";