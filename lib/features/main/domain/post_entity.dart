import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String img;
  final String name;
  final String title;

  const PostEntity({
    required this.img,
    required this.title,
    required this.name,
  });

  factory PostEntity.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostEntity(
      img: data['image'] ??
          'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty-300x240.jpg',
      title: data['title'] ?? '',
      name: data['username'] ?? '',
    );
  }

  static List<PostEntity> fromDocumentList(List<DocumentSnapshot> items) {
    return items.map((DocumentSnapshot doc) {
      return PostEntity.fromDocument(doc);
    }).toList();
  }

  @override
  List<Object?> get props => [img, title, name];
}
