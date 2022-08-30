import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
void main()
{
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      // ChangeNotifierProvider(
      // create: (context)=>increment(),
      // child:
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StoryPage2(),
      // ),
    );
  }
}




class StoryPage2 extends StatefulWidget {
  const StoryPage2({Key? key}) : super(key: key);

  @override
  State<StoryPage2> createState() => _StoryPage2State();
}

class _StoryPage2State extends State<StoryPage2> with SingleTickerProviderStateMixin
{


  List<Map<String,dynamic>> listOfUserStories = [

    {"stories":[
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
      ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
      ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
      ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",],"name":"@srinu"},
    {"stories":[
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
      ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    ],"name":"srinivas"},

    {"stories":[
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
      ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",],"name":"@srinu"},

    {"stories":[
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
      ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    ],"name":"@srinu"},
  ];

  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  int currentIndex = 0;
  int userCurrentIndex =0;
  var _initialiseVideoController;
  final PageController _pageController = PageController();
  final PageController _userPageController = PageController();

  @override
  void initState()
  {
    videoPlayerConstructor();
    super.initState();
  }

  @override
  void dispose()
  {
    _animationController.dispose();
    _videoPlayerController.dispose();
    _pageController.dispose();
    _userPageController.dispose();
    super.dispose();
  }


  void videoPlayerConstructor()
  {
    _animationController = AnimationController(vsync: this);
     _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][currentIndex]);
    _initialiseVideoController = _videoPlayerController.initialize().then((value){
      if(_videoPlayerController.value.isInitialized)
        {
          _animationController.duration = _videoPlayerController.value.duration;
          _videoPlayerController.play();
          _animationController.forward();
        }
    });

    _animationController.addStatusListener((status) {
      if(_animationController.isCompleted)
        {
          print("completed");
          _loadStoryFlow();
        }
    });

  }


  void _loadStoryFlow()
  {
    if(currentIndex<listOfUserStories[userCurrentIndex]["stories"].length-1)
      {
          setState(() {
            currentIndex+=1;
          });
          _loadStoryNavigate();
      }
    else if(currentIndex==listOfUserStories[userCurrentIndex]["stories"].length-1)
      {
         print("completedUser");
         print(userCurrentIndex);
         print(listOfUserStories.length);
         if(userCurrentIndex<listOfUserStories.length-1)
           {
             setState(() {
               userCurrentIndex+=1;
               currentIndex = 0;
             });
             _loadUserPageNavigate();
           }
         else{
           print("CompletedUserPage");
         }
      }
    else
      {

      }
  }

  void _loadStoryNavigate()
  {
    _animationController.stop();
    _animationController.reset();
    _videoPlayerController.dispose();
    _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][currentIndex]);
    _initialiseVideoController = _videoPlayerController.initialize().then((value) {
      if(_videoPlayerController.value.isInitialized)
        {
            _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
          _animationController.duration = _videoPlayerController.value.duration;
           _videoPlayerController.play();
           _animationController.forward();
        }
    });
  }

  void _loadUserPageNavigate()
  {
    _animationController.stop();
    _animationController.reset();
    _videoPlayerController.dispose();
    _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][currentIndex]);
    _initialiseVideoController = _videoPlayerController.initialize().then((value) {
      if(_videoPlayerController.value.isInitialized)
      {
        _userPageController.animateToPage(userCurrentIndex, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
        _animationController.duration = _videoPlayerController.value.duration;
        _videoPlayerController.play();
        _animationController.forward();
      }
    });
  }

  void userPageOnChanged(int index)
  {
    setState(() {
      userCurrentIndex = index;
      currentIndex = 0;
    });

    _animationController.stop();
    _animationController.reset();
    _videoPlayerController.dispose();
    _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][currentIndex]);
    _initialiseVideoController = _videoPlayerController.initialize().then((value) {
      if(_videoPlayerController.value.isInitialized)
      {
        _animationController.duration = _videoPlayerController.value.duration;
        _videoPlayerController.play();
        _animationController.forward();
      }
    });

  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        backgroundColor: Colors.black,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.black,
                            Colors.black
                          ]
                      )
                  ),
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index)
                    {
                      print("onChanged");
                      print(index);
                      userPageOnChanged(index);
                    },
                    controller: _userPageController,
                    children: List.generate(listOfUserStories.length, (index) => Stack(
                      children: [
                        GestureDetector(
                          onTapDown: (details)
                          {
                            final double screenWidth = MediaQuery.of(context).size.width;
                            final double dx = details.globalPosition.dx;
                            if(dx < screenWidth/3)
                            {
                              if(currentIndex>0)
                              {
                                setState(() {
                                  currentIndex-=1;
                                });
                                _loadStoryNavigate();
                              }
                            }
                            else if(dx > 2 * screenWidth/3)
                            {
                              if(currentIndex<listOfUserStories[userCurrentIndex]["stories"].length-1)
                              {
                                setState(() {
                                  currentIndex+=1;
                                });
                                _loadStoryNavigate();
                              }
                            }
                          },
                          child: PageView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            itemCount: listOfUserStories[userCurrentIndex]["stories"].length,
                            itemBuilder: (context,index)
                            {
                              return FutureBuilder(
                                  future: _initialiseVideoController,
                                  builder: (context, snapshot) {
                                    if(snapshot.connectionState==ConnectionState.done)
                                    {
                                      return VideoPlayer(_videoPlayerController);
                                    }
                                    else if(snapshot.hasError)
                                    {
                                      return Text("Error",style: TextStyle(color: Colors.white),);
                                    }
                                    else{
                                      return Center(
                                        child: Text("Loading....",style: TextStyle(color: Colors.white),),
                                      );
                                    }
                                  }
                              );
                            },
                          ),
                        ),
                        Positioned(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: List.generate(listOfUserStories[userCurrentIndex]["stories"].length, (index) => Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    height: 2.5,
                                    margin: EdgeInsets.only(left: 1,right: 1),
                                    color: Colors.grey.withOpacity(0.5),
                                  ))),
                            ),
                          )
                          ,top: 5,left: 0,right: 0,),
                        Positioned(child:
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(listOfUserStories[userCurrentIndex]["stories"].length, (index) {
                              return
                                index==currentIndex?AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      return Flexible(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 1,right: 1),
                                            width: (constraints.maxWidth/listOfUserStories[userCurrentIndex]["stories"].length-4) * _animationController.value,
                                            height: 2.5,
                                            color: Colors.white,
                                          ));
                                    }):Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: 2.5,
                                      margin: EdgeInsets.only(left: 1,right: 1),
                                      color: index>=currentIndex?Colors.white.withOpacity(0):Colors.white,
                                    ));
                            }
                            ),
                          ),
                        ),top: 5,left: 0,right: 0,),
                        Positioned(
                          top: 15,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.blue,
                              ),
                              SizedBox(width: 10,),
                              Text(listOfUserStories[userCurrentIndex]["name"].toString(),
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),),
                              SizedBox(width: 10,),
                              Text("6m",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.normal,fontSize: 12),),
                            ],
                          ),),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child:Container(
                              width: constraints.maxWidth,
                              height: 68,
                              padding: EdgeInsets.only(left: 5,right: 5),
                              color: Colors.black,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      padding: EdgeInsets.only(left: 18),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white70,
                                              width: 1
                                          ),
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.black
                                      ),
                                      child:  TextFormField(
                                          autofocus: false,
                                          validator: (value){
                                            if(value!=null)
                                            {
                                              return value;
                                            }
                                          },
                                          onChanged: (value){
                                            print("value = ");
                                            print(value);
                                            if(value.isEmpty && value!="")
                                            {
                                              _videoPlayerController.play();
                                              _animationController.forward();
                                            }
                                            else{
                                              _animationController.stop();
                                              _videoPlayerController.pause();
                                            }
                                          },
                                          cursorColor: Colors.white70,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              hintText: "send a comment",
                                              hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 15),
                                              border: InputBorder.none
                                          ),
                                        ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: (){
                                          if(_formKey.currentState!.validate()){
                                            _formKey.currentState!.save();
                                            _animationController.forward();
                                            _videoPlayerController.play();
                                          }
                                          else{
                                            _formKey.currentState!.reset();
                                            _animationController.forward();
                                            _videoPlayerController.play();
                                          }
                                        },
                                        icon: Icon(Icons.send,color: Colors.white,size: 33,),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: (){},
                                        icon: Icon(Icons.favorite_border,color: Colors.white,size: 33,),
                                      )
                                  ),
                                ],
                              ),
                            )
                        )

                      ],
                    )),
                  ),
                ),
              );
            }),
        ));
      }
  }




//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//
//
//   void postDetails()
//   async
//   {
//     var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5000/RegisterPage'));
//     request.fields.addAll({
//       'Username': 'srinivas',
//       'Password': '******',
//       'EmailID': 'srinivaskokku3372@gmail.com',
//       'MobileNumber': '123456789'
//     });
//     request.files.add(await http.MultipartFile.fromPath('ProfileImage', image.path));
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//
//
//   }
//   var image;
//   var file;
//
//   void selectImage()
//   async{
//     var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:4000'));
//     request.files.add(await http.MultipartFile.fromPath('avatar', image.path));
//
//   http.StreamedResponse response = await request.send();
//
//   if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
//   }
//     else {
//   print(response.reasonPhrase);
//   }
//
//   }
//
//   void pickImage()
//   async{
//     image = await ImagePicker().pickImage(source: ImageSource.camera);
//     print("image = ");
//     print(image);
//     if(image==null)
//       {
//         print("null");
//       }
//     else{
//       final imageres = File(image.path);
//       print(imageres);
//       setState(() {
//         file = imageres;
//         print("file = ");
//         print(image.path);
//         print(file.runtimeType);
//       });
//     }
//   }
//   var imageFile;
//
//
//   void getVideo()
//   async {
//     var request = http.MultipartRequest('GET', Uri.parse('http://10.0.2.2:4000'));
//     request.files.add(await http.MultipartFile.fromPath('avatar', image.path));
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//
//   }
//
//   void getImage()
//   async{
//     var request = http.MultipartRequest('GET', Uri.parse('http://10.0.2.2:5000/image'));
//
//   var result;
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       result = await response.stream.bytesToString();
//       print("result = ");
//       print(result);
//       setState(() {
//         imageFile = File(result.image);
//         print(imageFile);
//       });
//     }
//     else {
//     print(response.reasonPhrase);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               return Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 height: constraints.maxHeight,
//                 width: constraints.maxWidth,
//                 alignment: Alignment.center,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Form(
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 radius: 50,
//                                 backgroundColor: Colors.blue,
//                                 child: Stack(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 50,
//                                     child: image==null?SizedBox():Image.file(file),
//                                   ),
//                                   Positioned(child: CircleAvatar(
//                                     child: Icon(Icons.camera_alt_outlined,color: Colors.white,),
//                                     radius: 20,
//                                     backgroundColor: Colors.blue,
//                                   ),top: 60,right: 0,)
//                                 ],
//                                 ),
//                               ),
//
//                               // image==null?SizedBox():Image.file(file),
//                               Text("Instagram",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
//                               SizedBox(height: 40,),
//                               TextFormField(
//                                 cursorColor: Colors.black,
//                                 decoration: InputDecoration(
//                                     hintText: 'Email ',
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.blue,
//                                             width: 2
//                                         )
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.grey,
//                                             width: 2
//                                         )
//                                     )
//                                 ),
//                               ),
//                               SizedBox(height: 20,),
//                               TextFormField(
//                                 cursorColor: Colors.black,
//                                 decoration: InputDecoration(
//                                     hintText: 'Phone Number',
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.blue,
//                                             width: 2
//                                         )
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.grey,
//                                             width: 2
//                                         )
//                                     )
//                                 ),
//                               ),
//                               SizedBox(height: 20,),
//                               TextFormField(
//                                 cursorColor: Colors.black,
//                                 decoration: InputDecoration(
//                                     hintText: 'Username',
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.blue,
//                                             width: 2
//                                         )
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.grey,
//                                             width: 2
//                                         )
//                                     )
//                                 ),
//                               ),
//                               SizedBox(height: 20,),
//                               MaterialButton(onPressed: (){
//                                 print("REgister");
//                                 // selectImage();
//                                 // getVideo();
//                                 postDetails();
//                               },
//                                 minWidth: constraints.maxWidth,
//                                 child: Text("Register",style: TextStyle(color: Colors.white),),
//                                 height: 40,color: Colors.blue,),
//
//                               MaterialButton(onPressed: (){
//                                 print("upload");
//                                 pickImage();
//                               },
//                               child: Text("Upload"),)
//
//                             ],
//                           )
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }
//
//
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _globalKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//               return Container(
//                 width: constraints.maxWidth,
//                 height: constraints.maxHeight,
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Form(
//                       key: _globalKey,
//                       child: Column(
//                         children: [
//                           Text("Instagram",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
//                           SizedBox(height: 60,),
//                           TextFormField(
//                             cursorColor: Colors.black,
//                            decoration: InputDecoration(
//                              hintText: 'Email ',
//                              focusedBorder: OutlineInputBorder(
//                                borderSide: BorderSide(
//                                  color: Colors.blue,
//                                  width: 2
//                                )
//                              ),
//                              enabledBorder: OutlineInputBorder(
//                                borderSide: BorderSide(
//                                  color: Colors.grey,
//                                  width: 2
//                                )
//                              )
//                            ),
//                           ),
//                           SizedBox(height: 20,),
//                           TextFormField(
//                             decoration: InputDecoration(
//                                 hintText: 'Password',focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.blue,
//                                     width: 2
//                                 )
//                             ),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.grey,
//                                         width: 2
//                                     )
//                                 )
//                             ),
//                           ),
//                           SizedBox(height: 20,),
//                           MaterialButton(
//                             height: 40,
//                             minWidth: constraints.maxWidth,
//                             color: Colors.blue,
//                             onPressed: (){},
//                             child: Text("Log In",style: TextStyle(color: Colors.white),),
//                           ),
//                           TextButton(
//                             child: Text("Forgot Password?"),
//                             onPressed: (){},
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Don't have an account?"),
//                               SizedBox(width: 4,),
//                               InkWell(
//                                 onTap: (){},
//                                 child: Text("Sign Up",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 )
//               );
//           }),
//         )
//     );
//   }
// }


















// class StoryScreen extends StatefulWidget {
//   const StoryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<StoryScreen> createState() => _StoryScreenState();
// }
//
// class _StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin{
//
//   // List<String> listOfStories = [
//   //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//   //   ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//   //   "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
//   //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//   //   ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//   // ];
//
//   List<Map<String,dynamic>> listOfUserStories = [
//     {"stories":[
//       // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//       // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//       "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
//       // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//       // ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//     ],"name":"srinivas"},
//
//     {"stories":[
//       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//       ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
//       "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
//       "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
//       ,"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",],"name":"@srinu"}
//   ];
//
//   late VideoPlayerController _videoPlayerController;
//   late AnimationController _animationController;
//   late PageController _pageController;
//   late PageController _userPageController;
//   late Future<void> _initialisedVideoController;
//
//   var currentIndex = 0;
//   var userCurrentIndex = 0;
//   @override
//   void initState()
//   {
//     _pageController = PageController();
//     _userPageController = PageController();
//     _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][0]);
//     _animationController = AnimationController(vsync: this);
//
//     _initialisedVideoController = _videoPlayerController.initialize().then((value) {
//       if(_videoPlayerController.value.isInitialized)
//         {
//           _videoPlayerController.play();
//           _animationController.duration = _videoPlayerController.value.duration;
//           print("Duration = ");
//           _animationController.forward();
//           print(_videoPlayerController.value.duration);
//         }
//     });
//
//
//     _animationController.addStatusListener((status) async{
//       if(_animationController.isCompleted)
//       {
//         _animationController.stop();
//         _animationController.reset();
//         if(currentIndex<listOfUserStories[userCurrentIndex]["stories"].length-1)
//           {
//             setState(() {
//               currentIndex+=1;
//             });
//             _userLoadStory();
//           }
//         else
//         {
//           if(userCurrentIndex<listOfUserStories.length-1)
//             {
//               setState(() {
//                 userCurrentIndex+=1;
//                 currentIndex = 0;
//               });
//               _userPageController.animateToPage(userCurrentIndex, duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
//               _loadStory();
//             }
//         }
//       }
//     });
//
//     super.initState();
//   }
//
//   void dispose()
//   {
//     _animationController.dispose();
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child:
//        PageView.builder(
//          onPageChanged: (index)
//            {
//              print("index ||||||||||||||||||||||||||||||");
//              print(index);
//              setState(() {
//                currentIndex = 0;
//                userCurrentIndex = index;
//                _loadStory();
//              });
//            },
//          controller: _userPageController,
//           itemCount: listOfUserStories.length,
//            itemBuilder: (context, index) {
//          return Scaffold(
//            backgroundColor: Colors.black,
//            body: LayoutBuilder(
//                builder: (context, constraints) {
//                  return Container(
//                    width: constraints.maxWidth,
//                    height: constraints.maxHeight,
//                    decoration: BoxDecoration(
//                        gradient: LinearGradient(
//                            colors: [
//                              Colors.black,
//                              Colors.grey,
//                              Colors.black,
//                              Colors.grey,
//                              Colors.black,
//                              Colors.grey,
//                              Colors.black,
//                              Colors.black
//                            ],
//                            begin: Alignment.topRight,
//                            end: Alignment.topLeft
//                        )
//                    ),
//                    child: Stack(
//                      children: [
//                        GestureDetector(
//                          child: PageView.builder(
//                            physics: const NeverScrollableScrollPhysics(),
//                            controller: _pageController,
//                            itemBuilder: (context, index) {
//                              return FutureBuilder(
//                                  future: _initialisedVideoController,
//                                  builder: (context, snapshot) {
//                                    if(ConnectionState.done==snapshot.connectionState)
//                                    {
//                                      return AspectRatio(aspectRatio: _videoPlayerController.value.size.aspectRatio,
//                                        child: VideoPlayer(_videoPlayerController),);
//                                    }
//                                    else if(snapshot.hasData){
//                                      return Text("Loading...",style: TextStyle(color: Colors.white),);
//                                    }
//                                    else if(snapshot.hasError){
//                                      return Text("error...",style: TextStyle(color: Colors.white),);
//                                    }
//                                    else{
//                                      return Text("load...",style: TextStyle(color: Colors.white),);
//
//                                    }
//                                  });
//                            },itemCount: listOfUserStories[userCurrentIndex]["stories"].length,),
//                          onTapDown: (details)
//                          {
//                            final double screenWidth = MediaQuery.of(context).size.width;
//                            final double dx = details.globalPosition.dx;
//                            if(dx < screenWidth/3)
//                            {
//                            }
//                            else if(dx > 2 * screenWidth/3)
//                            {
//
//                            }
//                            else{
//
//                            }
//                          },
//                        ),
//                        Positioned(
//                          child: Padding(
//                            padding: EdgeInsets.symmetric(horizontal: 5),
//                            child: Row(
//                              children: List.generate(listOfUserStories[userCurrentIndex]["stories"].length, (index) => Flexible(
//                                  flex: 1,
//                                  child: Container(
//                                    width: double.infinity,
//                                    height: 2.5,
//                                    margin: EdgeInsets.only(left: 1,right: 1),
//                                    color: Colors.grey.withOpacity(0.5),
//                                  ))),
//                            ),
//                          )
//                          ,top: 5,left: 0,right: 0,),
//                        Positioned(child:
//                        Padding(
//                          padding: EdgeInsets.symmetric(horizontal: 5),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: List.generate(listOfUserStories[userCurrentIndex]["stories"].length, (index) {
//                              print("current Index");
//                              print(currentIndex);
//                              return
//                                index==currentIndex?AnimatedBuilder(
//                                    animation: _animationController,
//                                    builder: (context, child) {
//                                      return Flexible(
//                                          flex: 1,
//                                          child: Container(
//                                            margin: EdgeInsets.only(left: 1,right: 1),
//                                            width: (constraints.maxWidth/listOfUserStories[userCurrentIndex]["stories"].length-4) * _animationController.value,
//                                            height: 2.5,
//                                            color: Colors.white,
//                                          ));
//                                    }):Flexible(
//                                    flex: 1,
//                                    child: Container(
//                                      width: double.infinity,
//                                      height: 2.5,
//                                      margin: EdgeInsets.only(left: 1,right: 1),
//                                      color: index>=currentIndex?Colors.white.withOpacity(0):Colors.white,
//                                    ));
//                            }
//                            ),
//                          ),
//                        ),top: 5,left: 0,right: 0,),
//                        Positioned(
//                          top: 15,
//                          left: 10,
//                          right: 10,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              CircleAvatar(
//                                radius: 18,
//                                backgroundColor: Colors.blue,
//                              ),
//                              SizedBox(width: 10,),
//                              Text(listOfUserStories[userCurrentIndex]["name"].toString(),
//                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),),
//                              SizedBox(width: 10,),
//                              Text("6m",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.normal,fontSize: 12),),
//                            ],
//                          ),),
//                        Positioned(
//                            bottom: 0,
//                            left: 0,
//                            right: 0,
//                            child:Container(
//                              width: constraints.maxWidth,
//                              height: 68,
//                              padding: EdgeInsets.only(left: 5,right: 5),
//                              color: Colors.black,
//                              child: Row(
//                                children: [
//                                  Expanded(
//                                    flex: 5,
//                                    child: Container(
//                                      alignment: Alignment.center,
//                                      height: 50,
//                                      padding: EdgeInsets.only(left: 18),
//                                      decoration: BoxDecoration(
//                                          border: Border.all(
//                                              color: Colors.white70,
//                                              width: 1
//                                          ),
//                                          borderRadius: BorderRadius.circular(25),
//                                          color: Colors.black
//                                      ),
//                                      child: TextFormField(
//                                        onChanged: (value){
//                                          if(value.isEmpty)
//                                          {
//                                            _videoPlayerController.play();
//                                            _animationController.forward();
//                                          }
//                                          else{
//                                            _animationController.stop();
//                                            _videoPlayerController.pause();
//                                          }
//                                        },
//                                        cursorColor: Colors.white70,
//                                        style: TextStyle(color: Colors.white),
//                                        decoration: InputDecoration(
//                                            hintText: "send a comment",
//                                            hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 15),
//                                            border: InputBorder.none
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                                  Expanded(
//                                      flex: 1,
//                                      child: IconButton(
//                                        onPressed: (){
//
//                                        },
//                                        icon: Icon(Icons.send,color: Colors.white,size: 33,),
//                                      )
//                                  ),
//                                  Expanded(
//                                      flex: 1,
//                                      child: IconButton(
//                                        onPressed: (){},
//                                        icon: Icon(Icons.favorite_border,color: Colors.white,size: 33,),
//                                      )
//                                  ),
//                                ],
//                              ),
//                            )
//                        )
//                      ],
//                    ),
//                  );
//                }),
//          );
//        })
//       );
//   }
//   void _loadStory()
//   {
//     print("loadstory ======================");
//     print(userCurrentIndex);
//      _videoPlayerController.dispose();
//      _animationController.stop();
//      _animationController.reset();
//      _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][currentIndex]);
//      _initialisedVideoController = _videoPlayerController.initialize().then((value){
//        if(_videoPlayerController.value.isInitialized)
//        {
//          print("++++++++++++++++");
//          _animationController.duration =_videoPlayerController.value.duration;
//          // _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 10), curve: Curves.easeInOut);
//          _videoPlayerController.play();
//          _animationController.forward();
//        }
//      });
//   }
//
//   void _userLoadStory()
//   {
//     print("userloadstory ======================");
//       _videoPlayerController.dispose();
//         _animationController.stop();
//         _animationController.reset();
//         _videoPlayerController = VideoPlayerController.network(listOfUserStories[userCurrentIndex]["stories"][currentIndex]);
//         _initialisedVideoController = _videoPlayerController.initialize().then((value){
//           if(_videoPlayerController.value.isInitialized)
//           {
//             print("++++++++++++++++");
//             _animationController.duration =_videoPlayerController.value.duration;
//             _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 10), curve: Curves.easeInOut);
//             _videoPlayerController.play();
//             _animationController.forward();
//           }
//         });
//
//
//     print(userCurrentIndex);
//
//   }
//
//   }
//
//
//
// class StoriesPage extends StatefulWidget {
//   const StoriesPage({Key? key}) : super(key: key);
//
//   @override
//   State<StoriesPage> createState() => _StoriesPageState();
// }
//
// class _StoriesPageState extends State<StoriesPage> with SingleTickerProviderStateMixin {
//
//   late VideoPlayerController _videoPlayerController;
//   late Future<void> _lateInitialised;
//
//   late AnimationController _animationController;
//
//
//
//
//   @override
//   void initState()
//   {
//     _videoPlayerController = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
//
//     _animationController  = AnimationController(vsync: this);
//     _lateInitialised = _videoPlayerController.initialize().then((value) {
//       if(_videoPlayerController.value.isInitialized)
//         {
//           _animationController.duration = _videoPlayerController.value.duration;
//           print(_animationController.duration);
//           _animationController.forward();
//         }
//     }
//     );
//     _videoPlayerController.setLooping(true);
//     _videoPlayerController.play();
//
//
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Stack(
//              children: [
//                Container(
//                  height: 500,
//                  width: 500,
//                  child: FutureBuilder(
//                    future: _lateInitialised,
//                    builder: (context,snapshot){
//                      if(snapshot.connectionState==ConnectionState.done)
//                        {
//                          return AspectRatio(aspectRatio: 1/2,
//                          child: VideoPlayer(_videoPlayerController),);
//                        }
//                      else{
//                        return Text("Loading...");
//                      }
//                    },
//                  )
//                ),
//                Column(
//                  children: [
//
//
//                  ],
//                )
//
//              ],
//           ),
//         )
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
// class DoubleTapFavorites extends StatefulWidget {
//   const DoubleTapFavorites({Key? key}) : super(key: key);
//
//   @override
//   State<DoubleTapFavorites> createState() => _DoubleTapFavoritesState();
// }
//
// class _DoubleTapFavoritesState extends State<DoubleTapFavorites> with SingleTickerProviderStateMixin {
//
//   var _height =10.0;
//   var _width = 10.0;
//   late AnimationController _animationController;
//   late Animation sizeAnimation;
//   late Animation<double> scale;
//   @override
//   void initState()
//   {
//     _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 400));
//
//     scale = Tween<double>(begin: 0,end: 4).animate(_animationController);
//     // sizeAnimation = Tween(begin: 0.0,end: 100.0).animate(_animationController);
//
//     _animationController.addListener(() {
//       if(_animationController.isCompleted)
//         {
//           _animationController.reset();
//
//         }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Container(
//         height: 400,
//         color: Colors.red,
//         child: ScaleTransition(
//           alignment: Alignment.center,
//           scale: scale,
//           child: IconButton(
//             onPressed: (){},
//             icon: Icon(Icons.favorite,color: Colors.white,size: 30,),
//           ),
//
//         ),
//         )
//           ,floatingActionButton: FloatingActionButton(
//       onPressed: (){_animationController.forward();
//         print("controller");},
//     ),
//       );
//   }
// }
//
//
//
// class MyHome extends StatefulWidget {
//   const MyHome({Key? key}) : super(key: key);
//
//   @override
//   State<MyHome> createState() => _MyHomeState();
// }
//
// class _MyHomeState extends State<MyHome>  with SingleTickerProviderStateMixin{
//
//   late TabController _tabController;
//
//   late VideoPlayerController _videoPlayerController;
//   late Future<void> _initialisedVideoPlayerFuture;
//
//
//   @override
//   void initState()
//   {
//   function();
//   _tabController = TabController(length: 2, vsync: this);
//     super.initState();
//   }
//   void function()
//   {
//     _videoPlayerController = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
//     _initialisedVideoPlayerFuture = _videoPlayerController.initialize();
//     _videoPlayerController.setLooping(true);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<increment>(context,listen: false);
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Consumer<increment>(
//               builder: (context,value,child)
//               {
//                 return Text(value.index.toString());
//               },
//             ),
//             Container(
//               height: 200,
//               width: 400,
//               child: FutureBuilder(
//                   future: _initialisedVideoPlayerFuture,
//                   builder: (context, snapshot) {
//                     if(snapshot.connectionState==ConnectionState.done)
//                     {
//                       return Stack(
//                         alignment: Alignment.center,
//                         overflow: Overflow.visible,
//                         children: [
//                           Container(
//                             height: 200,
//                             width: 300,
//                             child: VideoPlayer(_videoPlayerController),
//                           ),
//                           Positioned(child: IconButton(
//                             onPressed: (){
//                               _videoPlayerController.pause();
//                             },
//                             icon: Icon(Icons.play_arrow_rounded),
//                           )),
//                         ],
//                       );
//                     }
//                     else{
//                       return Text("Loading...");
//                     }
//                   }),
//             ),
//             TabBar(
//                 controller: _tabController,
//                 tabs: [
//                   Tab(child: Icon(Icons.home),),
//                   Tab(child: Icon(Icons.home),),
//                 ]),
//             Container(
//               color: Colors.red,
//               child:
//               TabBarView(
//                   controller: _tabController,
//                   children: [
//                     Text("Home page"),
//                     Text("Home")
//                   ]),
//               height: 100,
//             ),
//
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           provider.incrementNumber();
//           _videoPlayerController.play();
//         },
//       ),
//     );
//   }
// }
//
// class increment extends ChangeNotifier{
//   int index = 0;
//   int incrementNumber()
//   {
//     index = index+1;
//     notifyListeners();
//     return index;
//   }
// }

