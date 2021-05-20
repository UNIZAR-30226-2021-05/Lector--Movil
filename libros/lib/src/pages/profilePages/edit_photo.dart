import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:dropbox_client/dropbox_client.dart';

/*
  Esta pantalla muestra la configuracion del usuario
 */

const String dropbox_clientId = 'y2s7oimvar9r3th';
const String dropbox_key =
    'Me56EUxeX0MAAAAAAAAAAXkCEw6O5oYINF1YCi5PoGZm9xjFhQxFswcp2o_Kla8L';
const String dropbox_secret = 'bq9lgl4nfohe9s3';

class EditPhoto extends StatefulWidget {
  @override
  _EditPhotoState createState() => _EditPhotoState();
}

//No incluir Scaffold (lo añade HomePage)
class _EditPhotoState extends State<EditPhoto> {
  SessionManager s = new SessionManager();
  PickedFile _image;
  File profilePicture;
  String accessToken;
  bool showInstruction = false;
  String _pathFoto = "";
  _EditPhotoState() {
    getUserInfo();
  }

  getUserInfo() async {
    s.getpathPhoto().then((String result) {
      setState(() {
        _pathFoto = result;
      });
    });
  }

  var _controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    Dropbox.init(dropbox_clientId, dropbox_key, dropbox_secret);
    Dropbox.authorizeWithAccessToken(
        'Me56EUxeX0MAAAAAAAAAAXkCEw6O5oYINF1YCi5PoGZm9xjFhQxFswcp2o_Kla8L');
  }

  Future subirImagen(File image, int now) async {
    final filepath = image.path.toString();

    final result = await Dropbox.upload(filepath, '/brainbook/image/$now.jpg',
        (uploaded, total) {
      print('progress $uploaded / $total');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 0.0),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new IconButton(
                          icon: new Icon(Icons.arrow_back_ios_rounded,
                              size: 40.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Editar foto',
                          style: TextStyle(
                            fontSize: 30.0,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1.7,
                    color: Colors.black38,
                  ),
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder:
                                    AssetImage("assets/defaultProfile.png"),
                                image: NetworkImage(_pathFoto)),
                          ),
                        ),
                      ),
                      SizedBox(height: 55),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 200,
                          child: RaisedButton(
                            onPressed: () async {
                              _showPicker(context);
                            },
                            elevation: 4,
                            textColor: Colors.white,
                            color: Colors.blue[600],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Cambiar foto',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: SizedBox(
                          width: 200,
                          child: RaisedButton(
                            onPressed: () async {
                              profilePicture = new File(_image.path);
                              print("El path es: " + profilePicture.path);
                              var now =
                                  new DateTime.now().millisecondsSinceEpoch;
                              subirImagen(profilePicture, now);
                              SessionManager s = new SessionManager();
                              String username = await s.getNombreUsuario();
                              String email = await s.getEmail();

                              updateUserInfo(email,
                                  now.toString() + "." + "jpg", username);
                            },
                            elevation: 4,
                            textColor: Colors.white,
                            color: Colors.green[600],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Confirmar cambios',
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
                ]))));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Haz una foto'),
                      onTap: () async {
                        PickedFile image = await ImagePicker().getImage(
                            source: ImageSource.camera, imageQuality: 50);
                        Navigator.of(context).pop();
                        setState(() {
                          _image = image;
                        });
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Escoge una foto'),
                    onTap: () async {
                      PickedFile image = await ImagePicker().getImage(
                          source: ImageSource.gallery, imageQuality: 50);
                      setState(() {
                        _image = image;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
