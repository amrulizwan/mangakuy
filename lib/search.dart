import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mangakuy/detailpage.dart';
import 'package:mangakuy/main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> searchResults = [];

  Future<void> fetchSearchResults(String keyword) async {
    try {
      final response =
          await Dio().get('https://amrulizwan.com/manga/api/search/$keyword');
      final data = response.data;
      setState(() {
        _focusNode.unfocus();
        searchResults = data['manga_list'];
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void showSnackbar(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  final FocusNode _focusNode = FocusNode();

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackbar(context,
          'Jika form pencarian tidak bisa diketik, silahkan tekan kembali form pencarian!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 36, 36, 36),
      appBar: AppBar(
        title: const Text("Search"),
        actions: const [],
        backgroundColor: Colors.black87,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey[400]!,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.none,
                      focusNode: _focusNode,
                      controller: searchController,
                      decoration: const InputDecoration.collapsed(
                        fillColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        hintText: "Cari Manga..",
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            searchResults = [];
                          });
                        } else {
                          fetchSearchResults(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      fetchSearchResults(searchController.text);
                    },
                    icon:
                        const Icon(Icons.search, size: 30, color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  final manga = searchResults[index];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        endPoint = manga['endpoint'];
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MangaDetailPage()),
                      );
                    },
                    leading: Image.network(
                      manga['thumb'],
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.network(
                          'https://www.pngkey.com/png/full/233-2332677_image-500580-placeholder-transparent.png',
                        );
                      },
                    ),
                    title: Text(
                      manga['title'],
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          manga['type'],
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const Text(' | ', style: TextStyle(color: Colors.grey)),
                        Text(manga['updated_on'],
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
