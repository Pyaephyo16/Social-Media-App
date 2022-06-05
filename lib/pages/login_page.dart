import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/login_bloc.dart';
import 'package:social_media_app/pages/add_new_post_page.dart';
import 'package:social_media_app/pages/news_fedd_page.dart';
import 'package:social_media_app/pages/register_page.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/viewitems/label_and_textfield_view.dart';
import 'package:social_media_app/utils/extension.dart';
import 'package:social_media_app/viewitems/or_view.dart';
import 'package:social_media_app/viewitems/register_or_login_trigger_view.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Selector<LoginBloc,bool>(
          selector: (context,bloc) => bloc.isLoading,
          shouldRebuild: (previous,next) => previous != next,
          builder: (context,isLoading,child) =>
          Stack(
            children: [
              Container(
                padding:const EdgeInsets.only(top: 66,bottom: MARGIN_LARGE,left: MARGIN_XLARGE,right: MARGIN_XLARGE),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     TitleView(
                       title: "Login",
                     ),
                    const SizedBox(height: MARGIN_XXLARGE,),
                    Consumer<LoginBloc>(
                      builder: (context,LoginBloc bloc,child) =>
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
                    Consumer<LoginBloc>(
                      builder: (context,LoginBloc bloc,child) =>
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
                     Consumer<LoginBloc>(
                       builder: (context,LoginBloc bloc,child) =>
                       ButtonView(
                         title: "Login",
                         onClick: (){
                           bloc.onTapLogin()
                           .then((value) => navigateToNextScreen(context, NewsFeedPage()))
                           .catchError((error) => showSnackBarWithMessage(context, error.toString()));
                         },
                       ),
                       ),
                       const SizedBox(height: MARGIN_XXLARGE,),
                       ORView(),
                        const SizedBox(height: MARGIN_XXLARGE,),
                        RegisterOrLoginTriggerView(
                          title: "Register",
                          onclick: (){
                            navigateToNextScreen(context,RegisterPage());
                          },
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

class ButtonView extends StatelessWidget {

  final String title;
  final Function onClick;

  ButtonView({
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onClick();
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.black,
        ),
         child: Center(
           child: Text(title,
           style: TextStyle(
             color: Colors.white,
             fontWeight: FontWeight.bold,
             fontSize: 18,
           ),),
         )
         ),
    );
  }
}

class TitleView extends StatelessWidget {

  final String title;

  TitleView({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
                    style: TextStyle(
       fontWeight: FontWeight.bold,
       fontSize: 24,
                    ),
                    );
  }
}