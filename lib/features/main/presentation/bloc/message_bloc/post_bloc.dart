import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hobby/features/main/domain/post_entity.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(LoadingPostState()) {
    on<LoadPostEvent>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(
      LoadPostEvent event, Emitter<PostState> emit) async {
    emit(LoadingPostState());
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('hobbies')
          .doc(event.category)
          .get();

      if (document.exists) {
        List<dynamic> postList = document['post'];
        List<PostEntity> items = postList.map((post) {
          return PostEntity(
            name: post['username'],
            title: post['title'],
            img: post['image'],
          );
        }).toList();

        emit(SuccessPostState(items: items));
      } else {
        emit(FailurePostState(error: 'No data '));
      }
    } catch (e) {
      emit(FailurePostState(error: e.toString()));
    }
  }
}
