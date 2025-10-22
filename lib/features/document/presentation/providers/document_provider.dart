import 'package:flutter/material.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/search_documents_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_document_detail_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

class DocumentProvider extends ChangeNotifier {
  final SearchDocumentsUsecase _searchDocumentsUsecase;
  final GetCategoriesUsecase _getCategoriesUsecase;
  final GetDocumentDetailUsecase _getDocumentDetailUsecase;
  final ToggleFavoriteUsecase _toggleFavoriteUsecase;

  DocumentProvider({
    required SearchDocumentsUsecase searchDocumentsUsecase,
    required GetCategoriesUsecase getCategoriesUsecase,
    required GetDocumentDetailUsecase getDocumentDetailUsecase,
    required ToggleFavoriteUsecase toggleFavoriteUsecase,
  }) : _searchDocumentsUsecase = searchDocumentsUsecase,
       _getCategoriesUsecase = getCategoriesUsecase,
       _getDocumentDetailUsecase = getDocumentDetailUsecase,
       _toggleFavoriteUsecase = toggleFavoriteUsecase;

  // State
  List<DocumentEntity> _documents = [];
  List<DocumentEntity> _favoriteDocuments = [];
  List<CategoryEntity> _categories = [];
  bool _isLoading = false;
  bool _isShowingFavorites = false;
  String _searchKeyword = '';

  // Getters
  List<DocumentEntity> get documents => _documents;
  List<DocumentEntity> get favoriteDocuments => _favoriteDocuments;
  List<CategoryEntity> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isShowingFavorites => _isShowingFavorites;
  String get searchKeyword => _searchKeyword;

  // Load documents
  Future<void> loadDocuments() async {
    try {
      _isLoading = true;
      notifyListeners();

      _documents = await _searchDocumentsUsecase('');
      _favoriteDocuments = _documents.where((doc) => doc.isFavorite).toList();
      notifyListeners();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _getCategoriesUsecase();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  // Set showing favorites
  void setShowingFavorites(bool isShowingFavorites) {
    _isShowingFavorites = isShowingFavorites;
    notifyListeners();
  }

  // Toggle favorite
  Future<void> toggleFavorite(String documentId) async {
    try {
      await _toggleFavoriteUsecase(documentId);
      
      // Update local state
      final index = _documents.indexWhere((doc) => doc.id == documentId);
      if (index != -1) {
        _documents[index] = _documents[index].copyWith(
          isFavorite: !_documents[index].isFavorite,
        );
        _favoriteDocuments = _documents.where((doc) => doc.isFavorite).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  // Toggle category selection
  void toggleCategory(String categoryId) {
    final index = _categories.indexWhere((cat) => cat.id == categoryId);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(
        isSelected: !_categories[index].isSelected,
      );
      notifyListeners();
    }
  }

  // Apply filters
  Future<void> applyFilters() async {
    try {
      _isLoading = true;
      notifyListeners();

      final selectedCategories = _categories
          .where((cat) => cat.isSelected)
          .map((cat) => cat.id)
          .toList();

      if (selectedCategories.isEmpty) {
        _documents = await _searchDocumentsUsecase('');
      } else {
        // In real implementation, this would filter by categories
        _documents = await _searchDocumentsUsecase('');
      }
      
      _favoriteDocuments = _documents.where((doc) => doc.isFavorite).toList();
      notifyListeners();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search documents
  Future<void> searchDocuments(String keyword) async {
    try {
      _searchKeyword = keyword;
      _isLoading = true;
      notifyListeners();

      _documents = await _searchDocumentsUsecase(keyword);
      _favoriteDocuments = _documents.where((doc) => doc.isFavorite).toList();
      notifyListeners();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}