import 'package:air_files/screens/login_screen.dart';
import 'package:air_files/utils/api.dart';
import 'package:air_files/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  // Validate Helper Function
  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Field can\'t be empty!';
    }
    return null;
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Registering...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                      fontSize: 16,
                    )),
                  )
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Air Files",
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : null)),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Register",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w500,
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Please enter your email and password to start flying!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w500,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              style: GoogleFonts.raleway(),
                              controller: _fullNameController,
                              validator: _fieldValidator,
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                prefixIcon: const Icon(Icons.email_rounded),
                                hintText: "Enter your full name",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer),
                                ),
                                labelStyle: GoogleFonts.raleway(),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.raleway(),
                              controller: _userEmailController,
                              validator: _fieldValidator,
                              decoration: InputDecoration(
                                labelText: "Email ID",
                                prefixIcon: const Icon(Icons.email_rounded),
                                hintText: "Enter your email-ID",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer),
                                ),
                                labelStyle: GoogleFonts.raleway(),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              style: GoogleFonts.sourceCodePro(),
                              obscureText: _isObscure,
                              controller: _passwordController,
                              validator: _fieldValidator,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock_rounded),
                                hintText: "Enter your password",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer),
                                ),
                                labelStyle: GoogleFonts.raleway(),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      !_isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?  ",
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                              : null)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (route) => false);
                                  },
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.raleway(
                                        textStyle: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer
                                                    : null)),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async => {
                                  if (_registerFormKey.currentState!.validate())
                                    {
                                      Api()
                                          .register(
                                              _fullNameController.text.trim(),
                                              _userEmailController.text.trim(),
                                              _passwordController.text)
                                          .then((value) => {
                                                if (value == "OK")
                                                  {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LoginScreen()),
                                                            (route) => false),
                                                    setState(() {
                                                      isLoading = false;
                                                    }),
                                                  }
                                                else
                                                  {
                                                    setState(() {
                                                      isLoading = false;
                                                    }),
                                                    showToast(value)
                                                  }
                                              })
                                    }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 8.0),
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.raleway(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
    );
  }
}
