
# Fast Cached Network Image Plus

A Flutter package that extends the functionality of Fast Cached Network Image to cache network images 
quickly without native dependencies. This package introduces enhanced features, allowing you to save images 
by URL along with a unique ID, ensuring that even if the URL changes, the image can still be cached effectively.
With built-in loaders, error handling, and smooth fade transitions, it offers a seamless image caching experience.




[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://pub.dev/packages/fast_cached_network_image)
[![pub](https://img.shields.io/pub/v/fast_cached_network_image_plus)](https://pub.dev/packages/fast_cached_network_image_plus)
[![dart](https://img.shields.io/badge/dart-pure%20dart-success)](https://pub.dev/packages/fast_cached_network_image_plus)

## Screenshots


<img src="https://s8.uupload.ir/files/screen_recording_1403-07-12_at_16.14.59_(1)_3dyo.gif" width="600" />


## Usage
Import it
```dart
import 'package:fast_cached_network_image_plus/fast_cached_network_image_plus.dart';
```

Use [path_provider](https://pub.dev/packages/path_provider) to set a storage location for the db of images.
```dart
String storageLocation = (await getApplicationDocumentsDirectory()).path;
```
> This package uses [Hive](https://pub.dev/packages/hive_flutter) as cache container, which uses getApplicationDocumentsDirectory() to get the default path in case subDir is not specified

Initialize the cache configuration
```dart
await FastCachedImagePlusConfig.init(subDir: storageLocation, clearCacheAfter: const Duration(days: 15));
```
The clearCacheAfter property is used to set the Duration after with the cached image will be cleared. By default its set to 7 days, which means an image cached today will be deleted when you open the app after 7 days.

Use it as a Widget

```dart
child: FastCachedImagePlus(url: url)
```

## Properties
``` dart
errorBuilder: (context, exception, stacktrace) {
  return Text(stacktrace.toString());
},
```
errorBuilder property needs to return a widget. This widget will be displayed if there is any error while loading the provided image.
``` dart

loadingBuilder: (context, progress) {
  return Container(
    color: Colors.yellow,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (progress.isDownloading && progress.totalBytes != null)
          Text('${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
              style: const TextStyle(color: Colors.red)),
        SizedBox(
            width: 120,
            height: 120,
            child:
            CircularProgressIndicator(color: Colors.red, value: progress.progressPercentage.value)),
      ],
    ),
  );
},
```
loadingBuilder property can be used to display a loading widget such as a shimmer. This widget will be displayed while the image is being downloaded and processed.
loadingBuilder provides a progress property which can be used to display the image download progress with the size(in bytes) of the image.

```dart
fadeInDuration: const Duration(seconds: 1);
```
fadeInDuration property can be use to set the fadeInDuration between the loadingBuilder and the image. Default duration is 500 milliseconds


```dart
FastCachedImagePlusConfig.isCached(imageUrl: url));
//Or If You want Cached Image With Image Unique Name Using Below Snippet Code
// If Want Using Int for Unique Name just add toString() method and use it
FastCachedImagePlusConfig.isCached(imageUniqueName: imageUniqueName));

```
You can pass in a url to this method and check whether the image in the url is already cached.


```dart
FastCachedImagePlusConfig.deleteCachedImage(imageUrl: url);
//Or If Using Image Unique Name Instead Of Url For Caching
FastCachedImagePlusConfig.deleteCachedImage(imageUniqueName: imageUniqueName);

```
This method deletes the image with given url from cache.

```dart
FastCachedImagePlusConfig.clearAllCachedImages();
```
This method removes all the cached images. This method can be used in situations such as user logout, where you need to
clear all the images corresponding to the particular user.

If an image had some errors while displaying, the image will be automatically re - downloaded when the image is requested again.

FastCachedImagePlus have all other default properties such as height, width etc. provided by flutter.


If you want to use an image from cache as image provider, use

```dart
FastCachedImagePlusProvider(url);
```


## Example

```dart
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FastCachedImagePlusConfig.init(clearCacheAfter: const Duration(days: 15));

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
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await FastCachedImagePlusConfig.deleteCachedImage(url: url1);
                    //or
                    // FastCachedImagePlusConfig.deleteCachedImage(imageUniqueName:imageUniqueName));

                    setState(() => log = 'Deleted image $url1');
                    await Future.delayed(
                        const Duration(seconds: 2), () => setState(() => log = null));
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Cached Image'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
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
                    await Future.delayed(
                        const Duration(seconds: 2), () => setState(() => log = null));
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All Cached Images'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.orangeAccent,
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



```

## Package on pub.dev

[fast_cached_network_image_plus](https://pub.dev/packages/fast_cached_network_image_plus)

