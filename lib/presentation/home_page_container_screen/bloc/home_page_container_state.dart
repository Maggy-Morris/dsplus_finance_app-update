// ignore_for_file: must_be_immutable

part of 'home_page_container_bloc.dart';

class HomePageContainerState extends Equatable {
  HomePageContainerState({this.homePageContainerModelObj});

  HomePageContainerModel? homePageContainerModelObj;

  @override
  List<Object?> get props => [
        homePageContainerModelObj,
      ];
  HomePageContainerState copyWith(
      {HomePageContainerModel? homePageContainerModelObj}) {
    return HomePageContainerState(
      homePageContainerModelObj:
          homePageContainerModelObj ?? this.homePageContainerModelObj,
    );
  }
}
