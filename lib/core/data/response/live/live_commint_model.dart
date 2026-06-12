class LiveCommentModel {
  final String userName;
  final String message;
  final DateTime createdAt;

  const LiveCommentModel({
    required this.userName,
    required this.message,
    required this.createdAt,
  });

  factory LiveCommentModel.fromJson(Map<String, dynamic> json) {
    return LiveCommentModel(
      userName: (json['userName'] ?? json['name'] ?? 'مستخدم').toString(),
      message: (json['message'] ?? '').toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory LiveCommentModel.fromSignalR(dynamic data) {
    if (data is Map<String, dynamic>) {
      return LiveCommentModel.fromJson(data);
    }

    return LiveCommentModel(
      userName: 'مستخدم',
      message: data.toString(),
      createdAt: DateTime.now(),
    );
  }
}