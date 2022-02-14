class Property {
  String id;
  String address;
  String type;
  int bedroom;
  int sittingRoom;
  int kitchen;
  int bathroom;
  int toilet;
  String propertyOwner;
  String description;
  String validFrom;
  String validTo;
  List images;

  Property({
    required this.id,
    required this.address,
    required this.type,
    required this.bedroom,
    required this.sittingRoom,
    required this.kitchen,
    required this.bathroom,
    required this.toilet,
    required this.propertyOwner,
    required this.description,
    required this.validFrom,
    required this.validTo,
    required this.images,
  });
}
