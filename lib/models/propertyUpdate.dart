//a model of a property to be updated
class PropertyUpdate {
  int bedroom;
  int sittingRoom;
  int kitchen;
  int bathroom;
  int toilet;
  String description;
  String validTo;

  PropertyUpdate({
    required this.bedroom,
    required this.sittingRoom,
    required this.kitchen,
    required this.bathroom,
    required this.toilet,
    required this.description,
    required this.validTo,
  });
}
