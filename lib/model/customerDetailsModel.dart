class CustomerDetails{
  int? CustomerId;
  String? CustomerName;
  String? CustomerCode;
  String? CustomerContactNumber;
  String? CustomerEmail;
  String? CustomerAddress;
  String? CustomerCity;
  String? CustomerState;
  String? CustomerCountry;
  String? CustomerZipCode;
  String? CustomerGSTNumber;
  String? CustomerLogoFileName;
  String? CustomerLogoFolderName;
  double? CustomerCreditLimit;

  String? Location;

  CustomerDetails({this.CustomerId,this.CustomerName,this.CustomerCode,this.CustomerContactNumber,this.CustomerEmail,
  this.CustomerAddress,this.CustomerCity,this.CustomerState,this.CustomerCountry,this.CustomerZipCode,this.CustomerGSTNumber,
  this.CustomerLogoFileName,this.CustomerLogoFolderName,this.CustomerCreditLimit,this.Location});

  factory CustomerDetails.fromJson(Map<dynamic, dynamic> json){
    return new CustomerDetails(
      CustomerId: json['CustomerId'],
      CustomerName: json['CustomerName'],
      CustomerCode: json['CustomerCode'],
      CustomerContactNumber: json['CustomerContactNumber'],
      CustomerEmail: json['CustomerEmail'],
      CustomerAddress: json['CustomerAddress'],
      CustomerCity: json['CustomerCity'],
      CustomerState: json['CustomerState'],
      CustomerCountry: json['CustomerCountry'],
      CustomerZipCode: json['CustomerZipCode'],
      CustomerGSTNumber: json['CustomerGSTNumber'],
      CustomerLogoFileName : json['CustomerLogoFileName'],
      CustomerLogoFolderName : json['CustomerLogoFolderName'],
      CustomerCreditLimit : double.parse(json['CustomerCreditLimit'].toString()),
      Location : json['Location'],
    );
  }
  Map<String, dynamic> toJson() => {
    "CustomerId": CustomerId,
    "CustomerName": CustomerName,
    "Location": Location,
    "CustomerContactNumber": CustomerContactNumber,
    "CustomerEmail": CustomerEmail,
    "CustomerCreditLimit": CustomerCreditLimit,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}