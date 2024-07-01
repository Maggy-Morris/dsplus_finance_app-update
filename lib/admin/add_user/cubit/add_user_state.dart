part of 'add_user_cubit.dart';

enum AddUserStatus { initial, loading, success, error ,editing}

class AddUserState extends Equatable {
  final Uint8List? images;
  final AddUserStatus? status;

  final String? error;

  AddUserState({this.images, this.status = AddUserStatus.initial, this.error});

  AddUserState copyWith({ Uint8List? images, AddUserStatus? status , String? error}) {
    return AddUserState(
      images: images ?? this.images,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    images,
    status,
    error,
  ];
}
