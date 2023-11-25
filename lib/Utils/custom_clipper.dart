
import 'package:flutter/material.dart';

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    
    // Clip path'i başlangıç noktasına taşı
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    
    // Sağ kenardaki çıkıntı
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.75, size.height * 0.6);
    
    // Orta çıkıntı (iki yatay çizgi arasındaki boşluk)
    path.lineTo(size.width * 0.25, size.height * 0.6);
    path.lineTo(size.width * 0.25, size.height);
    
    // Sol kenar
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
