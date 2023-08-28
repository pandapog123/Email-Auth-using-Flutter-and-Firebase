import 'package:code/routes/auth/main.dart';
import 'package:code/routes/signup/main.dart';
import 'package:code/state/auth/auth_bloc.dart';
import 'package:code/state/auth/auth_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginRoute extends StatefulWidget {
  static const name = "LoginRoute";

  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  late final AuthenticationRepository authenticationRepository;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  LoginRouteState state = LoginRouteState();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    authenticationRepository = AuthenticationRepository(
      auth: FirebaseAuth.instance,
    );

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.addListener(() {
      setState(() {
        state.setEmail(_emailController.value.text);
      });
    });

    _passwordController.addListener(() {
      setState(() {
        state.setPassword(_passwordController.value.text);
      });
    });
  }

  handleSubmit() async {
    if (!state.formValid) {
      return;
    }

    state.setLoading(true);

    try {
      final authBloc = context.read<AuthBloc>();

      await authBloc.loginWithEmail(
        state.emailInput,
        state.passwordInput,
      );
    } on FirebaseAuthException catch (error) {
      final snackBar = SnackBar(
        content: Text(error.message ?? error.code),
      );

      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(snackBar);
      }
    } catch (error) {
      const snackBar = SnackBar(
        content: Text("An unexpected error occurred"),
      );

      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(snackBar);
      }
    }

    state.setLoading(false);
  }

  handlePop() {
    context.goNamed(AuthRoute.name);
  }

  handleRedirect() {
    context.goNamed(SignupRoute.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text("Log In"),
        titleTextStyle: theme.textTheme.headlineLarge,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: state.formValid ? handleSubmit : null,
                    style: FilledButton.styleFrom(
                      textStyle: theme.textTheme.titleLarge,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.loading)
                          const CircularProgressIndicator.adaptive()
                        else
                          const Text("Log in"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: theme.textTheme.titleMedium,
                ),
                Material(
                  child: InkWell(
                    onTap: handleRedirect,
                    child: Text(
                      "Sign up!",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handlePop,
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

class LoginRouteState {
  String _emailInput = "";
  String _passwordInput = "";
  bool _loading = false;

  String get emailInput => _emailInput;
  String get passwordInput => _passwordInput;
  bool get loading => _loading;

  bool get emailValid {
    return EmailValidator.validate(_emailInput);
  }

  bool get passwordValid {
    return _passwordInput.length > 7;
  }

  bool get formValid {
    return emailValid && passwordValid && !_loading;
  }

  setEmail(String input) {
    _emailInput = input;
  }

  setPassword(String input) {
    _passwordInput = input;
  }

  setLoading(bool loading) {
    _loading = loading;
  }
}
