import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mis_mobile/core/utils/app_images.dart';
import 'package:mis_mobile/core/utils/dialogs.dart';
import 'package:mis_mobile/core/utils/pick_image_util.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  String? _currentImagePath;
  String? get currentImagePath => _currentImagePath;

  get profileImage => _getProfileImage(state);

  ImageProvider _getProfileImage(
    ProfileState state,
  ) {
    if (_currentImagePath != null) {
      return FileImage(File(_currentImagePath!));
    }

    if (state is ProfileImagePicked) {
      return FileImage(File(state.imagePath));
    }

    return const AssetImage(AppImages.profilePicImageString);
  }

  Future<void> pickImageWithDialog(BuildContext context) async {
    try {
      emit(ProfileImagePicking());

      final source = await Dialogs.pickImageWithDialog(context);
      if (source == null) {
        emit(ProfileInitial());
        return;
      }

      String? imagePath;

      if (source == ImageSourceType.gallery) {
        imagePath = await ImagePickerUtil.pickFromGallery();
      } else if (source == ImageSourceType.camera) {
        imagePath = await ImagePickerUtil.pickFromCamera();
      }

      if (imagePath != null) {
        if (imagePath.isEmpty) {
          emit(PermissionDenied());
          return;
        }
        if (ImagePickerUtil.validateImage(imagePath)) {
          _currentImagePath = imagePath;

          emit(ProfileImagePicked(
            imagePath: imagePath,
          ));
        } else {
          emit(ProfileImageError(AppStrings.invalidImage));
        }
      } else {
        emit(ProfileImageError(AppStrings.noImage));
      }
    } catch (e) {
      emit(ProfileImageError(e.toString()));
    }
  }
}
