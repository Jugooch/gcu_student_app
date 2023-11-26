import 'package:flutter/material.dart';

enum AppMode { light, dark }

class AppStyles {
  //lightMode Colors
  static const Color lightCardBackground = Color(0xFFF2F2F2);
  static const Color lightPrimary = Color(0xFF522498);
  static const Color lightPrimaryLight = Color(0xFF9747FF);
  static const Color lightPrimaryDark = Color(0xFF391A69);
  static const Color lightBlack = Color(0xFF090410);
  static const Color lightImageOverlay = Color(0x20391A69); // 20% opacity
  static const Color lightTextPrimary = Color(0xFF090410);
  static const Color lightTextSecondary = Color(0xFFFFFFFF);
  static const Color lightTextTertiary = Color(0xFF391A69);
  static const Color lightButtonTertiary = Color(0xFFC6C6C6);
  static const Color lightStudentIdBackground = Color(0xFFFFFFFF);
  static const Color lightNavIconInactive = Color(0xFFD5BDEF);
  static const Color lightNavIconActive = Color(0xFFFFFFFF);
  static const Color lightInactiveIcon = Color(0xFF8D8D8D);
  static const Color lightBackground = Colors.white;

  //darkMode Colors
  static const Color darkCardBackground = Color(0xFF373F47);
  static const Color darkPrimary = Color(0xFF522498);
  static const Color darkPrimaryLight = Color(0xFF9747FF);
  static const Color darkPrimaryDark = Color(0xFF391A69);
  static const Color darkBlack = Color(0xFF090410);
  static const Color darkImageOverlay = Color(0x66391A69); // 20% Opacity
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF090410);
  static const Color darkTextTertiary = Color(0xFFFFFFFF);
  static const Color darkButtonTertiary = Color(0xFF23292E);
  static const Color darkStudentIdBackground = Color(0xFF373F47);
  static const Color darkNavIconInactive = Color(0xFFD5BDEF);
  static const Color darkNavIconActive = Color(0xFFFFFFFF);
  static const Color darkInactiveIcon = Color(0xFF8D8D8D);
  static const Color darkBackground = Color(0xFF23292E);

  static Color getBackground(AppMode mode){
    return mode == AppMode.light ? lightBackground : darkBackground;
  }

  static Color getCardBackground(AppMode mode) {
    return mode == AppMode.light ? lightCardBackground : darkCardBackground;
  }

  static Color getPrimary(AppMode mode) {
    return mode == AppMode.light ? lightPrimary : darkPrimary;
  }

  static Color getPrimaryLight(AppMode mode) {
    return mode == AppMode.light ? lightPrimaryLight : darkPrimaryLight;
  }

  static Color getPrimaryDark(AppMode mode) {
    return mode == AppMode.light ? lightPrimaryDark : darkPrimaryDark;
  }

  static Color getBlack(AppMode mode) {
    return mode == AppMode.light ? lightBlack : darkBlack;
  }

  static Color getImageOverlay(AppMode mode) {
    return mode == AppMode.light ? lightImageOverlay : darkImageOverlay;
  }

  static Color getTextPrimary(AppMode mode) {
    return mode == AppMode.light ? lightTextPrimary : darkTextPrimary;
  }

  static Color getTextSecondary(AppMode mode) {
    return mode == AppMode.light ? lightTextSecondary : darkTextSecondary;
  }

  static Color getTextTertiary(AppMode mode) {
    return mode == AppMode.light ? lightTextTertiary : darkTextTertiary;
  }

  static Color getButtonTertiary(AppMode mode) {
    return mode == AppMode.light ? lightButtonTertiary : darkButtonTertiary;
  }

  static Color getStudentIdBackground(AppMode mode) {
    return mode == AppMode.light ? lightStudentIdBackground : darkStudentIdBackground;
  }

  static Color getNavIconInactive(AppMode mode) {
    return mode == AppMode.light ? lightNavIconInactive : darkNavIconInactive;
  }

  static Color getNavIconActive(AppMode mode) {
    return mode == AppMode.light ? lightNavIconActive : darkNavIconActive;
  }

  static Color getInactiveIcon(AppMode mode) {
    return mode == AppMode.light ? lightInactiveIcon : darkInactiveIcon;
  }
}