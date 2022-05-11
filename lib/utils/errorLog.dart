import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/alertDialog.dart';

errorLog(var error,var stackTrace, var title){
  CustomAlert().commonErrorAlert(Get.context!, title, "Contact Administration");
  FirebaseCrashlytics.instance.recordError(error, stackTrace);
}