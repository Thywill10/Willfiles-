class FileModel {
  final String name;
  final String path;
  final String type;
  final String size;
  final bool isFavorite;
  final bool isLocked;

  const FileModel({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    this.isFavorite = false,
    this.isLocked = false,
  });

  FileModel copyWith({
    String? name,
    String? path,
    String? type,
    String? size,
    bool? isFavorite,
    bool? isLocked,
  }) {
    return FileModel(
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      size: size ?? this.size,
      isFavorite: isFavorite ?? this.isFavorite,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}