import 'dart:html' as html;

import 'package:flutter/material.dart';
import '../../ad_services/ad_widget.dart';
import '/widgets/responsive_widget.dart';

import '../../constants/exports.dart';

import 'dart:ui_web' as ui;

String adUnitCode = """  
<script type="text/javascript">
	atOptions = {
		'key' : 'd46124dde2b0d839b1b77a33f7d0c83a',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
	document.write('<scr' + 'ipt type="text/javascript" src="//www.profitablecreativeformat.com/d46124dde2b0d839b1b77a33f7d0c83a/invoke.js"></scr' + 'ipt>');
</script>
""";

String adUnit2="""
<script type="text/javascript">
	atOptions = {
		'key' : '329577ea01d85209e09a95839be6b6a8',
		'format' : 'iframe',
		'height' : 300,
		'width' : 160,
		'params' : {}
	};
	document.write('<scr' + 'ipt type="text/javascript" src="//www.profitablecreativeformat.com/329577ea01d85209e09a95839be6b6a8/invoke.js"></scr' + 'ipt>');
</script>
""";

class RightSideWidget extends StatefulWidget {
  const RightSideWidget({Key? key}) : super(key: key);

  @override
  State<RightSideWidget> createState() => _RightSideWidgetState();
}

class _RightSideWidgetState extends State<RightSideWidget> {


  @override
  initState() {
    super.initState();

    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isWebScreen(context) ? Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height(context) / 2 ,
              width: width(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(AppImages.imageOne),
                  fit: BoxFit.fill,
                ),
              ),
              // child:
              // adView()
              // adsenseAdsView(),

            ),
            const SizedBox(height: 15),
            Container(
              height: height(context) / 1.5 ,
              width: width(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(AppImages.imageTwo),
                  fit: BoxFit.fill,
                ),

              ),
              // child:
                // adsenseAdView1()
              // adView1()
              // HtmlElementView(viewType: "iframeElement")
              // FlutterAdManagerWeb(adUnitCode: adUnit2,debug: true,),
            ),
          ],
        ),
      ),
    ) : ResponsiveWidget.isTabletScreen(context) ?  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageOne),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageTwo),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageOne),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: height(context) * 0.4,
          width: height(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(AppImages.imageTwo),
              fit: BoxFit.fill,
            ),
          ),

        ),

      ],
    );
  }
}



Widget adsenseAdsView() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adViewType',
          (int viewID) => html.IFrameElement()
        ..width = '320'
        ..height = '100'
        ..src =  '''  
        <!DOCTYPE html>  
 <html> <head> </head> <body>             
                     <script type="text/javascript">
	atOptions = {
		'key' : 'd46124dde2b0d839b1b77a33f7d0c83a',
		'format' : 'iframe',
		'height' : 250,
		'width' : 300,
		'params' : {}
	};
	document.write('<scr' + 'ipt type="text/javascript" src="//www.profitablecreativeformat.com/d46124dde2b0d839b1b77a33f7d0c83a/invoke.js"></scr' + 'ipt>');
</script>
                     
                     </body>  
 </html>           '''
        ..style.border = 'none');

  return SizedBox(
    height: 100.0,
    width: 320.0,
    child: HtmlElementView(
      viewType: 'adViewType',
    ),
  );
}