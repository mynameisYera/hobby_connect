part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostEvent extends PostEvent {
  final String category;

  const LoadPostEvent(this.category);

  @override
  List<Object?> get props => [category];
}
