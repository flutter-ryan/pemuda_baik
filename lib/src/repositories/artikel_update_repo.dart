import 'package:pemuda_baik/src/models/artikel_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class ArtikelUpdateRepo {
  Future<ResponseArtikelSaveModel> updateArtikel(
      ArtikelSaveModel artikelSaveModel, int id) async {
    final response = await dio.put(
        '/v1/artikel/$id', artikelSaveModelToJson(artikelSaveModel));
    return responseArtikelSaveModelFromJson(response);
  }
}
