import 'package:flutter/widgets.dart';

/// Escala de espaçamentos 4-pt (coesa com Material & design moderno).
/// Use as constantes para tamanhos e os helpers para EdgeInsets/gaps.
class AppSpacing {
  // ====== base scale (4-pt) ======
  static const double xxs = 2; // toques mínimos, hairlines
  static const double xs = 4; // micro espaçamentos
  static const double sm = 8; // espaçamento curto
  static const double md = 12; // entre elementos correlatos
  static const double lg = 16; // blocos e grids
  static const double xl = 20; // seções
  static const double xxl = 24; // seções maiores
  static const double xxxl = 32; // respiro generoso
  static const double quad = 40; // hero/headers

  // ====== paddings helpers ======
  static EdgeInsets all(double v) => EdgeInsets.all(v);
  static EdgeInsets symmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  static EdgeInsets only({
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) => EdgeInsets.only(left: l, top: t, right: r, bottom: b);

  // Presets comuns
  static EdgeInsets get pCard => all(lg); // 16
  static EdgeInsets get pSection =>
      symmetric(v: xxl, h: xl); // 24 vertical, 20 horizontal
  static EdgeInsets get pListItem => symmetric(v: sm, h: lg); // 8 x 16

  // ====== gaps (SizedBox) ======
  static SizedBox gap(double v) => SizedBox(height: v, width: v);
  static SizedBox get gapXs => const SizedBox.square(dimension: xs);
  static SizedBox get gapSm => const SizedBox.square(dimension: sm);
  static SizedBox get gapMd => const SizedBox.square(dimension: md);
  static SizedBox get gapLg => const SizedBox.square(dimension: lg);
  static SizedBox get gapXl => const SizedBox.square(dimension: xl);
  static SizedBox get gapXxl => const SizedBox.square(dimension: xxl);

  // ====== radius ======
  static const double rSm = 8;
  static const double rMd = 12;
  static const double rLg = 16;
  static const double rXl = 20;
  static BorderRadius br(double r) => BorderRadius.circular(r);
  static BorderRadius get brSm => BorderRadius.circular(rSm);
  static BorderRadius get brMd => BorderRadius.circular(rMd);
  static BorderRadius get brLg => BorderRadius.circular(rLg);
  static BorderRadius get brXl => BorderRadius.circular(rXl);
}
