class ListImage {
  final String name;
  final String id;

  ListImage({
    required this.name,
    required this.id,
  });

  static ListImage toListImage(Map<String, dynamic> data) {
    return ListImage(
      name: data["name"] ?? "",
      id: data["id"] ?? "",
    );
  }
}
