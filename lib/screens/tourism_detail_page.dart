import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TourismDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const TourismDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final facilities = List<String>.from(data['facilities'] ?? []);
    final gallery = List<String>.from(data['galery'] ?? []);
    final coordinates = data['coordinates'] as Map<String, dynamic>? ?? {'lat': 0.0, 'long': 0.0};
    final latitude = coordinates['lat'] as double? ?? 0.0;
    final longitude = coordinates['long'] as double? ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(data['name'] ?? 'Detail Wisata'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  data['banner'] ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    Image.asset(
                      'assets/images/image-404.png', // Gambar default saat error
                      height: 250.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                ),
              ),
              const SizedBox(height: 16.0),

              // Name and Category
              Text(
                data['name'] ?? 'Nama tidak tersedia',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (data['category'] != null)
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.green),
                    const SizedBox(width: 8.0),
                    Text(
                      data['category']!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              const SizedBox(height: 8.0),

              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange),
                  const SizedBox(width: 8.0),
                  Text(
                    (data['rating']?.toString() ?? '0.0'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Description
              const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(
                data['description'] ?? 'Deskripsi tidak tersedia',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),

              // Facilities
              const Text('Fasilitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: facilities.isNotEmpty
                    ? facilities
                        .map((facility) => Chip(label: Text(facility), backgroundColor: Colors.green[100]))
                        .toList()
                    : [const Text('Fasilitas tidak tersedia')],
              ),
              const SizedBox(height: 16.0),

              // Opening Hours
              const Text('Jam Buka', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text(
                data['openingHours'] ?? 'Informasi jam buka tidak tersedia',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),

              // Map
              const Text('Peta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 300,
                child: (latitude != 0.0 && longitude != 0.0)
                    ? FlutterMap(
                        options: MapOptions(
                          // ignore: deprecated_member_use
                          center: LatLng(latitude, longitude),
                          // ignore: deprecated_member_use
                          zoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                            Marker(
                              point: LatLng(latitude, longitude),
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 30.0,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Text(
                                      "Lokasi",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ],
                          ),
                        ],
                      )
                    : const Center(child: Text('Koordinat tidak tersedia')),
              ),
              const SizedBox(height: 16.0),

              // Gallery
              const Text('Galeri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 100,
                child: gallery.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: gallery.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              gallery[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey, width: 100, height: 100, child: const Center(child: Text('Gagal memuat'))),
                            ),
                          ),
                        ),
                      )
                    : const Center(child: Text('Galeri tidak tersedia')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
