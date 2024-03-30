



import 'package:url_launcher/url_launcher.dart';

class RiotSignIn{


// Define constants for your client ID and redirect URI, these should be obtained 
// when you register your application with Riot.
  static const String clientId = 'your_client_id';
  static const String redirectUri = 'your_redirect_uri';
  static const String rsoAuthorizeEndpoint = 'https://auth.riotgames.com/authorize';
  static const String responseType = 'code';
  static const List<String> scopes = ['openid']; // Add other scopes as needed.

// Prepare the authorization URL
  String _prepareAuthorizationUrl() {
    final scopeStr = Uri.encodeComponent(scopes.join(' '));

    return '$rsoAuthorizeEndpoint?client_id=$clientId&response_type=$responseType&redirect_uri=$redirectUri&scope=$scopeStr';
  }

// Call this method when you want to send the user to RSO login page
  Future<void> _redirectToRso() async {
    final url = _prepareAuthorizationUrl();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch the RSO URL');
    }
  }
  
  
}