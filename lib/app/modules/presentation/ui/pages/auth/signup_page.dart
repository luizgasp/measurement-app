import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:measurement/app/modules/domain/useCases/user/auth_usecase.dart';
import 'package:measurement/app/modules/infra/exceptions/auth_errors.dart';
import 'package:measurement/app/modules/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:measurement/app/modules/presentation/ui/pages/auth/login_page.dart';
import 'package:measurement/app/modules/presentation/ui/widgets/custom_elevated_button.dart';
import 'package:measurement/app/modules/presentation/ui/widgets/custom_input_form.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String routeName = "/sign-up";

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const SignUpPage(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ValueNotifier _nameNotifier = ValueNotifier("");
  final ValueNotifier _emailNotifier = ValueNotifier("");
  final ValueNotifier _passwordNotifier = ValueNotifier("");

  final authUseCase = GetIt.I.get<AuthUseCase>();
  final userBloc = GetIt.I.get<UserBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 120.h),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign up.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Please enter the details below to continue',
                      style: TextStyle(
                        color: Theme.of(context).dialogBackgroundColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70.h),
              CustomInputForm(
                label: 'Full Name',
                paddingLeft: 20,
                onChangedFunction: (value) => _nameNotifier.value = value,
              ),
              SizedBox(height: 15.h),
              CustomInputForm(
                label: 'Email',
                paddingLeft: 20,
                onChangedFunction: (value) => _emailNotifier.value = value,
              ),
              SizedBox(height: 15.h),
              CustomInputForm(
                label: 'Password',
                paddingLeft: 20,
                obscureText: true,
                onChangedFunction: (value) => _passwordNotifier.value = value,
              ),
              SizedBox(height: 80.h),
              CustomElevatedButton(
                label: "Sign up",
                width: double.infinity,
                height: 45.h,
                onPressed: () async {
                  try {
                    await authUseCase.createUser(
                      _nameNotifier.value,
                      _emailNotifier.value,
                      _passwordNotifier.value,
                    );

                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Account created successfully"),
                      ),
                    );
                  } on AuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.errorMessage)),
                    );
                  }
                },
              ),
              SizedBox(height: 10.h),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Theme.of(context).dialogBackgroundColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "Sign in.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            LoginPage.routeName,
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
