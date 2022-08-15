import 'package:pemuda_baik/src/models/artikel_save_model.dart';
import 'package:pemuda_baik/src/repositories/dio_helper.dart';

class ArtikelSaveRepo {
  Future<ResponseArtikelSaveModel> saveArtikel(
      ArtikelSaveModel artikelSaveModel) async {
    final response =
        await dio.post('/v1/artikel', artikelSaveModelToJson(artikelSaveModel));
    return responseArtikelSaveModelFromJson(response);
  }

  Future<ResponseArtikelSaveModel> deleteArtikel(int id) async {
    final response = await dio.delete('/v1/artikel/$id');
    return responseArtikelSaveModelFromJson(response);
  }
}
