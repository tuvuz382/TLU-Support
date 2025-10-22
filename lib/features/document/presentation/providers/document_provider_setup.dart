import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/usecases/search_documents_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_document_detail_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../data/datasources/mock_document_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../providers/document_provider.dart';

class DocumentProviderSetup extends StatelessWidget {
  final Widget child;

  const DocumentProviderSetup({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final datasource = MockDocumentDataSource();
    final repository = DocumentRepositoryImpl(datasource);
    
    final searchDocumentsUsecase = SearchDocumentsUsecase(repository);
    final getCategoriesUsecase = GetCategoriesUsecase(repository);
    final getDocumentDetailUsecase = GetDocumentDetailUsecase(repository);
    final toggleFavoriteUsecase = ToggleFavoriteUsecase(repository);

    return ChangeNotifierProvider(
      create: (context) => DocumentProvider(
        searchDocumentsUsecase: searchDocumentsUsecase,
        getCategoriesUsecase: getCategoriesUsecase,
        getDocumentDetailUsecase: getDocumentDetailUsecase,
        toggleFavoriteUsecase: toggleFavoriteUsecase,
      ),
      child: child,
    );
  }
}
