# DateTime Picker Implementation

## ✅ **Hoàn thành: DateTime Picker cho Project Creation**

### 🕒 **DateTime Picker Features:**

1. **Date Selection**: Chọn ngày từ date picker
2. **Time Selection**: Chọn giờ từ time picker  
3. **Combined DateTime**: Kết hợp date + time thành DateTime object
4. **Validation**: Không cho phép chọn ngày/giờ trong quá khứ
5. **Display Format**: Hiển thị `dd/MM/yyyy HH:mm`

### 📡 **API Request Format:**

```json
{
  "name": "ProjectTesst123123",
  "description": "Cái này dùng để mô tả Project", 
  "endDate": "2025-05-30T14:19:00",
  "listUser": [22, 24]
}
```

### 🔧 **Technical Implementation:**

#### DateTime Picker Function:
```dart
Future<void> _selectEndDate() async {
  // First pick date
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now().add(const Duration(days: 7)),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  
  if (pickedDate != null) {
    // Then pick time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      
      setState(() {
        _selectedEndDate = selectedDateTime;
      });
    }
  }
}
```

#### API Request Format:
```dart
Response? response = await apiService.postData(
  baseUrl + ApiConfig.project + "/channelID/" + channelId.toString(), 
  {
    "name": name,
    "description": description,
    "endDate": endDate.toIso8601String().split('.')[0], // "2025-05-30T14:19:00"
    "listUser": members // [22, 24]
  }
);
```

#### Display Format:
```dart
Text(
  _selectedEndDate == null
      ? 'Select End Date & Time'
      : DateFormat('dd/MM/yyyy HH:mm').format(_selectedEndDate!),
  // Displays: "30/05/2025 14:19"
)
```

### 🎯 **User Flow:**

1. **Tap "Select End Date & Time"**
2. **Date Picker appears** → Select date
3. **Time Picker appears** → Select time  
4. **Combined DateTime saved** → Display updated
5. **Create Project** → API call with correct format

### 📝 **Validation:**

- ✅ Date must be in future
- ✅ Time picker allows any time
- ✅ Combined validation in `_createProject()`
- ✅ Clear error messages

### 🎨 **UI Updates:**

- **Label**: "Select End Date & Time" 
- **Display**: "30/05/2025 14:19"
- **Icon**: Calendar icon
- **Styling**: Blue border container

### 🔄 **API Integration:**

- **Endpoint**: `POST /project/channelID/{channelId}`
- **DateTime Format**: `"2025-05-30T14:19:00"` (ISO 8601 without milliseconds)
- **Member IDs**: `[22, 24]` (array of integers)
- **Response**: ProjectModel object

### ✨ **Benefits:**

1. **Precise Scheduling**: Date + Time selection
2. **User Friendly**: Two-step picker process
3. **API Compatible**: Exact format match
4. **Validation**: Prevents invalid dates
5. **Visual Feedback**: Clear display format
