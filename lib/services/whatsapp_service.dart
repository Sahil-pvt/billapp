import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> shareOnWhatsApp(String message) async {
    final url = "https://wa.me/?text=$message";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
