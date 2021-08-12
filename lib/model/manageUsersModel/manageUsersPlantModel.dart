import 'package:flutter/animation.dart';

class ManageUserPlantModel {
  ManageUserPlantModel({
    this.plantId,
    this.plantName,
    this.UserPlantMappingId,
    this.UserId,
    this.scaleController,
    this.isActive
  });

  int? plantId;
  String? plantName;
  int? UserPlantMappingId;
  int? UserId;
  bool? isActive;

  AnimationController? scaleController;

  factory ManageUserPlantModel.fromJson(Map<String, dynamic> json) => ManageUserPlantModel(
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    UserId: json["UserId"],
    isActive: true
  );

  Map<String, dynamic> toJson() => {
    "UserPlantMappingId": UserPlantMappingId,
    "UserId": UserId,
    "PlantId": plantId,
  };
}