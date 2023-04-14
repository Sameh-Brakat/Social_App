import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future<UserCredential?> userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());

    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(uId: value.user!.uid, name: name, email: email, phone: phone,);
    }).catchError((e) {
      print(e);
      emit(RegisterErrorState(e));
    });
  }

  void userCreate({
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) {
    UserModel userModel =
    UserModel(name: name,
      phone: phone,
      email: email,
      uId: uId,
      isEmailVerified: false,);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap()!)
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((e) {
      emit(CreateUserErrorState(e));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;

  bool isPass = true;

  void changePassVis() {
    isPass = !isPass;
    suffixIcon =
    isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangeIconPassState());
  }
}
