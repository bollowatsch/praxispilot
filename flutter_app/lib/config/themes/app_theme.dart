import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color lightPrimary = Color(0xFF6B9080);
  static const Color lightSecondary = Color(0xFFA7C5EB);
  static const Color lightAccent = Color(0xFFE8B86D);

  static const Color lightBackground = Color(0xFFF9F7F4);
  static const Color lightSurface = Color(0xFFFDFDFB);

  static const Color lightTextPrimary = Color(0xFF3A4F41);
  static const Color lightTextSecondary = Color(0xFF8B9D83);

  static const Color lightSuccess = Color(0xFF588157);
  static const Color lightWarning = Color(0xFFDBAE58);
  static const Color lightError = Color(0xFFB85C4F);
  static const Color lightInfo = Color(0xFF7FA6C8);

  static const Color darkPrimary = Color(0xFF8AB4A0);
  static const Color darkSecondary = Color(0xFFB8D4F7);
  static const Color darkAccent = Color(0xFFF0C878);

  static const Color darkBackground = Color(0xFF1C2521);
  static const Color darkSurface = Color(0xFF2A3530);
  static const Color darkSurfaceVariant = Color(0xFF364239);

  static const Color darkTextPrimary = Color(0xFFE8EDE9);
  static const Color darkTextSecondary = Color(0xFFA8B9A3);

  static const Color darkSuccess = Color(0xFF7AA876);
  static const Color darkWarning = Color(0xFFE8C86D);
  static const Color darkError = Color(0xFFE89580);
  static const Color darkInfo = Color(0xFF9BC5E8);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE8F2EE),
      onPrimaryContainer: lightTextPrimary,

      secondary: lightSecondary,
      onSecondary: lightTextPrimary,
      secondaryContainer: Color(0xFFE8F4F8),
      onSecondaryContainer: lightTextPrimary,

      tertiary: lightAccent,
      onTertiary: lightTextPrimary,
      tertiaryContainer: Color(0xFFFFF9E6),
      onTertiaryContainer: lightTextPrimary,

      surface: lightSurface,
      onSurface: lightTextPrimary,
      surfaceContainerHighest: Color(0xFFF0F0ED),
      onSurfaceVariant: lightTextSecondary,

      error: lightError,
      onError: Colors.white,
      errorContainer: Color(0xFFFDE8E6),
      onErrorContainer: lightError,

      outline: Color(0xFFE5E5E0),
      outlineVariant: Color(0xFFF0F0ED),

      shadow: Colors.black.withValues(alpha: 0.08),
      scrim: Colors.black.withValues(alpha: 0.5),
    ),

    scaffoldBackgroundColor: lightBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    cardTheme: CardTheme(
      color: lightSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),

    textTheme: _buildTextTheme(
      primaryColor: lightPrimary,
      textColor: lightTextPrimary,
      secondaryTextColor: lightTextSecondary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFE5E5E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFE5E5E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightError, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: lightTextSecondary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightAccent,
        foregroundColor: lightTextPrimary,
        elevation: 2,
        shadowColor: lightAccent.withValues(alpha: 0.3),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimary,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimary,
        side: BorderSide(color: lightPrimary),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightAccent,
      foregroundColor: lightTextPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: lightPrimary,
      unselectedItemColor: lightTextSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightSurface,
      indicatorColor: Color(0xFFE8F2EE),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: lightPrimary,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: lightTextSecondary,
        );
      }),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFFE8F2EE),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: lightPrimary,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerTheme: DividerThemeData(
      color: Color(0xFFE5E5E0),
      thickness: 1,
      space: 1,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: lightSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: lightTextPrimary,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: darkBackground,
      primaryContainer: Color(0xFF3A5548),
      onPrimaryContainer: Color(0xFFD0E5DA),

      secondary: darkSecondary,
      onSecondary: darkBackground,
      secondaryContainer: Color(0xFF364758),
      onSecondaryContainer: Color(0xFFD9E7F7),

      tertiary: darkAccent,
      onTertiary: darkBackground,
      tertiaryContainer: Color(0xFF5D5238),
      onTertiaryContainer: Color(0xFFFFF4D9),

      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkSurfaceVariant,
      onSurfaceVariant: darkTextSecondary,

      error: darkError,
      onError: darkBackground,
      errorContainer: Color(0xFF5D3C36),
      onErrorContainer: Color(0xFFF7DDD9),

      outline: Color(0xFF4A564F),
      outlineVariant: Color(0xFF364239),

      shadow: Colors.black.withValues(alpha: 0.3),
      scrim: Colors.black.withValues(alpha: 0.7),
    ),

    scaffoldBackgroundColor: darkBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      iconTheme: IconThemeData(color: darkTextPrimary),
    ),

    cardTheme: CardTheme(
      color: darkSurface,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),

    textTheme: _buildTextTheme(
      primaryColor: darkPrimary,
      textColor: darkTextPrimary,
      secondaryTextColor: darkTextSecondary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF4A564F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF4A564F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkError, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: darkTextSecondary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkAccent,
        foregroundColor: darkBackground,
        elevation: 2,
        shadowColor: darkAccent.withValues(alpha: 0.3),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimary,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimary,
        side: BorderSide(color: darkPrimary),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkAccent,
      foregroundColor: darkBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: darkPrimary,
      unselectedItemColor: darkTextSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkSurface,
      indicatorColor: Color(0xFF3A5548),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: darkPrimary,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: darkTextSecondary,
        );
      }),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF3A5548),
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkPrimary,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    dividerTheme: DividerThemeData(
      color: Color(0xFF4A564F),
      thickness: 1,
      space: 1,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: darkSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkSurfaceVariant,
      contentTextStyle: GoogleFonts.inter(color: darkTextPrimary, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    drawerTheme: DrawerThemeData(backgroundColor: darkSurface, elevation: 8),

    listTileTheme: ListTileThemeData(
      textColor: darkTextPrimary,
      iconColor: darkTextSecondary,
      selectedColor: darkPrimary,
      selectedTileColor: Color(0xFF3A5548),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),

      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.5,
      ),

      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }

  static Color getSuccessColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightSuccess
        : darkSuccess;
  }

  static Color getWarningColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightWarning
        : darkWarning;
  }

  static Color getInfoColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightInfo
        : darkInfo;
  }

  static BoxDecoration successDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? Color(0xFF3A5548) : Color(0xFFE8F2EE),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: getSuccessColor(context).withValues(alpha: 0.3),
      ),
    );
  }

  static BoxDecoration warningDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? Color(0xFF5D5238) : Color(0xFFFFF9E6),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: getWarningColor(context).withValues(alpha: 0.3),
      ),
    );
  }

  static BoxDecoration errorDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? Color(0xFF5D3C36) : Color(0xFFFDE8E6),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
      ),
    );
  }

  static BoxDecoration infoDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? Color(0xFF364758) : Color(0xFFE8F4F8),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: getInfoColor(context).withValues(alpha: 0.3)),
    );
  }
}

extension ThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get success => AppTheme.getSuccessColor(this);
  Color get warning => AppTheme.getWarningColor(this);
  Color get info => AppTheme.getInfoColor(this);
}
