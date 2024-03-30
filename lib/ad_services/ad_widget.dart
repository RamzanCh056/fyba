// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:app/consolePrintWithColor.dart';
import 'package:flutter/material.dart';


Widget adView() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adviewtype',
          (int viewid) => IFrameElement()

            ..style.width = '130%'
            ..style.height = '150%'

            ..style.overflow='hidden'
            ..srcdoc = '''
         <script type="text/javascript">
	atOptions = {
		'key' : 'b4c33f25d78690ea6c90fa25d88efbd3',
		'format' : 'iframe',
		'height' : 600,
		'width' : 160,
		'params' : {}
	};
	document.write('<scr' + 'ipt type="text/javascript" src="//televisionjitter.com/b4c33f25d78690ea6c90fa25d88efbd3/invoke.js"></scr' + 'ipt>');
</script>
          '''
        ..style.border = 'none');

  return HtmlElementView(
    viewType: 'adviewtype'
  );
}


Widget adsenseAdView() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adviewtypeAdsense',
          (int viewid) => IFrameElement()
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.overflow='hidden'
            ..srcdoc = '''  
        <!DOCTYPE html>  
 <html> <head> </head> <body>             
                     <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7865429989298242"
     crossorigin="anonymous"></script>
<!-- newbanner -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-7865429989298242"
     data-ad-slot="6961648141"
     
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
                     </body>  
 </html>           '''
            ..style.border = 'none');


  return SizedBox(
    // height: 212.0,
    // width: 105.0,
    child: HtmlElementView(
        viewType: 'adviewtypeAdsense'
    ),
  );
}

Widget adsenseAdView1() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adviewtypeAdsense1',
          (int viewid) => IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
            ..style.overflow='hidden'
        ..srcdoc = '''  
        <!DOCTYPE html>  
 <html> <head> </head> <body>             
                    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7865429989298242"
     crossorigin="anonymous"></script>
<!-- banner -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-7865429989298242"
     data-ad-slot="2674918778"
     
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
                     </body>  
 </html>           '''
        ..style.border = 'none');


  return SizedBox(
    // height: 180.0,
    // width: 91.0,
    child: HtmlElementView(
        viewType: 'adviewtypeAdsense1'
    ),
  );
}


// Widget adView1() {
//   // ignore: undefined_prefixed_name
//   ui.platformViewRegistry.registerViewFactory(
//       'adviewtype1',
//           (int viewid) => IFrameElement()
//         ..width = '300'
//         ..height = '160'
//
//             ..style.border='none'
//             ..style.overflow='hidden'
//             ..srcdoc = '''
//
// <script type="text/javascript">
// 	atOptions = {
// 		'key' : '61f7cea1fe2d4d4647ff0e3e0f20fb47',
// 		'format' : 'iframe',
// 		'height' : 300,
// 		'width' : 160,
// 		'params' : {}
// 	};
// 	document.write('<scr' + 'ipt type="text/javascript" src="//www.topcreativeformat.com/61f7cea1fe2d4d4647ff0e3e0f20fb47/invoke.js"></scr' + 'ipt>');
// </script>
//             '''
//         ..style.border = 'none'
//   );
//
//   printLog(IFrameElement().src);
//
//   return SizedBox(
//     height: 100.0,
//     width: 320.0,
//     child: HtmlElementView(
//         viewType: 'adviewtype1'
//     ),
//   );
// }

Widget adView1() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'adviewtype1',
        (int viewid) => IFrameElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..srcdoc = '''
        <html>
          <head>
            <style>
              body {
                margin: 0; /* Remove default margin of body */
              }
            </style>
          </head>
          <body>
            <script type="text/javascript">
              var atOptions = {
                'key' : '61f7cea1fe2d4d4647ff0e3e0f20fb47',
                'format' : 'iframe',
                'height' : 300,
                'width' : 160,
                'params' : {}
              };
              document.write('<scr' + 'ipt type="text/javascript" src="//www.topcreativeformat.com/61f7cea1fe2d4d4647ff0e3e0f20fb47/invoke.js"></scr' + 'ipt>');
            </script>
          </body>
        </html>
      '''
      ..style.border = 'none'
      ..style.overflow = 'hidden', // Add overflow: hidden
  );

  return HtmlElementView(
    viewType: 'adviewtype1',
  );
}

Widget bannerAdView() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'bannerAd',
          (int viewid) => IFrameElement()
            ..style.overflow='hidden'
        ..srcdoc =
            '''
            <script type='text/javascript' src='//pl20854130.highcpmrevenuegate.com/3c/e5/1d/3ce51d534e8bfbf42ff15989507540ff.js'></script>'''
//         '''
//
//             <script async="async" data-cfasync="false" src="//pl20852337.highcpmrevenuegate.com/829c318188ffde9bac4464d5bafe7f97/invoke.js"></script>
//
// <div id="container-829c318188ffde9bac4464d5bafe7f97"></div>
//             '''
        ..style.border = 'none'
  );

  printLog(IFrameElement().src);

  return SizedBox(
    // height: 100.0,
    // width: 320.0,
    child: HtmlElementView(
        viewType: 'bannerAd'
    ),
  );
}