import 'package:fast_cached_network_image_plus/fast_cached_network_image_plus.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FastCachedImagePlusConfig.init(
      clearCacheAfter: const Duration(days: 15));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String url1 =
      'https://cdn-images-1.medium.com/v2/resize:fit:87/1*XrbUBnZb-Vp9jRDGqU-BXQ@2x.png';

  bool isImageCached = false;
  String? log;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Fast Cached Image Plus'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image inside a Card for beautiful design
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: FastCachedImagePlus(
                        // imageUniqueName:"image1",
                        // If You Want Cache Using Image Unique Name Just Giv Name Per Eeach Image :( As A default using url for cache)
                        //You Can Use Id And Convert To String Using toString() Method
                        url: url1,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(seconds: 1),
                        errorBuilder: (context, exception, stacktrace) {
                          return const Center(
                            child: Text('Failed to load image',
                                style: TextStyle(color: Colors.red)),
                          );
                        },
                        loadingBuilder: (context, progress) {
                          return Container(
                            color: Colors.grey[300],
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (progress.isDownloading &&
                                    progress.totalBytes != null)
                                  Text(
                                      '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    color: Colors.deepPurple,
                                    value: progress.progressPercentage.value,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Cached image info
                Text(
                  'Is image cached? = $isImageCached',
                  style: const TextStyle(
                      fontSize: 16, color: Colors.deepPurpleAccent),
                ),
                const SizedBox(height: 12),
                Text(
                  log ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // Styled buttons
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => isImageCached =
                        FastCachedImagePlusConfig.isCached(url: url1));
                    //or
                    // FastCachedImagePlusConfig.isCached(imageUniqueName:imageUniqueName));
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Check Image Cache'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await FastCachedImagePlusConfig.deleteCachedImage(
                        url: url1);
                    //or
                    // await FastCachedImagePlusConfig.deleteCachedImage(imageUniqueName:imageUniqueName));
                    setState(() => log = 'Deleted image $url1');
                    await Future.delayed(const Duration(seconds: 2),
                        () => setState(() => log = null));
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Cached Image'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await FastCachedImagePlusConfig.clearAllCachedImages(
                        showLog: true);
                    setState(() => log = 'All cached images deleted');
                    await Future.delayed(const Duration(seconds: 2),
                        () => setState(() => log = null));
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All Cached Images'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
