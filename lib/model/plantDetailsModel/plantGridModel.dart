class PlantGridModel{
  PlantGridModel({
    this.plantId,
    this.plantName,
    this.location,
    this.plantContactPersonName,
    this.plantContactNumber,
    this.plantEmail,
  });

  int? plantId;
  String? plantName;
  String? location;
  String? plantContactPersonName;
  String? plantContactNumber;
  String? plantEmail;



  factory PlantGridModel.fromJson(Map<String, dynamic> json) => PlantGridModel(
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    location: json["Location"],
    plantContactPersonName: json["PlantContactPersonName"],
    plantContactNumber: json["PlantContactNumber"],
    plantEmail: json["PlantEmail"],
  );
}