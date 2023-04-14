import "package:cash_flow/data/model/description_model.dart";
import "package:cash_flow/data/providers/database/database_helper.dart";

class DescriptionServices {
  Future<int> addDescription(DescriptionModel description) async {
    final Map<String, dynamic> map = description.toMap();
    return DatabaseHelper.insertDescription(map);
  }

  Future<int> updateDescription(
    DescriptionModel description,
    int id,
  ) async {
    final Map<String, dynamic> map = description.toMap();
    final result = await DatabaseHelper.updateDescription(
      map,
      id,
    );
    return result;
  }

  Future<int> deleteDescription(int id) async {
    final int result = await DatabaseHelper.deleteDescription(id);
    return result;
  }

  Future<int> deleteDescriptionByCategoryId(int id) async {
    final int result = await DatabaseHelper.deleteDescriptionByCategoryId(id);
    return result;
  }

  Future<List<DescriptionModel>> getDescriptionByCategoryId(
    int categoryId,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getDescriptionByCategoryID(
      categoryId,
    );
    return results.map((item) => DescriptionModel.fromJson(item)).toList();
  }
}
