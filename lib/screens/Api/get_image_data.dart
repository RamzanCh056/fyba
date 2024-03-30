import 'dart:convert';
import 'package:flutter/material.dart';
import '/constants/exports.dart';
import 'package:http/http.dart' as https;
import '../../widgets/buttons/action_button_widget.dart';
import '../../widgets/responsive_widget.dart';
import '../Admin/admin_homescreen.dart';
import '../components/neon_tab_button.dart';
import '../components/team_builder/team_builder_main_screen.dart';

class ApiData extends StatefulWidget {
  const ApiData({super.key});
  @override
  State<ApiData> createState() => _ApiDataState();
}

class _ApiDataState extends State<ApiData> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  Color caughtColor = Colors.red;





  ///  This work is done by Salih Hayat
  ///
  ///
  /// Following are the variables which I defined for draggable
  ///
  var chosenTeam= [];  /// Chosen team list is the list of player which were chosen
  List<int> chosenTeamIndexes=[];  /// Here we can store indexes of each player in
  /// order to drag player at any index on the target drag




  var champ = [];
  var setData = [];
  bool isLoading = true;
  getNameData() async {
    var headers = {
      'Authorization':
          'Bearer KFZe9qt2lNlDOpNNUJnv0r6uV1Q4nBQsK6M2QiZIGtPPi0ckTK5kVntVquiTjOhf'
      // "Access-Control-Allow-Origin: *"
    };
    var request = https.Request(
        'GET',
        Uri.parse(
            'https://raw.communitydragon.org/latest/cdragon/tft/en_us.json'));
    request.body = '''''';
    request.headers.addAll(headers);
    https.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      setData = body['setData'];
      champ = setData[0]['champions'];
      // for (int i = 0; i < setData.length; i++) {
      //   champ = setData[i]['champions'];
      // }
      // ;
      print("my chap lengt ==${champ.length}");

      //champ = setData['champions'];
      // print('SetData=$setData');  print(

      setState(() {
        champ;
        // chosenTeam = champ;
      });
      setState(() {
        isLoading = false;
      });
      print("list item=$champ");
    } else {
      print(response.reasonPhrase);
      print('error');
      setState(() {
        isLoading = false;
      });
    }
  }

  String text = "drag here";

  Map<String, dynamic>? limit;

  void initState() {
    super.initState();

    getNameData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backImage.png',
                  ),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ResponsiveWidget.isWebScreen(context)
                      ? Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// menu icon
                                IconButton(
                                  onPressed: () {},
                                  icon: MenuIcon(),
                                ),
                                SizedBox(width: 12.0),

                                /// premium button
                                // PremiumButton(onTap: () {}),
                                Spacer(),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Color(0xffFF2D2D),
                                  onPressed: () {},
                                  child: Text(
                                    'Back',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Color(0xffF48B19),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminHomeScreen()));
                                  },
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Color(0xff00ABDE),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamBuilderScreen()));
                                  },
                                  child: Text(
                                    'Create Guide',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Color(0xffF48B19),
                                  onPressed: () {},
                                  child: Text(
                                    'Share',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  color: Color(0xffFF2D2D),
                                  onPressed: () {},
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Spacer(),

                                /// actions icons
                                ActionButtonWidget(
                                    onTap: () {}, iconPath: AppIcons.chat),
                                SizedBox(width: 8),
                                ActionButtonWidget(
                                    onTap: () {}, iconPath: AppIcons.setting),
                                SizedBox(width: 8),
                                ActionButtonWidget(
                                  onTap: () {},
                                  iconPath: AppIcons.bell,
                                  isNotify: true,
                                ),
                                SizedBox(width: 8),

                                /// user name and image
                                // Text('Madeline Goldner',
                                //   style: poppinsRegular.copyWith(
                                //     fontSize: 16,
                                //     color: AppColors.whiteColor,
                                //   ),
                                // ),
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage:
                                      AssetImage(AppImages.userImage),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(AppIcons.dotVert),
                                ),
                              ],
                            ),
                            Text(
                              'Team Builder',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            Text(
                              'Drag & Drop players to build your best team,',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15),
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    NeonTabButtonWidget(
                                      onTap: null,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffF48B19),
                                          Color(0xffF48B19).withOpacity(0.2),
                                          Color(0xffF48B19).withOpacity(0.0),
                                          Color(0xffF48B19).withOpacity(0.0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      btnHeight: 35,
                                      btnWidth:
                                          ResponsiveWidget.isWebScreen(context)
                                              ? width(context) * 0.11
                                              : ResponsiveWidget.isTabletScreen(
                                                      context)
                                                  ? width(context) * 0.2
                                                  : width(context) * 0.3,
                                      btnText: 'Synergy',
                                    ),
                                    Container(
                                      width: 200,
                                      // margin: const EdgeInsets.only(0),
                                      padding:
                                          ResponsiveWidget.isWebScreen(context)
                                              ? const EdgeInsets.symmetric(
                                                  horizontal: 20)
                                              : const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                      decoration:
                                          ImagePageBoxDecoration(context),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          Text(
                                            'Start building your camp',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'to see the synergies.',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [

                                    SizedBox(
                                      height: 200,
                                      width: 400,
                                      child: GridView.builder(
                                          // physics: ScrollPhysics(),
                                          // shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 6,
                                                  mainAxisExtent: 60,
                                                  crossAxisSpacing: 5,
                                                  mainAxisSpacing: 5),
                                          padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 10,
                                          ),
                                          itemCount: champ.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Expanded(
/*****************************************************************************8
 * Drag target  widget
 *******************************************************************************/

                                                  child: DragTarget(
                                                      onAccept: (data) {

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(chosenTeam.contains(data)|| chosenTeamIndexes.contains(index)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add

                                                          chosenTeam.add(data);
                                                          chosenTeamIndexes.add(index);

                                                          setState(() {

                                                          });
                                                        }

                                                  }, builder: (
                                                    BuildContext context,
                                                    List<dynamic> accepted,
                                                    List<dynamic> rejected,
                                                  ) {
                                                        // print(text);

                                                    return Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        // child
                                                        /// Here I used chosen team indexes for reference if the player exist in team
                                                        /// We will show the icon of player else will show blank polygon icon
                                                        child: chosenTeamIndexes.contains(index)
                                                            ?  Image.network(
                                                                '${baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)]['icon'].toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                height: 60,
                                                                width: 60,
                                                                fit: BoxFit
                                                                    .fill):
                                                        Image.asset(
                                                            'assets/images/Polygon 7.png')

                                                        ,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    NeonTabButtonWidget(
                                      onTap: null,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffF48B19),
                                          Color(0xffF48B19).withOpacity(0.2),
                                          Color(0xffF48B19).withOpacity(0.0),
                                          Color(0xffF48B19).withOpacity(0.0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      btnHeight: 35,
                                      btnWidth:
                                          ResponsiveWidget.isWebScreen(context)
                                              ? width(context) * 0.11
                                              : ResponsiveWidget.isTabletScreen(
                                                      context)
                                                  ? width(context) * 0.2
                                                  : width(context) * 0.3,
                                      btnText: 'Core Champs',
                                    ),
                                    Container(
                                      width: 200,
                                      // margin: const EdgeInsets.only(0),
                                      padding:
                                          ResponsiveWidget.isWebScreen(context)
                                              ? const EdgeInsets.symmetric(
                                                  horizontal: 20)
                                              : const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                      decoration:
                                          ImagePageBoxDecoration(context),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                          ),
                                          Text(
                                            'Double click a champ on',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'field to add them as',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'core champion for the',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'team comp.',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 80,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 175,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 1, color: Color(0xffF48B19))),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        SizedBox(width: 12),
                                        Container(
                                          width: 220,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.search,
                                                  color: Colors.grey),
                                              fillColor: Color(0xff191741),
                                              filled: true,
                                              hintText: 'Search champion',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0)),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor,
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color(0xff191741),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Color(0xffF48B19))),
                                          child: Text(
                                            'A-Z',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(0xff191741),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Z-A',
                                            style: TextStyle(
                                                color: Colors.grey.shade300),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(0xff191741),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset(
                                                  "assets/images/Layer 2.png"),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Any Synergy',
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Clear Filter",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        Spacer(),
                                        Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color(0xff191741),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                MaterialButton(
                                                    height: 35,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    color: Color(0xffF48B19),
                                                    onPressed: () {

                                                    },
                                                    child: Text(
                                                      'Champions',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                MaterialButton(
                                                    height: 35,
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Items',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ))
                                              ],
                                            )),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                    isLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : GridView.builder(
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 8,
                                                    mainAxisExtent: 85,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5),
                                            padding: const EdgeInsets.only(
                                              top: 15,
                                              bottom: 10,
                                            ),
                                            itemCount: champ.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Expanded(
/*****************************************************************************8
* Draggable  widget
*******************************************************************************/

                                                    child: Draggable(
                                                      data: champ[index],
                                                      onDraggableCanceled:
                                                          (velocity, offset) {},
                                                      feedback: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                            baseUrl + champ[index]
                                                            // ['ability']
                                                            ['icon'].toString().toLowerCase().replaceAll('.dds', '.png'),
                                                            height: 70,
                                                            width: 70,
                                                            fit: BoxFit.fill),
                                                      ),
                                                      child: Container(
                                                          child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child: Image.network(
                                                                baseUrl + champ[index]
                                                                // ['ability']
                                                                ['icon'].toString().toLowerCase().replaceAll('.dds', '.png'),
                                                                height: 60,
                                                                width: 60,
                                                                fit: BoxFit
                                                                    .fill),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Text(
                                                            champ[index]
                                                                        // [
                                                                        // 'ability']
                                                                    ['name'] ??
                                                                '',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /// menu icon
                                    IconButton(
                                      onPressed: () {
                                        getNameData();
                                      },
                                      icon: MenuIcon(),
                                    ),
                                    SizedBox(width: 12.0),

                                    /// premium button
                                    // PremiumButton(onTap: () {}),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      color: Color(0xffFF2D2D),
                                      onPressed: () {},
                                      child: Text(
                                        'Back',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      color: Color(0xffF48B19),
                                      onPressed: () {},
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      color: Color(0xff00ABDE),
                                      onPressed: () {},
                                      child: Text(
                                        'Create Guide',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      color: Color(0xffF48B19),
                                      onPressed: () {},
                                      child: Text(
                                        'Share',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      color: Color(0xffFF2D2D),
                                      onPressed: () {},
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),

                                    /// actions icons
                                    ActionButtonWidget(
                                        onTap: () {}, iconPath: AppIcons.chat),
                                    SizedBox(width: 8),
                                    ActionButtonWidget(
                                        onTap: () {},
                                        iconPath: AppIcons.setting),
                                    SizedBox(width: 8),
                                    ActionButtonWidget(
                                      onTap: () {},
                                      iconPath: AppIcons.bell,
                                      isNotify: true,
                                    ),
                                    SizedBox(width: 8),

                                    CircleAvatar(
                                      radius: 22,
                                      backgroundImage:
                                          AssetImage(AppImages.userImage),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(AppIcons.dotVert),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Center(
                                child: Text(
                                  'Team Builder',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'Drag & Drop players to build your best team,',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox(
                                      height: 550,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            // Draggable Wid

                                            GridView.builder(
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 4,
                                                        mainAxisExtent: 100,
                                                        crossAxisSpacing: 5,
                                                        mainAxisSpacing: 5),
                                                padding: const EdgeInsets.only(
                                                  top: 15,
                                                  bottom: 10,
                                                ),
                                                itemCount: champ.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Expanded(
                                                        child: DragTarget(
                                                            onAccept: (data) {
                                                          //caughtColor = color;
                                                          text = champ[index]
                                                          // [
                                                          //             'ability']
                                                                  ['icon']
                                                              .toString();
                                                          // setState(() {
                                                          //   champ.remove(data);
                                                          //
                                                          // });
                                                        }, builder: (
                                                          BuildContext context,
                                                          List<dynamic>
                                                              accepted,
                                                          List<dynamic>
                                                              rejected,
                                                        ) {
                                                          return Center(
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              child: text ==
                                                                      "drag here"
                                                                  ? Image.asset(
                                                                      'assets/images/Polygon 7.png')
                                                                  : Image.network(
                                                                      '${baseUrl + text.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                      height:
                                                                          60,
                                                                      width: 60,
                                                                      fit: BoxFit
                                                                          .fill),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                      SizedBox(
                                                        height: 12,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                            Container(
                                              height: 300,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Color(0xffF48B19))),
                                              child: GridView.builder(
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 4,
                                                          mainAxisExtent: 90,
                                                          crossAxisSpacing: 5,
                                                          mainAxisSpacing: 5),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 10,
                                                  ),
                                                  itemCount: champ.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        Expanded(
                                                          child: Draggable(
                                                            data: champ,
                                                            child: Container(
                                                                child: Column(
                                                              children: [
                                                                InkWell(
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child: Image.network(
                                                                        '${baseUrl + champ[index]
                                                                        // ['ability']
                                                                        ['icon'].toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                        fit: BoxFit
                                                                            .fill),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        5),
                                                                Text(
                                                                  champ[index]
                                                                  // ['ability']
                                                                          [
                                                                          'name'] ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            )),
                                                            onDraggableCanceled:
                                                                (velocity,
                                                                    offset) {},
                                                            feedback:
                                                                ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              child: Image.network(
                                                                  '${baseUrl + champ[index]
                                                                  // ['ability']
                                                                  ['icon'].toString().toLowerCase().replaceAll('.dds', '.png')}',
                                                                  height: 70,
                                                                  width: 70,
                                                                  fit: BoxFit
                                                                      .fill),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
