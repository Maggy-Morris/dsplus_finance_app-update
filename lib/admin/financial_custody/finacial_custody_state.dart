abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsError extends OrderDetailsState {
  final String errorMessage;

  OrderDetailsError(this.errorMessage);
}
