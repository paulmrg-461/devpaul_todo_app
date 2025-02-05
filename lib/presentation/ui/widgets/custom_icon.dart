import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Asegúrate de importar flutter_svg
import 'package:url_launcher/url_launcher.dart';

typedef SingleSelectCallback = void Function(String selectedItem);

class CustomIcon extends StatelessWidget {
  final String path;
  final String label;
  final double width;
  final double height;
  final String url;

  const CustomIcon({
    super.key,
    required this.path,
    required this.url,
    required this.label,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final SvgPicture svgPicture = SvgPicture.asset(
      path,
      semanticsLabel: label,
      width: width,
      height: height,
    );

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 13, 143, 218).withOpacity(0.25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () async {
          if (!_isValidUrl(url)) {
            _showSnackBar(context, 'URL inválida: $url');
            return;
          }

          final Uri uri = Uri.parse(url);
          try {
            if (await canLaunchUrl(uri)) {
              final bool launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              if (!launched) {
                _showSnackBar(context, 'No se pudo abrir la URL: $url');
              }
            } else {
              _showSnackBar(context, 'No se pudo abrir la URL: $url');
            }
          } on FormatException catch (_) {
            _showSnackBar(context, 'Formato de URL inválido.');
          } catch (e) {
            _showSnackBar(context, 'Error al intentar abrir la URL.');
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.transparent,
          ),
          child: svgPicture,
        ),
      ),
    );
  }

  /// Valida que la URL sea válida y utilice un esquema soportado
  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  /// Muestra un SnackBar con el mensaje proporcionado
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
