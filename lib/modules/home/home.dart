import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:micard/components/button_widget.dart';
import 'package:micard/components/micard_widget.dart';
import 'package:micard/components/navigator.dart';
import 'package:micard/components/social_widget.dart';
import 'package:micard/cubit/cubit.dart';
import 'package:micard/cubit/states.dart';
import 'package:micard/modules/edit/edit.dart';
import 'package:micard/shared/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatefulWidget {
  String? name;
  String? job;
  String? bio;
  String? phone;
  String? email;
  String? website;
  File? image;
  Home({this.bio, this.email, this.phone, this.job, this.website, this.name});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey globalKey = GlobalKey();
  final pdf = pw.Document();

  Uint8List? images;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MicardCubit, MicardStates>(
        builder: (context, state) {
          var cubit = MicardCubit.get(context);

          return RepaintBoundary(
            key: globalKey,
            child: Scaffold(
              backgroundColor: cubit.check ? Colors.black : Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: cubit.check ? Colors.black : Colors.deepPurple,
                centerTitle: true,
                title: Text(
                  "MiCard",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Const.fontOne,
                      fontWeight: FontWeight.bold),
                ),
                leading: GestureDetector(
                  onTap: () {
                    cubit.changeMode();
                  },
                  child: cubit.check
                      ? const Icon(
                          Icons.sunny,
                          color: Colors.white,
                          size: 21,
                        )
                      : const Icon(
                          Icons.nightlight,
                          color: Colors.white,
                          size: 21,
                        ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: GestureDetector(
                        onTap: () {
                          navigator(context: context, widget: Edit());
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 21,
                        )),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Capture",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: Const.fontOne,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            RenderRepaintBoundary boundary =
                                                globalKey.currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            ui.Image image = await boundary
                                                .toImage(pixelRatio: 3);
                                            ByteData? byteData =
                                                await image.toByteData(
                                                    format:
                                                        ui.ImageByteFormat.png);

                                            setState(() {
                                              images = byteData!.buffer
                                                  .asUint8List();
                                            });
                                            final directory =
                                                await getApplicationSupportDirectory();
                                            final imagePath = await File(
                                                    "${directory.path}/${DateTime.now().microsecondsSinceEpoch}.png")
                                                .create();
                                            await imagePath
                                                .writeAsBytes(images!);

                                            log(imagePath.path);
                                            setState(() {
                                              widget.image = imagePath;
                                            });
                                            await GallerySaver.saveImage(
                                                imagePath.path,
                                                albumName: "Flutter");
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Image",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Const.fontOne,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            RenderRepaintBoundary boundary =
                                                globalKey.currentContext!
                                                        .findRenderObject()
                                                    as RenderRepaintBoundary;
                                            ui.Image image = await boundary
                                                .toImage(pixelRatio: 3);
                                            ByteData? byteData =
                                                await image.toByteData(
                                                    format:
                                                        ui.ImageByteFormat.png);

                                            setState(() {
                                              images = byteData!.buffer
                                                  .asUint8List();
                                            });
                                            pdf.addPage(pw.Page(
                                                pageFormat: PdfPageFormat.a4,
                                                build: (pw.Context context) {
                                                  return pw.Container(
                                                    width: 700,
                                                    height: 700,
                                                    decoration: pw.BoxDecoration(
                                                        image: pw.DecorationImage(
                                                            image: pw.MemoryImage(
                                                      images!,
                                                    ))),
                                                  );
                                                }));
                                            Permission.storage
                                                .request()
                                                .then((value) {
                                              if (value.isGranted == true) {
                                                getExternalStorageDirectory()
                                                    .then((value) {
                                                  File("${value!.path}.pdf")
                                                      .create()
                                                      .then((value) async {
                                                    await value.writeAsBytes(
                                                        await pdf.save());
                                                    FileSaver.instance
                                                        .saveFile(
                                                            name: "pdf",
                                                            filePath:
                                                                value.path,
                                                            file: value)
                                                        .then((value) {})
                                                        .catchError((e) {
                                                      log(e.toString());
                                                    });
                                                  });
                                                });
                                              } else {
                                                log("${value.isGranted}");
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "PDF",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Const.fontOne,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Text(
                                                "Scan",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Const.fontOne,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 21,
                        )),
                  ),
                ],
              ),
              body: SafeArea(
                  child: images == null
                      ? Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 140,
                                  decoration: BoxDecoration(
                                      color: cubit.check
                                          ? Colors.white
                                          : Colors.deepPurple,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(150),
                                          bottomRight: Radius.circular(150))),
                                ),
                                Transform(
                                  transform:
                                      Matrix4.translationValues(0, 30, 0),
                                  child: CircleAvatar(
                                    radius: Const.raduisOfProfile + 2,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Transform(
                                  transform:
                                      Matrix4.translationValues(0, 30, 0),
                                  child: CircleAvatar(
                                    radius: Const.raduisOfProfile,
                                    backgroundImage: cubit.file == null
                                        ? const AssetImage("assets/assets.png")
                                        : FileImage(cubit.file!)
                                            as ImageProvider,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            if (widget.image != null) ...[
                              QrImage(
                                data: "the Qr Photo",
                                version: QrVersions.auto,
                                size: 100,
                                gapless: false,
                                embeddedImage: cubit.file == null
                                    ? const AssetImage("assets/assets.png")
                                    : FileImage(cubit.file!) as ImageProvider,
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: const Size(10, 10)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                            Text(
                              widget.name ?? "Add Ur name",
                              style: TextStyle(
                                  color:
                                      cubit.check ? Colors.white : Colors.black,
                                  fontSize: Const.fontOne,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.job ?? "Add Ur Job",
                              style: TextStyle(
                                  color:
                                      cubit.check ? Colors.grey : Colors.black,
                                  fontSize: Const.fontTwo,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.bio ?? "Add Ur Bio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:
                                      cubit.check ? Colors.grey : Colors.black,
                                  fontSize: Const.fontTwo,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(
                                color: cubit.check
                                    ? Colors.white
                                    : Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "OverView",
                                          style: TextStyle(
                                              color: cubit.check
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: Const.fontOne,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        MicardWidget(
                                            check: cubit.check,
                                            content:
                                                widget.phone ?? "Add ur Phone",
                                            type: "Phone",
                                            assetName: "assets/whatsapp.png"),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        MicardWidget(
                                            check: cubit.check,
                                            content:
                                                widget.email ?? "Add ur Email",
                                            type: "Email",
                                            assetName: "assets/email.png"),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        MicardWidget(
                                            check: cubit.check,
                                            content: widget.website ??
                                                "Add ur Website",
                                            type: "Website",
                                            assetName: "assets/website.jpg"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Social",
                                          style: TextStyle(
                                              color: cubit.check
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: Const.fontOne,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SocialWidget(assetName: "assets/facebook.png"),
                                SocialWidget(assetName: "assets/twitter.png"),
                                SocialWidget(assetName: "assets/linkedIn.png"),
                                SocialWidget(assetName: "assets/instgram.jpg"),
                                SocialWidget(assetName: "assets/github.png"),
                                SocialWidget(assetName: "assets/snapchat.png"),
                              ],
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      border: Border.all(
                                          color: Colors.deepPurple, width: 1.2),
                                      image: DecorationImage(
                                          image: MemoryImage(images!))),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      images = null;
                                    });
                                  },
                                  child: WelcomePageButton(
                                      color: Colors.deepPurple, text: "Back"),
                                )
                              ],
                            ),
                          ),
                        )),
            ),
          );
        },
        listener: (context, state) {});
  }
}
