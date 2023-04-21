class ListSecurityGroup {
  final String name;

  ListSecurityGroup({
    required this.name,
  });

  static ListSecurityGroup toListSecurityGroup(Map<String, dynamic> data) {
    return ListSecurityGroup(
      name: data["name"] ?? "",
    );
  }
}
