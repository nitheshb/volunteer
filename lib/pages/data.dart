import 'package:flutter/material.dart';

var pageList = [
  PageModel(
      imageUrl: "assets/illustration.png",
      title: "Holder",
      body: "EXPERIENCE WICKED PLAYLISTS",
      titleGradient: gradients[0]),
];

List<List<Color>> gradients = [
  [Color(0xFF9708CC), Color(0xFF43CBFF)],
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class PageModel {
  var imageUrl;
  var title;
  var body;
  List<Color> titleGradient = [];
  PageModel({this.imageUrl, this.title, this.body, this.titleGradient});
}
