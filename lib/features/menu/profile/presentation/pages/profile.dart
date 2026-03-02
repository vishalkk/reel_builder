import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mis_mobile/core/utils/app_size.dart';
import 'package:mis_mobile/core/utils/app_text_style.dart';
import 'package:mis_mobile/core/utils/font_size.dart';
import 'package:mis_mobile/core/utils/string_constant.dart';
import 'package:mis_mobile/features/menu/profile/presentation/cubit/profile_cubit.dart';
import 'package:mis_mobile/features/widgets/menu/edit_tile.dart';
import 'package:mis_mobile/features/widgets/page_templates/template.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Template(
        text: AppStrings.profile,
        subText: '',
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSize.s50.h,
                ),
                BlocConsumer<ProfileCubit, ProfileState>(
                    listener: (context, state) {
                  if (state is ProfileImageError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is ProfileImagePicked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppStrings.imageUploadSuccess),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is PermissionDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppStrings.permissionDenied),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }, builder: (context, state) {
                  var profileCubit = context.read<ProfileCubit>();
                  return EditTile(
                    title: AppStrings.profilePic,
                    leading: CircleAvatar(
                        backgroundImage: profileCubit.profileImage),
                    isEdit: true,
                    onTap: () {
                      profileCubit.pickImageWithDialog(context);
                    },
                  );
                }),
                SizedBox(
                  height: AppSize.s30.h,
                ),
                EditTile(
                  title: AppStrings.accountName,
                  leading: Text(
                    AppStrings.dummyUsername,
                    style: AppTextStyles.bodyLarge(
                        fontWeight: FontWeightUtil.bold),
                  ),
                  isEdit: true,
                ),
                SizedBox(
                  height: AppSize.s30.h,
                ),
                EditTile(
                  title: AppStrings.phoneNum,
                  leading: Text(
                    AppStrings.dummyPhNum,
                    style: AppTextStyles.bodyLarge(
                        fontWeight: FontWeightUtil.bold),
                  ),
                  isEdit: false,
                )
              ],
            )),
      ),
    );
  }
}
