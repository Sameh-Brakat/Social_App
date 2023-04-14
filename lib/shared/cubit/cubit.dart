import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/cubit/states.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);

      emit(GetUserSuccessState());
    }).catchError((e) {
      print(e);
      emit(GetUserErrorState(e));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    '',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      currentIndex = 0;
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  File? profileimage;

  File? coverimage;

  final picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileimage = File(pickedFile.path);
      emit(GetProfileImageSuccessState());
    } else {
      print('No Image Selected');
      emit(GetProfileImageErrorState());
    }
  }

  Future getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverimage = File(pickedFile.path);
      emit(GetCoverImageSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCoverImageErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileimage!.path)
        .pathSegments
        .last}')
        .putFile(profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, phone: phone, bio: bio, image: value);
        // emit(UploadProfileImageSuccessState());
      }).catchError((e) {
        print(e);
        emit(UploadProfileImageErrorState());
      });
    }).catchError((e) {
      print(e);
      emit(UploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverimage!.path)
        .pathSegments
        .last}')
        .putFile(coverimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, phone: phone, bio: bio, cover: value);
        // emit(UploadCoverImageSuccessState());
      }).catchError((e) {
        print(e);
        emit(UploadCoverImageErrorState());
      });
    }).catchError((e) {
      print(e);
      emit(UploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    UserModel model1 = UserModel(
      name: name,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      email: userModel!.email,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .update(model1.toMap()!)
        .then((value) {
      getUserData();
    }).catchError((e) {
      print(e);
      emit(UserUpdateErrorState());
    });
  }

  File? postImage;

  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(GetPostImageSuccessState());
    } else {
      print('No Image Selected');
      emit(GetPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, dateTime: dateTime, postImage: value);
      }).catchError((e) {
        print(e);
        emit(CreatePostErrorState());
      });
    }).catchError((e) {
      print(e);
      emit(CreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(CreatePostLoadingState());

    PostModel model1 = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model1.toMap()!)
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((e) {
      print(e);
      emit(CreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').orderBy('dateTime').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((e) {
          print(e);
        });
      });
      emit(GetPostSuccessState());
    }).catchError((e) {
      print(e);
      emit(GetPostErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel?.uId)
        .set({'like': true}).then((value) {
      emit(LikePostSuccessState());
    }).catchError((e) {
      print(e);
      emit(LikePostErrorState());
    });
  }

  List<UserModel> users = [];

  void getAllUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          // if (element.data()['uId'] != userModel!.uId)
          users.add(UserModel.fromJson(element.data()));
        });
        emit(GetAllUsersSuccessState());
      }).catchError((e) {
        print(e);
        emit(GetAllUsersErrorState(e));
      });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        dateTime: dateTime,
        text: text);
    // my Chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(model.toMap()!)
        .then((value) {
      emit(SendMessageSuccessState());
    })
        .catchError((e) {
      print(e);
      emit(SendMessageErrorState());
    });

    // receiver Chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('message')
        .add(model.toMap()!)
        .then((value) {
      emit(SendMessageSuccessState());
    })
        .catchError((e) {
      print(e);
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({required String receivedId}) {
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId)
        .collection('chats').doc(receivedId).collection('messages').orderBy('dateTime').snapshots()
        .listen((event) {
          messages = [] ;
          event.docs.forEach((element) {
            messages.add(MessageModel.fromJson(element.data()));
          });
          emit(GetMessageSuccessState());
    });
  }
}
