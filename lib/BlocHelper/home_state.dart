part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class LoadingState extends HomeState {}
final class ErrorState extends HomeState {
    final String ?error;
  ErrorState (this.error);
}
final class SuccessState extends HomeState {}
