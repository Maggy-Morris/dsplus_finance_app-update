part of 'details_bloc.dart';

class DetailsState extends Equatable {
   DetailsState({this.detailsModelObj});

  DetailsModel? detailsModelObj;

  @override
  List<Object?> get props => [
    detailsModelObj,
  ];

  DetailsState copyWith({DetailsModel? detailsModelObj}) {
    return DetailsState(
      detailsModelObj: detailsModelObj ?? this.detailsModelObj,
    );
  }
}

final class DetailsInitial extends DetailsState {}
