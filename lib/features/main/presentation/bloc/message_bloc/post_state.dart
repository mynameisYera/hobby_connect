part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class LoadingPostState extends PostState {}

final class FailurePostState extends PostState {
  final String error;

  const FailurePostState({required this.error});

  @override
  List<Object> get props => [error];
}

final class SuccessPostState extends PostState {
  final List<PostEntity> items;

  const SuccessPostState({required this.items});

  @override
  List<Object> get props => [items];
}
