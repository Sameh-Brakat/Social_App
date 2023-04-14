import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import '../../models/post_model.dart';
import '../../shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(8),
                    elevation: 5,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/img3.jpg'),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            'Communicate With Friends',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        BuildPostItem(cubit.posts[index] , context , index),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: cubit.posts.length,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
          fallback: (BuildContext context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget BuildPostItem(PostModel model , context , index) => Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('${model.image}'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.5),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 20,
                          )
                        ],
                      ),
                      Text(
                        '${model.dateTime}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            height: 1.5),
                      ),
                    ],
                  )),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.more_horiz_outlined))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  height: 1,
                ),
              ),
              Text(
                '${model.text}',
                style: TextStyle(
                    fontSize: 18, height: 1.1, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              // Wrap(
              //   children: [
              //     MaterialButton(
              //       textColor: Colors.blue,
              //       height: 20,
              //       minWidth: 1,
              //       padding: EdgeInsets.zero,
              //       onPressed: () {},
              //       child: Text('#software'),
              //     ),
              //     MaterialButton(
              //       textColor: Colors.blue,
              //       height: 20,
              //       minWidth: 1,
              //       padding: EdgeInsets.zero,
              //       onPressed: () {},
              //       child: Text('#software'),
              //     ),
              //     MaterialButton(
              //       textColor: Colors.blue,
              //       height: 20,
              //       minWidth: 1,
              //       padding: EdgeInsets.zero,
              //       onPressed: () {},
              //       child: Text('#software'),
              //     ),
              //     MaterialButton(
              //       textColor: Colors.blue,
              //       height: 20,
              //       minWidth: 1,
              //       padding: EdgeInsets.zero,
              //       onPressed: () {},
              //       child: Text('#software'),
              //     ),
              //     MaterialButton(
              //       textColor: Colors.blue,
              //       height: 20,
              //       minWidth: 1,
              //       padding: EdgeInsets.zero,
              //       onPressed: () {},
              //       child: Text('#software'),
              //     ),
              //   ],
              // ),
              if (model.postImage != '')
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: NetworkImage('${model.postImage}'),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(IconBroken.Heart,
                                  size: 15, color: Colors.red),
                              SizedBox(
                                width: 5,
                              ),
                              Text('${AppCubit.get(context).likes[index]}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(IconBroken.Chat,
                                  size: 15, color: Colors.orange),
                              SizedBox(
                                width: 5,
                              ),
                              Text('120 comments'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.grey[200],
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage('${AppCubit.get(context).userModel!.image}'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Write a comment ...'),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppCubit.get(context).likePost(AppCubit.get(context).postsId[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(IconBroken.Heart, size: 15, color: Colors.red),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Like'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 5,
                            ),
                            Icon(IconBroken.Send,
                                size: 15, color: Colors.green),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Share'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
