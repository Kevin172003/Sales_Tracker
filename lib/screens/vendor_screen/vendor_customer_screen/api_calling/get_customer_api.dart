class GetCustomerApi {
  int? id;
  bool? deleted;
  String? name;
  String? address;
  String? mobileNumber;

  GetCustomerApi(
      {this.id, this.deleted, this.name, this.address, this.mobileNumber});

  GetCustomerApi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deleted = json['deleted'];
    name = json['first_name'];
    address = json['address'];
    mobileNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deleted'] = deleted;
    data['name'] = name;
    data['address'] = address;
    data['mobile_number'] = mobileNumber;
    return data;
  }
}
