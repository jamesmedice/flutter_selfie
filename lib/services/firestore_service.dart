import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class FireStoreService {
  final Logger _logger = Logger();

  String? downloadURL;
  List<String>? urls;

  Future getUrl(String imageUrl) async {
    try {
      await downloadURLByImage(imageUrl);
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future getUrls(String userEmail) async {
    try {
      await downloadUrls(userEmail);
      return urls;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadUrls(String userEmail) async {
    ListResult result = await FirebaseStorage.instance.ref(userEmail).listAll();

    urls = await Future.wait(
      result.items.map((Reference ref) async {
        return await ref.getDownloadURL();
      }),
    );
  }

  Future<void> downloadURLByImage(String imageUrl) async {
    downloadURL =
        await FirebaseStorage.instance.refFromURL(imageUrl).getDownloadURL();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      _logger.e('Error deleting image: $e');
      throw e;
    }
  }
}
