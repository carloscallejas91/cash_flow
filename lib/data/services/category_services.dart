import "package:cash_flow/data/model/category_model.dart";
import "package:cash_flow/data/providers/database/database_helper.dart";

class CategoryServices {
  Future<int> addCategory(CategoryModel category) async {
    final Map<String, dynamic> map = category.toMap();
    return DatabaseHelper.insertCategory(map);
  }

  Future<int> updateCategory(
    CategoryModel category,
    int id,
  ) async {
    final Map<String, dynamic> map = category.toMap();
    final result = await DatabaseHelper.updateCategory(
      map,
      id,
    );
    return result;
  }

  Future<int> deleteCategory(int id) async {
    final int result = await DatabaseHelper.deleteCategory(id);
    return result;
  }

  Future<List<CategoryModel>> getCategoryById(
    int id,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getCategoryById(
      id,
    );
    return results.map((item) => CategoryModel.fromJson(item)).toList();
  }

  Future<List<CategoryModel>> getCategoryByName(
    String name,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getCategoryByName(
      name,
    );
    return results.map((item) => CategoryModel.fromJson(item)).toList();
  }

  Future<List<CategoryModel>> getCategoryByType(
    String type,
  ) async {
    final List<Map<String, dynamic>> results =
        await DatabaseHelper.getCategoryByType(
      type,
    );
    return results.map((item) => CategoryModel.fromJson(item)).toList();
  }
}
