class StorageUploadResponseModel {
  final String url;

  StorageUploadResponseModel({required this.url});

  factory StorageUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return StorageUploadResponseModel(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
