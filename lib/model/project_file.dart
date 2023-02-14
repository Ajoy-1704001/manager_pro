import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectFile {
  final String? id;
  final String url;
  final String name;
  final String uploadedBy;
  final Timestamp uploadedAt;

  ProjectFile(
      {this.id,
      required this.url,
      required this.name,
      required this.uploadedBy,
      required this.uploadedAt});

  ProjectFile.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        url = doc.data()!["url"],
        name = doc.data()!["name"],
        uploadedBy = doc.data()!["uploadedBy"],
        uploadedAt = doc.data()!["uploadedAt"];

  Map<String, dynamic> toDocumentMap() {
    return {
      "url": url,
      "name": name,
      "uploadedBy": uploadedBy,
      "uploadedAt": uploadedAt,
    };
  }
}
