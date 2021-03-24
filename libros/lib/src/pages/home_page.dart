import 'package:flutter/material.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:libros/src/pages/first_page.dart';
import 'package:libros/src/pages/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'reading_page.dart';
import 'library_page.dart';
import 'search_page.dart';
import 'profile_page.dart';

/*
  Esta pantalla implementa el PageView y el BottomNavigatorBar
  Permite que el usuario pueda desplazarse entre las pantallas haciendo slide
  o seleccionando un item de la barra de navegación.
  Utilizar un PageView evita que desaparezca la barra de navegación cada vez que
  se carga una página

  Los módulos entre los que permite desplazarse son:
    reading_page.dart
    library_page.dart,
    search_page.dart
    profile_page.dart
 */

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Índice inicial del NavigationBar
  int currentIndex = 0;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("Estoy comprobando si tengo que ir a un lado o a otro");
    if (sharedPreferences.getString("key") == null) {
      print("Te tengo que llevar al login que no estas logueado");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => FirstPage()),
          (Route<dynamic> route) => false);
    } else {
      print("No bro, esta es tu key: " + sharedPreferences.getString("key"));
      getAndStoreUserInfo();
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<BottomNavigationBarItem> buildItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_outlined),
        label: 'Leyendo',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_library),
        label: 'Biblioteca',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Búsqueda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_rounded),
        label: 'Perfil',
      ),
    ];
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        ReadingPage(),
        LibraryPage(),
        SearchPage(),
        ProfilePage(),
      ],
    );
  }

  //Actualiza toda la interfaz cuando el usuario hace "slide" sobre la misma
  void pageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //Actualiza toda la interfaz cuando el usuario selecciona un item del
  // NavigationBat
  void bottomTapped(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildItems(),
        selectedItemColor: Colors.grey[900],
        unselectedItemColor: Colors.grey[500],
      ),
    );
  }
}
