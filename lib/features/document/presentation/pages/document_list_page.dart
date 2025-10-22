import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/document_tabs_widget.dart';
import '../widgets/document_search_bar.dart';
import '../widgets/document_card_widget.dart';
import '../providers/document_provider.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().loadDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Tài liệu học tập',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          const DocumentTabsWidget(),

          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: const DocumentSearchBar(),
          ),

          // Documents List
          Expanded(
            child: Consumer<DocumentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final documents = provider.isShowingFavorites
                    ? provider.favoriteDocuments
                    : provider.documents;

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadDocuments();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DocumentCardWidget(
                          document: document,
                          onTap: () {
                            context.go('/document-detail', extra: document);
                          },
                          onFavoriteToggle: () {
                            provider.toggleFavorite(document.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
