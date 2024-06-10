import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/details_model.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc(DetailsState detailsState) : super(DetailsInitial()) {
    on<DetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
