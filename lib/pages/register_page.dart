import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/register_bloc.dart';
import 'package:social_media_app/pages/add_new_post_page.dart';
import 'package:social_media_app/pages/login_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/viewitems/label_and_textfield_view.dart';
import 'package:social_media_app/utils/extension.dart';
import 'package:social_media_app/viewitems/or_view.dart';
import 'package:social_media_app/viewitems/register_or_login_trigger_view.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Selector<RegisterBloc,bool>(
          selector: (context,bloc) => bloc.isLoading,
          shouldRebuild: (previous,next) => previous != next,
          builder: (context,isLoading,child) =>
          Stack(
            children: [
                Container(
                   padding:const EdgeInsets.only(top: 66,bottom: MARGIN_LARGE,left: MARGIN_XLARGE,right: MARGIN_XLARGE),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       TitleView(
                       title: "Register",
                     ),
                    const SizedBox(height: MARGIN_XXLARGE,),
                    Consumer<RegisterBloc>(
                      builder: (context,RegisterBloc bloc,child) =>
                       LabelAndTextFieldView(
                         controller: bloc.emailController,
                        label: "Email",
                         hint: "Please enter your email",
                          onChanged: (email){
                            bloc.onChangedEmail(email);
                          }
                          ),
                    ),
                     const SizedBox(height: MARGIN_XXLARGE,),
                       Consumer<RegisterBloc>(
                      builder: (context,RegisterBloc bloc,child) =>
                       LabelAndTextFieldView(
                         controller: bloc.nameController,
                        label: "User name",
                         hint: "Please enter your name",
                          onChanged: (name){
                            bloc.onChangedEmail(name);
                          }
                          ),
                    ),
                       const SizedBox(height: MARGIN_XXLARGE,),
                       Consumer<RegisterBloc>(
                      builder: (context,RegisterBloc bloc,child) =>
                       LabelAndTextFieldView(
                         controller: bloc.passwordController,
                        label: "Password",
                         hint: "Please enter your password",
                          onChanged: (password){
                            bloc.onChangedEmail(password);
                          }
                          ),
                    ),
                     const SizedBox(height: MARGIN_XXLARGE,),
                     Consumer<RegisterBloc>(
                       builder: (context,RegisterBloc bloc,child) =>
                      ButtonView(
                         title: "Register",
                          onClick: (){
                              bloc.onTapRegister()
                              .then((value) => Navigator.pop(context))
                              .catchError((error) => showSnackBarWithMessage(context, error.toString()));
                          },
                          ),
                     ),
                     const SizedBox(height: MARGIN_XLARGE,),
                     ORView(),
                      const SizedBox(height: MARGIN_XLARGE,),
                      RegisterOrLoginTriggerView(
                        title: "Login",
                         onclick: (){
                           Navigator.pop(context);
                         }
                         ),
                     ],
                   ),
                ),

                Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: LoadingView(),
                  ),
                )
                )
            ],
          ),
        ),
      ),
    );
  }
}