import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Kebijakan Privasi MangaKuy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Versi 0.2.0, efektif sejak 26 Juni 2023',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Terima kasih telah menggunakan MangaKuy, sebuah aplikasi baca manga yang dikembangkan oleh kami. Kami berkomitmen untuk melindungi privasi pengguna kami dan ingin menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi pribadi Anda. Kebijakan privasi ini menjelaskan praktik kami terkait dengan informasi yang kami kumpulkan melalui aplikasi MangaKuy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Pengumpulan Informasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'MangaKuy mengumpulkan informasi pribadi seperti nama pengguna dan alamat email saat Anda mendaftar dan login ke dalam aplikasi. Kami juga meminta izin penyimpanan untuk menyimpan data profil Anda.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Penggunaan Informasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Informasi pribadi yang dikumpulkan digunakan untuk keperluan otentikasi, identifikasi pengguna, dan menyediakan fitur-fitur personalisasi dalam aplikasi MangaKuy. Kami juga dapat menggunakan informasi tersebut untuk mengirimkan pembaruan terkait aplikasi dan fitur terbaru.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Penggunaan Iklan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'MangaKuy menyediakan iklan sebagai sumber pendapatan. Kami dapat menampilkan iklan dari jaringan iklan pihak ketiga yang memungkinkan pengumpulan informasi non-pribadi seperti minat dan preferensi pengguna untuk meningkatkan relevansi iklan yang ditampilkan. Namun, kami tidak memberikan akses langsung kepada pihak ketiga terhadap data pengguna apa pun.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Penggunaan Cookie',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'MangaKuy tidak menggunakan cookie atau teknologi pelacakan serupa untuk melacak aktivitas pengguna atau menyimpan informasi pribadi.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Pengungkapan Informasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kami tidak mengungkapkan informasi pribadi pengguna kepada pihak ketiga kecuali dalam keadaan tertentu seperti pemenuhan hukum, perlindungan terhadap kejahatan, atau keamanan aplikasi.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Keamanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kami mengambil langkah-langkah yang wajar untuk melindungi informasi pribadi yang dikumpulkan oleh MangaKuy dari akses, penggunaan, atau pengungkapan yang tidak sah. Namun, tidak ada metode transmisi data melalui internet atau metode penyimpanan elektronik yang 100% aman dan tidak dapat menjamin keamanan mutlak.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Perubahan Kebijakan Privasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Jika ada perubahan materi pada kebijakan privasi ini, kami akan memberitahukan pengguna dengan cara yang wajar, seperti dengan memposting pemberitahuan di dalam aplikasi atau melalui email. Pastikan untuk memeriksa kebijakan privasi ini secara berkala.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Jika Anda memiliki pertanyaan, saran, atau masalah terkait dengan kebijakan privasi kami atau penggunaan MangaKuy, silakan hubungi kami melalui alamat email me@amrulizwan.com.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Kebijakan privasi ini dimaksudkan untuk memberi Anda pemahaman yang jelas tentang bagaimana kami mengelola informasi pengguna di dalam aplikasi MangaKuy. Dengan menggunakan aplikasi ini, Anda menyetujui kebijakan privasi ini.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
