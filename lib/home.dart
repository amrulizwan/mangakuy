import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chartboost/banner.dart';
import 'package:chartboost/chartboost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mangakuy/abour.dart';
import 'package:mangakuy/auth.dart';
import 'package:mangakuy/editprofile.dart';
import 'package:mangakuy/loginpage.dart';
import 'package:mangakuy/privacypolicy.dart';
import 'package:mangakuy/search.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'detailpage.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String opTitle = '';
  String narutoTitle = '';
  String bleachTitle = '';
  String opAuthor = '';
  String narutoAuthor = '';
  String bleachAuthor = '';
  String opThumb = '';
  String narutoThumb = '';
  String bleachThumb = '';
  String opSynopsis = '';
  String narutoSynopsis = '';
  String bleachSynopsis = '';
  String opEndpoint = '';
  String narutoEndpoint = '';
  String bleachEndpoint = '';
  List<Map> populer = [];
  List<dynamic> mangaList = [];
  List<dynamic> mangaReko = [];
  List<String> imageUrls = [];

  Future<void> fetchPopuler() async {
    try {
      final op = await Dio()
          .get('https://amrulizwan.com/manga/api/manga/detail/one-piece/');
      final naruto = await Dio()
          .get('https://amrulizwan.com/manga/api/manga/detail/bleach/');
      final bleach = await Dio()
          .get('https://amrulizwan.com/manga/api/manga/detail/naruto/');
      setState(() {
        opTitle = op.data['title'];
        narutoTitle = naruto.data['title'];
        bleachTitle = bleach.data['title'];
        opAuthor = op.data['author'];
        narutoAuthor = naruto.data['author'];
        bleachAuthor = bleach.data['author'];
        opThumb = op.data['thumb'];
        narutoThumb = naruto.data['thumb'];
        bleachThumb = bleach.data['thumb'];
        opSynopsis = op.data['synopsis'];
        narutoSynopsis = naruto.data['synopsis'];
        bleachSynopsis = bleach.data['synopsis'];
        opEndpoint = op.data['manga_endpoint'];
        narutoEndpoint = naruto.data['manga_endpoint'];
        bleachEndpoint = bleach.data['manga_endpoint'];
        populer = [
          {
            'title': opTitle,
            'author': opAuthor,
            'thumb': opThumb,
            'synopsis': opSynopsis,
            'endpoint': opEndpoint,
          },
          {
            'title': narutoTitle,
            'author': narutoAuthor,
            'thumb': narutoThumb,
            'synopsis': narutoSynopsis,
            'endpoint': narutoEndpoint,
          },
          {
            'title': bleachTitle,
            'author': bleachAuthor,
            'thumb': bleachThumb,
            'synopsis': bleachSynopsis,
            'endpoint': bleachEndpoint,
          },
        ];
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  Future<void> fetchImageData() async {
    try {
      final response =
          await Dio().get('https://amrulizwan.com/manga/api/manga/popular/1');
      setState(() {
        mangaList = response.data['manga_list'];
        for (var manga in mangaList) {
          imageUrls.add(manga['thumb']);
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  Future<void> fetchRekomen() async {
    try {
      final response =
          await Dio().get('https://amrulizwan.com/manga/api/recommended');
      setState(() {
        mangaReko = response.data['manga_list'];
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  List<String> parseImageData(dynamic data) {
    List<String> urls = [];

    for (var image in data['manga_list']) {
      urls.add(image['thumb']);
    }
    return urls;
  }

  List<String> docIDs = [];

  Future<void> getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              print(element.reference);
              docIDs.add(element.reference.id);
            }));
  }

  bool isLogin = false;

  Future<void> checkLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLogin = true;
      });
    } else {
      setState(() {
        isLogin = false;
      });
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? imageLink;
  Future<void> fetchUserDetails() async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    if (userId != null) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          firstName = userData['first name'];
          lastName = userData['last name'];
          email = userData['email'];
          imageLink = userData['imageLink'];
          previousImageLink = imageLink;
        });
      } else {
        print('User not found');
      }
    }
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (file != null) {
      return File(file.path);
    } else {
      print('No image selected.');
    }
  }

  String? previousImageLink;

  Future<void> uploadImageAndSetLink() async {
    File? image = await selectImageFromGallery();
    if (image != null) {
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now()}.jpg');

      try {
        // Delete previous image if it exists
        if (previousImageLink != null) {
          await firebase_storage.FirebaseStorage.instance
              .refFromURL(previousImageLink!)
              .delete();
        }

        // Upload image to Firebase Storage
        await storageRef.putFile(image);

        // Get the image download URL
        String downloadURL = await storageRef.getDownloadURL();

        // Create a new document in Firestore and set the image link
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'imageLink': downloadURL,
          'first name': firstName,
          'last name': lastName,
          'email': email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated.'),
          ),
        );
        fetchUserDetails();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile picture - $e'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Chartboost.init(
        '6492a3e770c588a966776928', '08cee473a41e809abe19dde4100103936453bf30');
    fetchImageData();
    fetchRekomen();
    fetchPopuler();
    getDocId();
    checkLogin();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$firstName $lastName'),
              accountEmail: Text(email != null ? email! : 'Email not found'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageLink != null
                    ? imageLink!
                    : 'https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              otherAccountsPictures: const [],
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Edit Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                Auth().signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const Column(
                      children: [Spacer(), Text('aisaDev 2023')],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 20, 20, 20),
        centerTitle: true,
        title: const Text("Manga Kuy"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Builder(builder: (context) {
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: imageUrls.map((imageUrl) {
                    String title = '';
                    String uploadOn = '';
                    String endpoint = '';
                    for (var manga in mangaList) {
                      if (manga['thumb'] == imageUrl) {
                        title = manga['title'];
                        uploadOn = manga['upload_on'];
                        endpoint = manga['endpoint'];
                        break;
                      }
                    }
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              endPoint = endpoint;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MangaDetailPage()),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    imageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: Text(
                                      uploadOn,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: Text(
                                      title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  }).toList(),
                );
              }),
            ),
            Container(
                height: 200,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rekomendasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mangaReko.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  endPoint = mangaReko[index]['endpoint'];
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MangaDetailPage()),
                                );
                              },
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 100,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          mangaReko[index]['thumb'],
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      mangaReko[index]['title'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              )),
                            );
                          }),
                    )
                  ],
                )),
            Container(
                height: 220,
                margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "BIG 3 MANGA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: populer.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  endPoint = populer[index]['endpoint'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MangaDetailPage()),
                                  );
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width - 30,
                                height: 200,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(144, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(children: [
                                  Container(
                                    width: 140,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          populer[index]['thumb'],
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(populer[index]['title'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                      Text(
                                        (populer[index]['author'] ==
                                                'Komik Bleach')
                                            ? 'Tite Kubo'
                                            : populer[index]['author'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          populer[index]['synopsis'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            );
                          }),
                    )
                  ],
                )),
            const Spacer(),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ChartboostBanner(BannerAdSize.STANDARD, 'Default'),
            )
          ],
        ),
      ),
    );
  }
}
