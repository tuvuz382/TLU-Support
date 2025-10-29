import '../repositories/student_profile_repository.dart';

/// Use case to update profile image
class UpdateProfileImageUseCase {
  final StudentProfileRepository _repository;

  UpdateProfileImageUseCase(this._repository);

  /// Execute the use case
  /// [imageUrl] - Image URL to set as profile picture
  Future<void> call(String imageUrl) async {
    // Validate input
    if (imageUrl.trim().isEmpty) {
      throw Exception('URL ảnh không được để trống');
    }
    
    // Check URL format
    final uri = Uri.tryParse(imageUrl);
    if (uri == null || (!uri.hasScheme || (!uri.scheme.startsWith('http')))) {
      throw Exception('URL ảnh không đúng định dạng');
    }
    
    // Check image extension
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final hasValidExtension = validExtensions.any(
      (ext) => imageUrl.toLowerCase().contains(ext),
    );
    
    if (!hasValidExtension) {
      throw Exception('Ảnh phải có định dạng: jpg, jpeg, png, gif, webp');
    }

    // Call repository
    await _repository.updateProfileImage(imageUrl);
  }
}
