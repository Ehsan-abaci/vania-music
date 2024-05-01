import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<PaletteGenerator> paletteGenerator(String imageUrl) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
    NetworkImage(imageUrl),
    maximumColorCount: 1,
  );
  return paletteGenerator;
}
