import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);

  var textController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: DefaultAppBar(
            context: context,
            title: 'Create Posts',
            actions: [
              TextButton(
                  onPressed: () {
                    var now = DateTime.now();
                    // if(formKey.currentState!.validate() && cubit.postImage == null){
                    //
                    // }
                    if (cubit.postImage == null) {
                      cubit.createPost(
                          dateTime: now.toString(), text: textController.text);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                    } else {
                      cubit.uploadPostImage(
                          dateTime: now.toString(), text: textController.text);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                    }

                  },
                  child: Text(
                    'POST',
                    style: TextStyle(fontSize: 15),
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is CreatePostLoadingState) LinearProgressIndicator(),
                  if (state is CreatePostLoadingState)
                    SizedBox(
                      height: 5,
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage('${cubit.userModel?.image}'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        '${cubit.userModel?.name}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.5),
                      )),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if(value!.isEmpty){
                          return 'Must Write AnyThing';
                        }
                        return null;
                      },
                      controller: textController,
                      decoration: InputDecoration(
                          hintText:
                              'What is on your mind, ${cubit.userModel?.name}',
                          border: InputBorder.none),
                    ),
                  ),
                  if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: FileImage(cubit.postImage!),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            cubit.removePostImage();
                          },
                          icon: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              cubit.getPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(IconBroken.Image),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('add photo')
                              ],
                            )),
                      ),
                      Expanded(
                        child:
                            TextButton(onPressed: () {}, child: Text('# tags')),
                      ),
                    ],
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
