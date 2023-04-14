import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_details_screen.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../../shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppCubit.get(context).users!.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => BuildChatItem(AppCubit.get(context).users![index] , context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              color: Colors.grey[200],
              height: 1,
            ),
            itemCount: AppCubit.get(context).users!.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }

  Widget BuildChatItem(UserModel user , context) => InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailsScreen(userModel: user),));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    '${user.image}'),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
                  ),
                  Text(
                    '4/3/2023',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300, height: 1.5),
                  ),
                ],
              )),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined))
            ],
          ),
    ),
  );
}
