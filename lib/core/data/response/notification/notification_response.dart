class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}