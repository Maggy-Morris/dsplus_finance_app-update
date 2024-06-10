
// ignore_for_file: must_be_immutable


part of 'home_page_container_bloc.dart';

@immutable
abstract class HomePageContainerEvent extends Equatable {}

class HomePageContainerInitialEvent extends HomePageContainerEvent {
  @override
  List<Object?> get props => [];
}
