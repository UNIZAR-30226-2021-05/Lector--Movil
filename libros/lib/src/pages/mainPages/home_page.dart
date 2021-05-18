import 'package:flutter/material.dart';
import 'package:libros/src/pages/mainPages/feed_page.dart';

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

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<BottomNavigationBarItem> buildItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        activeIcon: Icon(Icons.home),
        label: 'Leyendo',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_library_outlined),
        activeIcon: Icon(Icons.local_library),
        label: 'Mis libros',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Búsqueda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.public),
        label: 'Feed',
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
      physics: new NeverScrollableScrollPhysics(),
      /*onPageChanged: (index) {
        pageChanged(index);
      },*/
      children: <Widget>[
        ReadingPage(),
        LibraryPage(),
        SearchPage(),
        FeedPage(),
        ProfilePage(),
      ],
    );
  }

  //Actualiza toda la interfaz cuando el usuario hace "slide" sobre la misma
  /* void pageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }*/

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
