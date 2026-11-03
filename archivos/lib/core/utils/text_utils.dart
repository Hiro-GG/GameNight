// Para que "codigo" encuentre "Código Secreto" y "loteria" a "Lotería".
String normalizar(String texto) {
  return texto
      .toLowerCase()
      .trim()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n')
      .replaceAll('¡', '')
      .replaceAll('!', '');
}
