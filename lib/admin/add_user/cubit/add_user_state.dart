part of 'add_user_cubit.dart';

enum AddUserStatus { initial, loading, success, error ,editing}

class AddUserState extends Equatable {
  final Uint8List? images;
  final AddUserStatus? status;

  AddUserState({this.images, this.status = AddUserStatus.initial});

  AddUserState copyWith({ Uint8List? images, AddUserStatus? status}) {
    return AddUserState(
      images: images ?? this.images,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    images,
    status,
  ];
}
