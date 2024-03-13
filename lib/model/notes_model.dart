class Notes {
  late String title;
  late String description;
  late String datetime;
  Notes({
    required this.title,
    required this.description,
    required this.datetime,
  });

  Notes.fromJson({required Map<String, dynamic> json}) {
    title = json['title'];
    description = json['description'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'datetime': datetime,
      };
}
