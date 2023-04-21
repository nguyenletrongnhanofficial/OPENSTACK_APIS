class ListFlavor {
  final String name;

  ListFlavor({
    required this.name,
  });

  static ListFlavor toListFlavor(Map<String, dynamic> data) {
    return ListFlavor(
      name: data["name"] ?? "",
    );
  }
}
