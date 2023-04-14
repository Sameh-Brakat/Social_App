import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

import '../../shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 200,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: NetworkImage('${userModel?.cover}'),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage('${userModel?.image}')
                      ),
                    ),
                  ],
                ),
              ),
              Text('${userModel?.name}' ,style: Theme.of(context).textTheme.headlineSmall,),
              Text('${userModel?.bio}',style: Theme.of(context).textTheme.bodyLarge),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(
                          children: [
                            Text('10' ,style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 5,),
                            Text('Posts' ,style: TextStyle(fontSize: 15),),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(
                          children: [
                            Text('239' ,style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 5,),
                            Text('Followers' ,style: TextStyle(fontSize: 15),),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){},
                        child: Column(
                          children: [
                            Text('353' ,style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 5,),
                            Text('Following' ,style: TextStyle(fontSize: 15),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {}, child: Text('Add Photos'),),
                  ),
                  SizedBox(width: 10,),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
                    }, child: Icon(IconBroken.Edit),),
                ],
              ),
              Row(
                children:[
                  OutlinedButton(onPressed: (){
                    FirebaseMessaging.instance.subscribeToTopic('announcements');
                  }, child: Text('Subscribe'),),
                  SizedBox(width: 20,),
                  OutlinedButton(onPressed: (){
                    FirebaseMessaging.instance.unsubscribeFromTopic('announcements');
                  }, child: Text('unSubscribe'),),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
