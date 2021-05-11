class LocationModel {
  LocationModel({
    this.location,
    this.isActive,
  });

  String location;
  bool isActive;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    location: json["Location"],
    isActive: true,
  );

  Map<String, dynamic> toGridJson() => {
    "Location": location,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
