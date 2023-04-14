import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/shared/network/local/cashe_helper.dart';

import '../../shared/components/components.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formkey = GlobalKey<FormState>();
  var emailcontroller = TextEditingController();
  var passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, state) {
          if (state is LoginErrorState) {
            Toastt(message: state.error, state: ToastStates.ERROR);
          }
          if(state is LoginSuccessState){
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
            });
          }
        },
        builder: (BuildContext context, state) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Text('Login',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 30,
                    ),
                    DefaultForm(
                      isPassword: false,
                      controller: emailcontroller,
                      type: TextInputType.emailAddress,
                      label: 'Email',
                      preIcon: Icons.email_outlined,
                      validate: ((value) {
                        if (value!.isEmpty) {
                          return 'Email Must not be Empty';
                        }
                        return null;
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DefaultForm(
                      suffix: LoginCubit.get(context).suffixIcon,
                      suffixPressed: () {
                        LoginCubit.get(context).changePassVis();
                      },
                      isPassword: LoginCubit.get(context).isPass,
                      submit: (value) {
                        if (formkey.currentState!.validate()) {
                          LoginCubit.get(context).userLogin(
                              email: emailcontroller.text,
                              password: passcontroller.text);
                        }
                      },
                      controller: passcontroller,
                      type: TextInputType.visiblePassword,
                      label: 'Password',
                      preIcon: Icons.lock_outline,
                      validate: ((value) {
                        if (value!.isEmpty) {
                          return 'Password Must not be Empty';
                        }
                        return null;
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) => DefaultButton(
                          text: 'Log In',
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                      email: emailcontroller.text,
                                      password: passcontroller.text);
                                }
                              },
                            ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator())),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an Account? "),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            child: Text('Register Now !')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
