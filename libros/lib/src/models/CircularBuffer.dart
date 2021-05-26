import "dart:async";
import 'package:libros/src/models/bookFacade.dart';

/************************************************************************
 * Implementación de un buffer circular.
 * Operaciones públicas:
 *  - Leer hacia la derecha
 *  - Leer hacia la izquierda
 *  - Obtener el offset actual de lectura del libro "currentOffset"
 *
 * PUNTEROS UTILIZADOS
 *    PUNTEROS ABSOLUTOS (OFFSET BACKEND)
 *      currentOffset
 *    PUNTEROS RELATIVOS (OFFSET BUFFER)
 *      headptr
 *      currentptr
 *      tailptr
 *
 *  EJEMPLOS CASOS:
 *   -Llamo a constructor con currentOffset de 1250. El puntero currentptr
 *    es relativo a currentOffset valiendo 0 en el inicio.
 *    Cualquier lectura en el buffer modifica solo el currentptr.
 *    Para actualizar el currentOffset solo es necesario sumarle el
 *    currentptr.
 *
 *   -La inserción de texto en el buffer se produce cuando se lee en un
 *   sentido y queda menos de 1/3 del buffer para llegar al extremo
 *   del mismo sentido.
 *
 *   -Cuando  una inserción de texto en un extremo del buffer implica
 *   llenar el buffer, se elimina 1/3 del buffer en el extremo opuesto y se
 *   procede a la inserción.
 ***************************************************************************/

class CircularBuffer {
  final int pageCharacters; //Nº caracteres por pagina
  int maxLength; //Nº maximo caracteres buffer
  int insertLength; //Nº caracteres a actualizar en buffer
  int freeSpaceMinLength; //Mínimo de caracteres para liberar espacio en buffer
  int realCharacters; //Corresponde al campo json "realCharacteres" de backend
  String filePath; //Nombre de fichero "libro.pdf"

  int currentOffset; //Offset actual de lectura del libro.
  int currentptr; //Offset relativo de lectura del buffer
  int headptr; //Offset relativo del frente del buffer
  int tailptr; //Offset relativo de la cola del buffer

  String lastDirection; //Direccion ultima lectura: "derecha" o "izquierda"
  String buffer; //string base para el buffer circular

  CircularBuffer(this.filePath, this.currentOffset, this.pageCharacters) {
    maxLength = pageCharacters * 18; //18 páginas de buffer (12 de caché)
    insertLength = maxLength ~/ 3; // 1/3 del buffer
    freeSpaceMinLength = maxLength ~/ 1.5; // 2/3 del buffer
    buffer = "";
    realCharacters = 0;
    currentptr = 0;
    headptr = 0;
    tailptr = 0;
    lastDirection = "";
  }

  //Obtener el offset de lectura absoluto para actualizar el backend
  int getCurrentOffset() {
    if(lastDirection == "derecha") {
      return currentOffset +currentptr;
    }
    return currentOffset + currentptr;
  }

  //Actualiza el extremo derecho del buffer
  Future escribirDcha() async {
    print("BEGIN escribirDcha h:" + headptr.toString());
    if (buffer.length > freeSpaceMinLength) {
      //Caso liberar espacio en el extremo opuesto
      print("escribirDcha - if");
      borrarIzda();
    }
    await getText(filePath, currentOffset + headptr, insertLength)
        .then((Map<String, String> map) {
      buffer += map['text'];
      realCharacters = int.parse(map['realCharacters']);
      headptr += realCharacters;
    });
    print("END escribirDcha h:" + headptr.toString());
  }

  //Actualiza el extremo izquierdo del buffer
  Future escribirIzda() async {
    print("escribirIzda");
    await getText(filePath, currentOffset - tailptr - insertLength,
            pageCharacters * 6)
        .then((Map<String, String> map) {
      buffer = map['text'] + buffer;
      realCharacters = int.parse(map['realCharacters']);
      tailptr = 0;
      currentptr += realCharacters;
      currentOffset -= realCharacters;
      headptr += realCharacters;
    });
  }

  //Lectura del buffer en sentido derecho
  Future<String> leerDcha() async {
    print("BEGIN leerDcha: buffer -> " +
        buffer.length.toString() +
        "t: " +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
    String page;
    if (headptr - currentptr < pageCharacters) {
      //Caso actualizar buffer por la derecha
      await escribirDcha();
    }
    if (lastDirection == "izquierda") {
      //Caso último sentido de lectura distinto
      page = buffer.substring(
          currentptr + pageCharacters, currentptr + 2 * pageCharacters);
      currentptr += 2 * pageCharacters;
    } else {
      page = buffer.substring(currentptr, currentptr + pageCharacters);
      currentptr += pageCharacters;
    }
    print("END leerDcha: buffer -> " +
        buffer.length.toString() +
        "t: " +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
    lastDirection = "derecha";
    return page;
  }

  //Lectura del buffer en sentido izquierdo
  Future<String> leerIzda() async {
    print(" BEGIN leerIzda: buffer -> " +
        buffer.length.toString() +
        "t: " +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString() +
        "currentOffset: " +
        currentOffset.toString());
    String page;
    if ((currentptr - tailptr < pageCharacters) &&
        (currentOffset >= insertLength)) {
      print("leerIzda - if1");
      await escribirIzda();
    }
    if (currentOffset + currentptr >= pageCharacters) {
      print("leerIzda - if2");
      if (lastDirection == "derecha") {
        page = buffer.substring(
            currentptr - 2 * pageCharacters, currentptr - pageCharacters);
        currentptr -= 2 * pageCharacters;
      } else {
        print("leerIzda - ELSE normal");
        if (currentOffset - pageCharacters < 0) {
          print("leerIzda - if3");
          page = buffer.substring(0, currentptr);
          currentptr = 0;
        } else {
          page = buffer.substring(currentptr - pageCharacters, currentptr);
          currentptr -= pageCharacters;
        }
      }
    } else {
      page = buffer.substring(currentptr, pageCharacters);
    }
    print(" END leerIzda: buffer -> " +
        buffer.length.toString() +
        "t: " +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
    lastDirection = "izquierda";
    return page;
  }

  void borrarIzda() {
    print("BEGIN borrarIzda t:" +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
    buffer = buffer.substring(tailptr + insertLength, headptr);
    tailptr = 0;
    currentptr -= insertLength;
    currentOffset += insertLength;
    headptr -= insertLength;
    print("END borrarIzda t:" +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
  }

  void borrarDcha() {
    print("BEGIN borrarDcha t:" +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
    buffer = buffer.substring(tailptr, headptr - pageCharacters * 6);
    tailptr = 0;
    currentptr -= insertLength;
    currentOffset += insertLength;
    headptr -= insertLength;
    print("END borrarIzda t:" +
        tailptr.toString() +
        " c:" +
        currentptr.toString() +
        " h:" +
        headptr.toString());
  }
}
