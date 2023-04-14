
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import '../../shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var userModel = AppCubit.get(context).userModel;
        var coverImage = AppCubit.get(context).coverimage;
        var profileImage = AppCubit.get(context).profileimage;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: DefaultAppBar(
            context: context,
            title: 'New Posts',
            actions: [
              TextButton(
                  onPressed: () {
                    cubit.updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  },
                  child: Text('Update')),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is UserUpdateLoadingState) LinearProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image(
                                  image: coverImage == null
                                      ? NetworkImage('${userModel?.cover}')
                                      : FileImage(coverImage!) as ImageProvider,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () {
                                    cubit.getCoverImage();
                                  },
                                  icon: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: profileImage == null
                                      ? NetworkImage('${userModel?.image}')
                                      : FileImage(profileImage!)
                                          as ImageProvider),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getProfileImage();
                              },
                              icon: const CircleAvatar(
                                backgroundColor: defaultColorLight,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (cubit.profileimage != null || cubit.coverimage != null)
                    Row(
                      children: [
                        if (cubit.profileimage != null)
                          Expanded(
                              child: Column(
                            children: [
                              DefaultButton(
                                  onPressed: () {
                                    cubit.uploadProfileImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                                  },
                                  text: 'Upload Profile Image',
                                  color: Colors.white,
                                  textColor: defaultColorLight,
                                  border: 1,
                                  borderColor: defaultColorLight),
                            ],
                          )),
                        if (cubit.profileimage != null && cubit.coverimage != null)
                          SizedBox(
                            width: 40,
                          ),
                        if (cubit.coverimage != null)
                          Expanded(
                              child: Column(
                            children: [
                              DefaultButton(
                                  onPressed: () {
                                    cubit.uploadCoverImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                                  },
                                  text: 'Upload Cover Image',
                                  color: Colors.white,
                                  textColor: defaultColorLight,
                                  border: 1,
                                  borderColor: defaultColorLight),
                            ],
                          )),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultForm(
                    controller: nameController,
                    type: TextInputType.name,
                    label: 'Name',
                    preIcon: IconBroken.User,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be Empty ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultForm(
                    controller: bioController,
                    type: TextInputType.text,
                    label: 'Bio ...',
                    preIcon: IconBroken.Info_Square,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Bio must not be Empty ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultForm(
                    controller: phoneController,
                    type: TextInputType.text,
                    label: 'Phone',
                    preIcon: IconBroken.Call,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Phone must not be Empty ';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
