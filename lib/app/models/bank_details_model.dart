

class BankDetailsModel {
  String? id;
  String? driverId;
  String? holderName;
  String? accountNumber;
  String? swiftCode;
  String? ifscCode;
  String? bankName;
  String? branchCity;
  String? branchCountry;

  BankDetailsModel({
    this.id,
    this.driverId,
    this.holderName,
    this.accountNumber,
    this.swiftCode,
    this.ifscCode,
    this.bankName,
    this.branchCity,
    this.branchCountry,
  });


  @override
  String toString() {
    return 'BankDetailsModel{id: $id, driverId: $driverId, holderName: $holderName, accountNumber: $accountNumber, swiftCode: $swiftCode, ifscCode: $ifscCode, bankName: $bankName, branchCity: $branchCity, branchCountry: $branchCountry}';
  }

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    holderName = json['holderName'];
    accountNumber = json['accountNumber'];
    swiftCode = json['swiftCode'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
    branchCity = json['branchCity'];
    branchCountry = json['branchCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverId'] = driverId;
    data['holderName'] = holderName;
    data['accountNumber'] = accountNumber;
    data['swiftCode'] = swiftCode;
    data['ifscCode'] = ifscCode;
    data['bankName'] = bankName;
    data['branchCity'] = branchCity;
    data['branchCountry'] = branchCountry;
    return data;
  }
}
