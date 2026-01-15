import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/app/models/positions_model.dart';

class AddAddressModel {
  bool? isDefault;
  String? address;
  String? name;
  String? addressAs;
  String? id;
  String? locality;
  String? landmark;
  LocationLatLng? location;
  Positions? position;

  AddAddressModel({this.isDefault, this.address, this.addressAs, this.id, this.locality, this.location, this.position, this.name, this.landmark});

  String getFullAddress() {
    final List<String> parts = [];

    if (address != null && address!.isNotEmpty) {
      parts.add(address!);
    }
    if (locality != null && locality!.isNotEmpty) {
      parts.add(locality!);
    }
    if (landmark != null && landmark!.isNotEmpty) {
      parts.add(landmark!);
    }

    return parts.join(', ');
  }

  @override
  String toString() {
    return 'AddAddressModel{isDefault: $isDefault, address: $address, name: $name, addressAs: $addressAs, id: $id, locality: $locality, landmark: $landmark, location: $location, position: $position}';
  }

  AddAddressModel.fromJson(Map<String, dynamic> json) {
    isDefault = json['isDefault'];
    address = json['address'] ?? "";
    name = json['name'] ?? "";
    addressAs = json['addressAs'];
    id = json['id'];
    locality = json['locality'] ?? "";
    landmark = json['landmark'] ?? "";
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : null;
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDefault'] = isDefault;
    data['address'] = address;
    data['name'] = name;
    data['addressAs'] = addressAs;
    data['id'] = id;
    data['locality'] = locality;
    data['landmark'] = landmark;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    return data;
  }
}
