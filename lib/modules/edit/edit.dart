import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micard/components/button_widget.dart';
import 'package:micard/components/navigator.dart';
import 'package:micard/components/text_field.dart';
import 'package:micard/cubit/cubit.dart';
import 'package:micard/cubit/states.dart';
import 'package:micard/modules/home/home.dart';
import 'package:micard/shared/const.dart';

class Edit extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController job = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController website = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MicardCubit, MicardStates>(
      builder: (context, state) {
        var cubit = MicardCubit.get(context);
        return Scaffold(
          backgroundColor: cubit.check ? Colors.black : Colors.white,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MiCard",
                    style: TextStyle(
                        color: cubit.check ? Colors.white : Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          cubit.imagePicker();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: Const.raduisOfProfile,
                              backgroundImage: cubit.file == null
                                  ? const AssetImage("assets/assets.png")
                                  : FileImage(cubit.file!) as ImageProvider,
                            ),
                            CircleAvatar(
                              radius: Const.raduisOfProfile,
                              backgroundColor: Colors.black.withOpacity(0.5),
                            ),
                            const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 25,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFromFieldWidget(
                      check: cubit.check,
                      text: "Name",
                      hint: "Name",
                      textEditingController: name,
                      validator: (v) {
                        return "please enter ur name";
                      },
                      maxLine: 1,
                      textInputType: TextInputType.name),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFromFieldWidget(
                      text: "Job",
                      check: cubit.check,
                      hint: "Job",
                      textEditingController: job,
                      validator: (v) {
                        return "please enter ur job";
                      },
                      maxLine: 1,
                      textInputType: TextInputType.name),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFromFieldWidget(
                      check: cubit.check,
                      text: "Bio",
                      hint: "Bio",
                      textEditingController: bio,
                      validator: (v) {
                        return "please enter ur bio";
                      },
                      maxLine: 3,
                      textInputType: TextInputType.name),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFromFieldWidget(
                      check: cubit.check,
                      text: "Phone",
                      hint: "Phone",
                      textEditingController: phone,
                      validator: (v) {
                        return "please enter ur phone";
                      },
                      maxLine: 1,
                      textInputType: TextInputType.phone),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFromFieldWidget(
                      check: cubit.check,
                      text: "Email",
                      hint: "Email",
                      textEditingController: email,
                      validator: (v) {
                        return "please enter ur email";
                      },
                      maxLine: 1,
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFromFieldWidget(
                      check: cubit.check,
                      text: "Website",
                      hint: "Website",
                      textEditingController: website,
                      validator: (v) {
                        return "please enter ur website";
                      },
                      maxLine: 1,
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigatorReplacement(
                          context: context,
                          widget: Home(
                            bio: bio.text,
                            email: email.text,
                            job: job.text,
                            name: name.text,
                            phone: phone.text,
                            website: website.text,
                          ));
                    },
                    child: WelcomePageButton(
                        color: cubit.check ? Colors.white : Colors.deepPurple,
                        text: "Save"),
                  )
                ],
              ),
            ),
          )),
        );
      },
      listener: (context, state) {},
    );
  }
}
