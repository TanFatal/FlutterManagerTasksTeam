import 'business_exception.dart';

class DataException extends BusinessException {
  const DataException({
    required super.message,
    required super.code,
  });

  factory DataException.notFound(String item) {
    return DataException(
      message: 'Không tìm thấy $item',
      code: 'DATA001',
    );
  }

  factory DataException.alreadyExists(String item) {
    return DataException(
      message: '$item đã tồn tại',
      code: 'DATA002',
    );
  }

  factory DataException.invalidData() {
    return const DataException(
      message: 'Dữ liệu không hợp lệ',
      code: 'DATA003',
    );
  }

  factory DataException.emptyList() {
    return const DataException(
      message: 'Danh sách trống',
      code: 'DATA004',
    );
  }

  factory DataException.saveFailed() {
    return const DataException(
      message: 'Lưu dữ liệu thất bại',
      code: 'DATA005',
    );
  }

  factory DataException.deleteFailed() {
    return const DataException(
      message: 'Xóa dữ liệu thất bại',
      code: 'DATA006',
    );
  }

  factory DataException.updateFailed() {
    return const DataException(
      message: 'Cập nhật dữ liệu thất bại',
      code: 'DATA007',
    );
  }
}
