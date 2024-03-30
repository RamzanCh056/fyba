import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color caughtColor = Colors.red;
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  var champ = [];
  bool isLoading = true;
  getNameData() async {
    var headers = {
      'Authorization':
          'Bearer KFZe9qt2lNlDOpNNUJnv0r6uV1Q4nBQsK6M2QiZIGtPPi0ckTK5kVntVquiTjOhf'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://raw.communitydragon.org/latest/cdragon/tft/en_us.json'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      champ = body['items'];
      setState(() {
        champ;
      });
      setState(() {
        isLoading = false;
      });

      print("list item=$champ");
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
      });
    }
  }

  String? text = "drag here";
  void initState() {
    super.initState();
    getNameData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Draggable Widget
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 250,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12),
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 20,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Expanded(
                                child: Draggable(
                                    data: champ,
                                    child: Container(
                                        child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                              '${baseUrl + champ[index]['icon'].toString().toLowerCase().replaceAll('.dds', '.png')}',
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.fill),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          champ[index]['name'] ?? '',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 12),
                                        ),
                                      ],
                                    )),
                                    onDraggableCanceled: (velocity, offset) {},
                                    feedback: Container(
                                      width: 100,
                                      height: 100,
                                      color:
                                          Colors.orangeAccent.withOpacity(0.5),
                                      child: const Center(
                                        child: Text(
                                          'Box...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: DragTarget(
                                    onAccept: (data) {
                                  //caughtColor = color;
                                  text = champ[index]['icon'].toString();
                                  // setState(() {
                                  //
                                  // });
                                }, builder: (
                                  BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected,
                                ) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: accepted.isEmpty
                                        ? caughtColor
                                        : Colors.grey.shade200,
                                    child: Center(
                                      child: Image.network(
                                          text == "drag here"
                                              ? "https://c8.alamy.com/comp/F7632P/siddi-sidi-siddhi-sheedi-habshi-goma-dance-african-sidi-community-F7632P.jpg"
                                              : '${baseUrl + text.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                          fit: BoxFit.fill),
                                    ),
                                  );
                                }),
                              )
                            ],
                          );
                        }),


                  ],
                ),
              ),
            ),
    );
  }
}
