import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart'
    as rive; // Prefixo adicionado para a biblioteca Rive
import 'package:muapp_frontend/screens/onboding/components/animated_btn.dart';
import 'package:muapp_frontend/screens/onboding/components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late rive.RiveAnimationController
      _btnAnimationController; // Usando o prefixo para a Rive

  @override
  void initState() {
    _btnAnimationController = rive.OneShotAnimation("active",
        autoplay: false); // Usando o prefixo para a Rive
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            //height: MediaQuery.of(context).size.height * 2,
            bottom: 200,
            left: 50,
            child: Image.network(
                'https://drive.google.com/uc?export=download&id=1uBgzI3TcySn3tdTLTk79prTHD4oSuDI0')), // Usando a Image padrão do Flutter
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
        )),
        const rive.RiveAnimation.asset(
            'assets/RiveAssets/shapes.riv'), // Usando o prefixo para a Rive
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          child: const SizedBox(),
        )),
        AnimatedPositioned(
          duration: Duration(milliseconds: 240),
          top: isSignInDialogShown ? -50 : 0,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(children: [
                        Text(
                          "Explore descubra & conecte-se.",
                          style: TextStyle(
                              fontSize: 50, fontFamily: "Roboto", height: 1.2),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                            "Explore museus com nosso guia de áudio interativo, descubra histórias fascinantes e conecte-se de forma única com cada obra.")
                      ]),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(Duration(milliseconds: 800), () {
                          setState(() {
                            isSignInDialogShown = true;
                          });
                          customSigninDialog(context, onClosed: (_) {
                            setState(() {
                              isSignInDialogShown = false;
                            });
                          });
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        "O aplicativo conta com +100 museus parceiros, 200h de audio guia e 12 mil obras",
                        style: TextStyle(),
                      ),
                    )
                  ]),
            ),
          ),
        )
      ],
    ));
  }
}
