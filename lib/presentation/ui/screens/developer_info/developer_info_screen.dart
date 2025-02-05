import 'package:devpaul_todo_app/presentation/ui/screens/developer_info/social_buttons.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/custom_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInformationScreen extends StatelessWidget {
  static const String name = 'developer_information_screen';
  const DeveloperInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAssetImage(path: 'assets/logo.png', height: 125),
              _titleText('CDA Panamericana App'),
              FutureBuilder(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Version: ${snapshot.data}');
                  }

                  return const CircularProgressIndicator.adaptive();
                },
              ),
              const SizedBox(height: 48),
              _titleText('Developer information'),
              const Text('Paul Realpe'),
              const LinkText(url: 'https://devpaul.pro'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: 156,
                height: 156,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/devpaul_logo.png'),
                  ),
                ),
              ),
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Text _titleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
    );
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

class LinkText extends StatelessWidget {
  final String url;
  const LinkText({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
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
      child: Text(
        url,
        style: TextStyle(
          color: colors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  /// Muestra un SnackBar con el mensaje proporcionado
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
