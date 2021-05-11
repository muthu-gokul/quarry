class PartyName {
  PartyName({
    this.partyName,
    this.partyId,
    this.isActive,
  });

  String partyName;
  int partyId;
  bool isActive;
  factory PartyName.fromJson(Map<String, dynamic> json) => PartyName(
    partyName: json["PartyName"],
    partyId: json["PartyId"],
    isActive: true,
  );

  Map<String, dynamic> toGridJson() => {
    "PartyName": partyName,
    "PartyId": partyId,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}