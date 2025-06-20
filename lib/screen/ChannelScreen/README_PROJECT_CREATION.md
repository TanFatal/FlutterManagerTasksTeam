# Project Creation Feature

## Tổng quan

Đã thêm chức năng tạo project với date picker và member selection vào `ChannelScreen.dart`.

## Các tính năng mới

### 1. Date Picker
- ✅ Cho phép chọn ngày kết thúc project
- ✅ Validation: không cho phép chọn ngày trong quá khứ
- ✅ Hiển thị định dạng dd/MM/yyyy
- ✅ Required field - bắt buộc phải chọn

### 2. Member Selection
- ✅ Load danh sách members từ channel hiện tại
- ✅ Checkbox selection cho multiple members
- ✅ Hiển thị số lượng members đã chọn
- ✅ Required field - bắt buộc chọn ít nhất 1 member

### 3. API Integration
- ✅ Sử dụng `getAllMemberOfChannel()` từ `ChannelApiService`
- ✅ Sử dụng `createProject()` từ `ProjectService`
- ✅ Truyền đúng parameters: channelId, name, description, endDate, memberIds

## Cách sử dụng

### 1. Mở Create Project Dialog
- Nhấn vào icon star (⭐) trên AppBar của ChannelScreen
- Chỉ admin của channel mới có thể tạo project

### 2. Điền thông tin
1. **Project Name** (required): Tên dự án
2. **Description** (optional): Mô tả dự án
3. **End Date** (required): Nhấn để mở date picker
4. **Select Members** (required): Nhấn để mở dialog chọn members

### 3. Validation
- Tên project không được để trống
- Phải chọn end date
- Phải chọn ít nhất 1 member

### 4. Tạo Project
- Nhấn "Create New Project"
- Hiển thị loading và thông báo kết quả
- Tự động clear form sau khi tạo thành công

## Technical Details

### State Variables
```dart
DateTime? _selectedEndDate;
List<User> _channelMembers = [];
List<User> _selectedMembers = [];
bool _isLoadingMembers = false;
```

### Key Functions
- `_loadChannelMembers()`: Load members khi init
- `_selectEndDate()`: Mở date picker
- `_showMemberSelectionDialog()`: Mở dialog chọn members
- `_createProject()`: Gọi API tạo project

### API Calls
```dart
// Load members
final members = await _channelApiService.getAllMemberOfChannel(channelId);

// Create project
final project = await _projectService.createProject(
  channelId,
  name,
  description,
  endDate,
  memberIds,
);
```

## UI Components

### Date Picker Field
- InkWell container với border blue
- Icon calendar
- Hiển thị "Select End Date" hoặc ngày đã chọn

### Member Selection Field
- InkWell container với border blue
- Icon people
- Hiển thị "Select Members" hoặc số lượng đã chọn

### Member Selection Dialog
- StatefulBuilder để update state trong dialog
- CheckboxListTile cho mỗi member
- Hiển thị fullname và email

## Error Handling
- Loading states cho API calls
- Validation messages
- Error messages cho failed API calls
- Graceful fallbacks

## Future Enhancements
- [ ] Search members trong selection dialog
- [ ] Show selected members names thay vì chỉ số lượng
- [ ] Time picker cho end date
- [ ] Project templates
- [ ] Bulk member selection
