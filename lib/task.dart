import 'package:flutter_application_1/reorder.dart';

class Task implements IReorderableItem {
  final String id;
  final String title;
  final Map<String, dynamic>? customReordering;

  Task({required this.id, required this.title, this.customReordering});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      customReordering: json['customReordering'] ?? null,
    );
  }
  
  @override
  set customReordering(Map<String, dynamic>? _customReordering) {
    // TODO: implement customReordering
  }
  
  @override
  set id(String? _id) {
    // TODO: implement id
  }
}