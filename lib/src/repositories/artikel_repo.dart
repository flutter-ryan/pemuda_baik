import 'package:pemuda_baik/src/models/artikel_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class ArtikelRepo {
  Future<ArtikelModel> getArtikel() async {
    final response = await dio.get('/v1/artikel/create');
    return artikelModelFromJson(response);
  }
}
