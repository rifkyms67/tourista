import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk decode JSON
import 'screens/tourism_detail_page.dart';
import 'package:draggable_home/draggable_home.dart';

void main() {
  runApp(const TourismApp());
}

class TourismApp extends StatelessWidget {
  const TourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> tourismData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTourismData();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchTourismData() async {
    final url = Uri.parse('https://amalsolution-dev.com:20002/api/destinations');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          tourismData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = true;
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: const Text("Tourista"),
      headerWidget: headerWidget(context),
      body: [
        // Mengganti ListView dengan data yang didapat dari HTTP
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : listView(),
      ],
      stretchMaxHeight: .80,
      backgroundColor: Colors.white,
      appBarColor: Colors.teal,
    );
  }

  Widget headerWidget(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: const AssetImage('assets/images/dest.png'), // Gambar latar belakang
        fit: BoxFit.cover, // Agar gambar menutupi seluruh container
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.3), 
          BlendMode.darken, // Memberikan efek gelap pada gambar agar teks lebih jelas
        ),
      ),
    ),
    child: Center(
      child: Text(
        "Unlock the World, One Trip at a Time",
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(
              color: const Color(0xFF009688),
              fontFamily: "Pacifico",
              fontStyle: FontStyle.normal,
            ),
      ),
    ),
  );
}


  // Fungsi untuk membangun tampilan ListView berdasarkan data yang diambil
  ListView listView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      itemCount: tourismData.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = tourismData[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TourismDetailPage(data: item),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12.0),
                  ),
                  child: Image.network(
                    item['banner'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/image-404.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item['location'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
