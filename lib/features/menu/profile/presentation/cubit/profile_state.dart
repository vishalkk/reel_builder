part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileImagePicking extends ProfileState {}

class ProfileImagePicked extends ProfileState {
  final String imagePath;

  ProfileImagePicked({
    required this.imagePath,
  });
}

class ProfileImageError extends ProfileState {
  final String message;

  ProfileImageError(this.message);
}

class PermissionDenied extends ProfileState {}
