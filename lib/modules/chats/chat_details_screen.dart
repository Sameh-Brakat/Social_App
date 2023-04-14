import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/shared/components/constants.dart';
import '../../models/user_model.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;
  var textController = TextEditingController();

  ChatDetailsScreen({required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(receivedId: userModel.uId as String);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${userModel.name}'),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var message = cubit.messages[index];
                        if (cubit.userModel!.uId == message.senderId) {
                          return BuildMyMessage(message);
                        }
                        return BuildMessage(message);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 15,
                      ),
                      itemCount: cubit.messages.length,
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: TextFormField(
                              controller: textController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type Your Message here ...',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          color: defaultColorLight,
                          child: MaterialButton(
                            onPressed: () {
                              cubit.sendMessage(
                                receiverId: userModel.uId!,
                                dateTime: DateTime.now().toString(),
                                text: textController.text,
                              );
                            },
                            minWidth: 1,
                            child: Icon(
                              IconBroken.Send,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget BuildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
              )),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Text(
            '${model.text}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

  Widget BuildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
              color: defaultColorLight.withOpacity(0.2),
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10),
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
              )),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Text(
            '${model.text}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
}
