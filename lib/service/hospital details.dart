class HospitalDetails {
  String name;
  String contact;
  String imageId;

  static List<HospitalDetails> nearbyHospitals = [];
  HospitalDetails(
      {required this.name, required this.contact, required this.imageId});

  factory HospitalDetails.fromMap(Map<String, dynamic> map) {
    return HospitalDetails(
        name: map['name'], contact: map['phone_no'], imageId: map['hop_image']);
  }
}
