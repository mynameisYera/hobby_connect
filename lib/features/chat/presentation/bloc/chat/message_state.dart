part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class LoadingMessageState extends MessageState {}

final class FailureMessageState extends MessageState {
  final String error;

  const FailureMessageState({required this.error});

  @override
  List<Object> get props => [error];
}

final class SuccessMessageState extends MessageState {
  final List<MessageEntity> items;

  const SuccessMessageState({required this.items});

  @override
  List<Object> get props => [items];
}
