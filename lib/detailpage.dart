import 'package:chartboost/banner.dart';
import 'package:chartboost/chartboost.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mangakuy/chapterread.dart';

import 'main.dart';

String endPointDetails = '';

class DetailApp extends StatelessWidget {
  const DetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Komik Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MangaDetailPage(),
    );
  }
}

class MangaDetailPage extends StatefulWidget {
  const MangaDetailPage({super.key});

  @override
  _MangaDetailPageState createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  String endPointDetail = endPoint;
  Map<String, dynamic> mangaDetail = {};
  List<Map> chapterList = [];

  @override
  void initState() {
    super.initState();
    Chartboost.init(
        '6492a3e770c588a966776928', '08cee473a41e809abe19dde4100103936453bf30');
    fetchMangaDetail();
  }

  Future<void> fetchMangaDetail() async {
    try {
      final dio = Dio();
      final response = await dio
          .get('https://amrulizwan.com/manga/api/manga/detail/$endPointDetail');
      if (response.statusCode == 200) {
        setState(() {
          mangaDetail = response.data;
        });
      } else {
        print('Failed to fetch manga detail');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 24, 24, 24),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Komik Detail'),
      ),
      body: mangaDetail.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    mangaDetail['thumb'] ??
                        'https://via.placeholder.com/150?text=No+Image',
                    width: 200,
                    height: 300,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Type: ${mangaDetail['type']}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Author: ${mangaDetail['author']}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Status: ${mangaDetail['status']}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Genres:',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: List<Widget>.generate(
                      mangaDetail['genre_list'].length,
                      (index) => Chip(
                        label: Text(
                            mangaDetail['genre_list'][index]['genre_name']),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ChartboostBanner(BannerAdSize.STANDARD, 'Default'),
                  ),
                  const Text(
                    'Synopsis:',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    mangaDetail['synopsis'],
                    style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Latest Chapter:',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                        itemCount: mangaDetail['chapter'].length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                endPointDetails = mangaDetail['chapter'][index]
                                    ['chapter_endpoint'];
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChapterRead()),
                              );
                            },
                            title: Text(
                              mangaDetail['chapter'][index]['chapter_title'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
