import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../repositories/subjects_repository.dart';

class GetSubjectsByMajorUseCase {
  final SubjectsRepository repository;
  GetSubjectsByMajorUseCase(this.repository);

  Future<List<MonHocEntity>> call(String major) => repository.getSubjectsByMajor(major);
}
