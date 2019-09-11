class ReleaseModel {
  ReleaseModel.fromJson(Map<String, dynamic> json)
      : assert(json['release_date'] != null && json['release_date'] is String) {
    _releaseDate = DateTime.parse(json['release_date']);
  }

  DateTime _releaseDate;

  DateTime get releaseDate => _releaseDate;
}
