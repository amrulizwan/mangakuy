import 'package:chartboost/banner.dart';
import 'package:chartboost/chartboost.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mangakuy/detailpage.dart';

class ChapterRead extends StatefulWidget {
  const ChapterRead({Key? key}) : super(key: key);

  @override
  _ChapterReadState createState() => _ChapterReadState();
}

class _ChapterReadState extends State<ChapterRead> {
  List<String> imageUrls = [];
  String chapterEndpoint = endPointDetails;

  @override
  void initState() {
    super.initState();
    Chartboost.init(
        '6492a3e770c588a966776928', '08cee473a41e809abe19dde4100103936453bf30');
    fetchChapterData();
  }

  Future<void> fetchChapterData() async {
    try {
      final response = await Dio().get(
          'https://amrulizwan.com/manga/api/chapter/$chapterEndpoint'); // Ganti dengan endpoint API Anda
      final data = response.data;
      setState(() {
        imageUrls = parseImageData(
            data); // Fungsi untuk memparsing data gambar dari respons API
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  List<String> parseImageData(dynamic data) {
    // Logika parsing data gambar dari respons API
    // Anda perlu menyesuaikannya dengan struktur respons API Anda
    List<String> urls = [];
    // Contoh parsing jika struktur respons API adalah seperti yang diberikan dalam pertanyaan
    for (var image in data['chapter_image']) {
      urls.add(image['chapter_image_link']);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(221, 24, 24, 24),
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('Back'),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        final imageUrl = imageUrls[index];
                        return Row(
                          children: [
                            Expanded(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ChartboostBanner(BannerAdSize.STANDARD, 'Default'),
            ),
          ],
        ));
  }
}
